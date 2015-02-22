# models/membership.rb - Membership model
class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  
  validates :user_id,
            :group_id, presence: true
end
