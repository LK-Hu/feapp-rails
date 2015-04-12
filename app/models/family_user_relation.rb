class FamilyUserRelation < ActiveRecord::Base
  belongs_to :user
  belongs_to :family
end