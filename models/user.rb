# models/user.rb - User model
class User < ActiveRecord::Base
  has_many :memberships
  has_many :groups, through: :memberships

  validates :userid, presence: true

  def self.build_user(userid)
    user = User.find_by_userid(userid)
    result = user.as_json(except: [:id, :created_at, :updated_at])
    result['groups'] = Array.new
    user.groups.each do |group|
      result['groups'] << group.name
    end
    result
  end
end
