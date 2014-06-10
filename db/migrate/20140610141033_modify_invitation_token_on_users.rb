class ModifyInvitationTokenOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :invitation_token, :string, :limit => nil
  end
end
