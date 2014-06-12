class User < ActiveRecord::Base
  include Bubot

  watch(:apply_facebook_data, timeout: 3) do |user, time, response|
    Airbrake.notify(
      error_class: "Facebook Timeout:",
      error_message: "Applying Facebook data took longer than expected. (User id: #{user.id}, Time: #{time}s)",
      backtrace: $@,
      environment_name: Rails.env
    )
  end

  devise :database_authenticatable, 
         :omniauthable, 
         :recoverable, 
         :registerable, 
         :rememberable, 
         :trackable, 
         :validatable

  has_many :authentications, dependent: :destroy
  has_and_belongs_to_many :roles

  has_attached_file :avatar, PAPERCLIP_OPTIONS.merge(
    styles: { square: ["150x150^", :png] },
    convert_options: {
      square: "-background transparent -gravity north -extent 140x140"
    }
  )

  before_save :ensure_authentication_token
  before_save :sanitize_and_pad_phone_number

  validates_attachment_content_type :avatar, content_type: ["image/jpg", "image/jpeg", "image/png"]

  scope :with_social_uids, ->(provider, uids) { joins(:authentications).where(authentications: { provider: provider, uid: uids }) }
  scope :who_arent, ->(user) { where.not(id: user.id) }

  scoped_search on: [:full_name, :first_name, :last_name, :email]

  # ------- Boilerplate Defaults -------

  # Allow logins via username OR email OR phone number
  attr_accessor :login
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["
        lower(username) = :login OR 
        lower(email) = :login OR 
        lower(phone_number) = :login OR 
        lower(phone_number) = :padded_login", 
        login: login.downcase, padded_login: login.rjust(11, "1")]).first
    else
      where(conditions).first
    end
  end

  def after_token_authentication
    reset_authentication_token!
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def sanitize_and_pad_phone_number
    return unless self.phone_number
    self.phone_number = self.phone_number.gsub(/\D/, "").rjust(11, "1")
    self.valid?
  end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
    save
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).count > 0
    end
  end

  def set_roles(role_names)
    self.roles = []

    (role_names || []).each do |role|
      r = Role.where(["name ILIKE ?", role.to_s]).first
      self.roles.push(r) if r
    end

    self.save
  end

  def add_role(role_name)
    unless role? role_name
      role_names = get_roles
      role_names.push(role_name.to_sym)
      set_roles(role_names)
      self.save
    end
  end

  def get_roles
    self.roles.map { |r| r.name.to_sym.downcase }
  end

  def role?(role)
    get_roles.include? role.to_sym.downcase
  end

  def admin?
    role?(:admin)
  end

  def name
    if !first_name.blank? && !last_name.blank?
      first_name + " " + last_name
    elsif !full_name.blank?
      full_name
    elsif !first_name.blank?
      first_name
    elsif !last_name.blank?
      last_name
    else
      "No Name"
    end
  end

  def age
    if birthday
      now = Date.today
      now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    end
  end

  # ---- External provider data

  def self.find_or_create_relevant_user_for_provider(provider, uid, token, user_info, current_user)
    authentication = Authentication.find_by_provider_and_uid(provider, uid)
    if current_user
      if authentication
        authentication.update_attributes(token: token)
        authentication.user
      else
        current_user.authentications.create(provider: provider, uid: uid, token: token)
        current_user
      end
    else
      if authentication && authentication.user
        authentication.update_attributes(token: token)
        authentication.user.send("apply_#{provider}_data", uid, token, user_info)
        authentication.user
      else
        user = if user_info[:email].blank?
          User.new
        else
          User.where(email: user_info[:email]).first_or_initialize
        end
        user.send("apply_#{provider}_data", uid, token, user_info)
        user
      end
    end
  end

  def apply_facebook_data(uid, token, user_info)
    self.full_name = user_info[:name] if full_name.blank?
    self.first_name = user_info[:first_name] if first_name.blank?
    self.last_name = user_info[:last_name] if last_name.blank?
    self.current_city = user_info[:location].try(:name) if current_city.blank?
    self.gender = user_info[:gender] if gender.blank?
    self.password = Devise.friendly_token[0,20] if password.blank?

    return unless self.save

    create_or_update_authentication(:facebook, uid, token)
  end

  protected

  def email_required?
    true
  end

  private

  def create_or_update_authentication(provider, uid, token)
    existing_authentication = Authentication.find_by_provider_and_uid(provider, uid)

    if existing_authentication
      existing_authentication.update_attributes(:user_id => self.id, :token => token)
    else
      authentications.build(:provider => provider, :uid => uid, :token => token)
    end
  end

end