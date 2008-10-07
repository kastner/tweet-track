class Nudges < ActiveRecord::Migration
  def self.up
    create_table :nudges do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :user_id, :integer
      t.column :message, :string
    end
  end

  def self.down
    drop_table :nudges
  end
end
