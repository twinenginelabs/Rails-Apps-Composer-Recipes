class User < ActiveRecord::Base
  devise :database_authenticatable, 
         :omniauthable, 
         :recoverable, 
         :registerable, 
         :rememberable, 
         :trackable, 
         :validatable

  has_many :authentications, :dependent => :destroy
  has_and_belongs_to_many :roles

  has_attached_file :avatar, PAPERCLIP_OPTIONS.merge!(
    :styles => {"150x150" => "150x150^"},
    :convert_options => {
      "150x150" => "-background transparent -gravity center -extent 140x140"
    }
  )

  validates_presence_of :email

  before_save :ensure_authentication_token

  # Allow logins via username OR email
  attr_accessor :login
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
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

  def apply_developer_data(auth)
    self.email = auth.info.email
    self.full_name = auth.info.name
    self.password = Devise.friendly_token[0,20]

    create_or_update_authentication(auth)
  end

  def apply_facebook_data(auth)
    self.email = auth.info.email if email.blank?
    self.full_name = auth.info.name if full_name.blank?
    self.first_name = auth.info.first_name if first_name.blank?
    self.last_name = auth.info.last_name if last_name.blank?
    self.current_city = auth.info.location if current_city.blank?
    self.gender = auth.extra.raw_info.gender if gender.blank?
    self.password = Devise.friendly_token[0,20] if password.blank?

    create_or_update_authentication(auth)
  end

  def apply_instagram_data(auth)
    self.username = auth.info.nickname if username.blank?
    self.full_name = auth.info.name if full_name.blank?
    self.password = Devise.friendly_token[0,20] if password.blank?

    create_or_update_authentication(auth)
  end

  def apply_twitter_data(auth)
    self.username = auth.info.nickname if username.blank?
    self.full_name = auth.info.name if full_name.blank?
    self.current_city = auth.info.location if current_city.blank?
    self.password = Devise.friendly_token[0,20] if password.blank?

    create_or_update_authentication(auth)
  end

  def apply_youtube_data(auth)
    self.email = auth.info.email if email.blank?
    self.full_name = auth.info.nickname if full_name.blank?
    self.first_name = auth.info.first_name if first_name.blank?
    self.last_name = auth.info.last_name if last_name.blank?
    self.current_city = auth.info.location if current_city.blank?
    self.password = Devise.friendly_token[0,20] if password.blank?

    create_or_update_authentication(auth)
  end

  private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).count > 0
    end
  end
  
  def create_or_update_authentication(auth)
    existing_authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])

    if existing_authentication
      existing_authentication.update_attributes(:user_id => self.id, :token => auth['credentials']['token'])
    else
      authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'])
    end
  end

end