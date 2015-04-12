class RenameFamiliesUsersToFamilyUserRelations < ActiveRecord::Migration
  def change
    rename_table :families_users, :family_user_relations
  end
end
