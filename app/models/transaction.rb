class Transaction < ActiveRecord::Base
	validates :account_id, presence: true
	belongs_to :user
	belongs_to :account
end