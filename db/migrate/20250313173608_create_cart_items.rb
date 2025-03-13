class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.integer :quantity, default: 1
      t.decimal :price, precision: 10, scale: 2
      t.references :cart, type: :uuid, foreign_key: true
      t.references :product, foreign_key: true
      
      t.timestamps
    end
  end
end
