class Account < ActiveRecord::Base
	validates :user_id, presence: true
	validates_uniqueness_of :account_type, :scope => :user_id
	belongs_to :user
end