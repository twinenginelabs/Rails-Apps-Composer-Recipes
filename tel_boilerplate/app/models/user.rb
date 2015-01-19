class User < ActiveRecord::Base

  acts_as_paranoid
  has_paper_trail

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable

  has_many :identities, dependent: :destroy
  has_and_belongs_to_many :roles, Proc.new { uniq }

  has_attached_file :avatar, PAPERCLIP_OPTIONS.merge(
    styles: { square: ["150x150^", :png] },
    convert_options: {
      square: "-background transparent -gravity north -extent 140x140"
    }
  )

  before_save :ensure_authentication_token

  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  scoped_search on: [:name, :email]

  # ------- Boilerplate Defaults -------

  def after_token_authentication
    reset_authentication_token!
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
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

  # ---- External provider data

  def self.find_for_oauth(auth, signed_in_resource = nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user

    if user.nil?
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          email: email ? email : "change-me@#{auth.provider}-#{auth.uid}.com",
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end

    user
  end

  def identity_for(provider)
    self.identities.where(provider: provider).first
  end

end