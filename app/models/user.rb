class User < ActiveRecord::Base
  before_save :ensure_authentication_token!
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	validates :user_name, presence: true, uniqueness: true
  include ActiveModel::Serialization
	
	has_many :families, through: :family_user_relations
  has_many :family_user_relations
	has_many :accounts
	has_many :transactions
	
  def ensure_authentication_token!
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def reset_authentication_token!
    self.authentication_token = generate_authentication_token
  end

  private
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end
