class AddIndexes < ActiveRecord::Migration
  def change
    add_index :tags, [:note_id, :id]
  end
end
