class Family < ActiveRecord::Base
	validates :family_name, presence: true, uniqueness: true	
	has_many :users, through: :family_user_relations
  has_many :family_user_relations
end