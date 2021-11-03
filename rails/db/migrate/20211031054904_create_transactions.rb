class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions, id: :uuid do |t|
      t.integer :transaction_type, null: false, default: 0
      t.references :from, type: :uuid, null: true, foreign_key: { to_table: :users }
      t.references :to, type: :uuid, null: true, foreign_key: { to_table: :users }
      t.bigint :amount, null: false, default: 0

      t.timestamps
    end
  end
end
