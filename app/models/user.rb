class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :username, :is_admin, :terms, :marketing, :chinese_name,
                  :address, :phone, :bank, :bank_num, :account, :account_num,
                  :money_can_apply, :money_already_earned
  # attr_accessible :title, :body
  has_many :products
  has_many :consignments
  has_many :consignment_products, through: :consignments
  has_many :billings

  validates :terms, :inclusion => {:in => [true]}

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.name
      user.email = auth.info.email
      user.confirm!
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create an user with a stub password.
      user = User.new(:email => data["email"], :password => Devise.friendly_token[0,20],  :agreement_status => true)
      user.confirm!
      user.save!
      user
    end
  end

  def can_apply?
    money_can_apply != 0 && !Billing.have_open_for_user?(self)
  end

  def applying?
    Billing.have_open_for_user?(self)
  end
end
