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
  has_and_belongs_to_many :singles, association_foreign_key: 'cause_id', join_table: 'causes_users'
  has_and_belongs_to_many :groups, association_foreign_key: 'cause_id', join_table: 'causes_users'
  has_many :serves
  has_many :donations

  before_save :setup_role

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable,
         :timeoutable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :encrypted_password, :remember_me, :role_ids, :merchant_ids, :cause_ids, :password, :password_confirmation
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

  # This is called from the API serve and update methods.  The input should be an email address, and the function returns a user id.  If the input email does not match any emails in the User table, a new user is created by Devise-Invitable and an invitation is sent to the email address with a confirmation link.  Then the permanent user cookie is updated with the new email address.  If the email address already exists in the User table, the id of the user record is returned.
  def self.GetUserID(user)
    @type = ""
    @user_id = nil
    if self.find_by_email(user).nil?
      self.invite!(email: user)
      @type = "new"
    end
    @user_id = self.find_by_email(user).id
    return {user_id: @user_id, type: @type}
  end

  def view_admin_menu
    # this is a placeholder method.  Used by CanCan to determine if a user should see the admin menu.
  end


end
