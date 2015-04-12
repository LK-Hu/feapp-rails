class AddIndexToFamiliesUsers < ActiveRecord::Migration
  def change
    add_index :families_users, :user_id
    add_index :families_users, :family_id
  end
end
