class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
		t.integer :user_id, null: false
		t.integer :account_id, null: false
		t.integer :approver_id
		t.string :transaction_type, null: false
		t.integer :amount, null: false
		t.timestamp :transaction_time, null: false
		t.timestamps
    end
  end
end
