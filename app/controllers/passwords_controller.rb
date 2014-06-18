class PasswordsController < Devise::PasswordsController
  protected
    def after_resetting_password_path_for(resource)
       home_path
    end
end