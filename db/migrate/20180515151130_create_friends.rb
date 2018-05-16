class CreateFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :friends do |t|
      t.belongs_to :user, index: true
      t.belongs_to :friend, index: true
      t.boolean :accepted, default: false

      t.timestamps
    end
  end
end