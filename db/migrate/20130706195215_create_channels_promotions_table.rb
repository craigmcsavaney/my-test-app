class CreateChannelsPromotionsTable < ActiveRecord::Migration
  def self.up
  	create_table :channels_promotions, :id => false do |t|
  		t.references :channel,    :null => false
  		t.references :promotion,  :null => false
	  end
    add_index :channels_promotions, [:promotion_id, :channel_id], unique: true
  end

  def self.down
  	drop_table :channels_promotions
  end
end
