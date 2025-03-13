class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.integer :quantity, default: 1
      t.references :cart, type: :uuid, foreign_key: true
      t.references :product, foreign_key: true
      
      t.timestamps
    end
    add_index :cart_items, [:cart_id, :product_id], unique: true
  end
end
