class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string  :name, null: false
      t.integer :path, null: false, array: true, default: []

      t.timestamps null: false
    end

    add_index :nodes, :path, using: 'gin'
  end
end
