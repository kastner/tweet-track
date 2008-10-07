class Initial < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.column :sent_at, :datetime
      t.column :sender_id, :integer
      t.column :user_id, :integer
      t.column :tweet_id, :integer
      t.column :raw_text, :string
      t.column :created_at, :datetime
    end
    
    create_table :updates do |t|
      t.column :variable, :string
      t.column :value, :float
      t.column :tweet_id, :integer
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
  end
end
