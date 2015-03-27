class CreateFamiliesUsers < ActiveRecord::Migration
  def change
    create_table :families_users do |t|
		t.integer :family_id, :null => false
		t.integer :user_id, :null => false
		t.timestamps
    end
  end
end
