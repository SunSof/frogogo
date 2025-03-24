class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts, id: :uuid do |t|
      t.integer :status, default: 0, null: false
      t.integer :discount, default: 0

      t.timestamps
    end
  end
end
