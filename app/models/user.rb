# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer          default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
#  authentication_token   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  include NotDeleteable
  versioned

  has_and_belongs_to_many :roles
  has_and_belongs_to_many :merchants
  has_and_belongs_to_many :causes
  has_many :serves

  before_save :setup_role

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable,
         :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids, :merchant_ids, :cause_ids
  # attr_accessible :title, :body

  # Default role is "User"
  
  def setup_role 
    if self.role_ids.empty?     
      self.role_ids = [Role.find_by_name("User").id] 
    end
  end
  
  def role?(role)
      return !!self.roles.find_by_name(role.to_s.camelize)
  end 

  def self.GetUserID(user)
    if self.find_by_email(user).nil?
      self.invite!(email: user)
    end
    return self.find_by_email(user).id
  end


end
