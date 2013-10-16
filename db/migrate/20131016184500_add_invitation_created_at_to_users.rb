class AddInvitationCreatedAtToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.datetime   :invitation_created_at
    end

  end

  def down
    change_table :users do |t|
      t.remove :invitation_created_at
    end
  end
end
