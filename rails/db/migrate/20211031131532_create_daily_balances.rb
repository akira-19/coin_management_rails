class CreateDailyBalances < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_balances, id: :uuid  do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.bigint :balance, null: false, default: 0
      t.date :target_date, null: false

      t.timestamps
    end
  end
end
