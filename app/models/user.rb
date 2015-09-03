class User
  include Mongoid::Document
  include Mongoid::Timestamps::Created


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable

  field :provider, type: String, default: ""

  field :encrypted_password, type: String, default: ""


  field :role,               type: String, default: "visitor"

  field :fullname,           type: String, default: ""
  field :username,           type: String, default: ""
  index({ username: 1 }, { unique: true, name: "username_index" })

  field :email,              type: String, default: ""
  index({ email: 1 }, { unique: true, name: "email_index" })

  ## SMS authenticatable
  field :phone,              type: String, default: ""
  index({ phone: 1 }, { unique: true, name: "phone_index" })


  field :access_token, type: String, default: ""


  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
   field :confirmation_token,   type: String
   field :confirmed_at,         type: Time
   field :confirmation_sent_at, type: Time
   field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time

  validates :fullname, length: { minimum: 3, maximum: 46 }

  validates :username, length: { minimum: 3, maximum: 30 }

  validates :username, :uniqueness => true
  validates :username, :presence => true

  validates :username, format: { with: /\A([a-z0-9_]+)\z/}

  validates :email, :email => true, :if => "email.present?"
  validates :email, :uniqueness => true, :if => "email.present?"

  validates :phone, :presence => true, :if => "phone.present?" #FIXME : Remove require
  validates :phone, :uniqueness => true

  validate :phone_format
  
  before_save :set_default_username

  def set_default_username
    if self.username.present?
      self.username = self.username.mb_chars.downcase
    else
      self.username = self.generate_username
    end
  end

  def generate_username
    i = nil
    loop do
      u = self.fullname.parameterize('_')[0,MAX_USERNAME_LENGTH-i.to_s.length] + i.to_s
      break u unless self.class.where(:username => u ).first
      i = i.to_i + 1
    end
  end

   def phone_format
    unless self.phone and self.phone.match(/^\+[0-9]{9,15}$/)
      errors.add(:phone, :phone_format)
    end
  end

end
