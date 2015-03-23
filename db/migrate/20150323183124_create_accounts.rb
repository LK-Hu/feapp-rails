class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
		t.integer :user_id, null: false
		t.string :account_type, null: false
		t.integer :balance
		t.integer :interest
		t.string :interest_period
		t.integer :total_credit
		t.timestamps
    end
  end
end
