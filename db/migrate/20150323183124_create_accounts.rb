class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
		t.integer :user_id, null: false
		t.string :account_type, null: false
		t.integer :balance
		t.integer :accumulated_interest
		t.integer :interest_rate
		t.string :interest_period
		t.integer :total_credit
		t.timestamp :last_interest
		t.timestamps
    end
  end
end
