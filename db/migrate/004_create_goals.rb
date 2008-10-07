class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.column :user_id, :integer
      t.column :variable, :string
      t.column :amount, :float
      t.column :end_date, :datetime
      t.column :notes, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :goals
  end
end
