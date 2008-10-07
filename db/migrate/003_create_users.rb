class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :screen_name, :string
      t.column :twitter_id, :integer
      t.column :openid_url, :string
      t.column :alert_address, :string
      t.column :nudge_frequency, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :users
  end
end
