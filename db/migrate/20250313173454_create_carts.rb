class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts, id: :uuid do |t|
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
