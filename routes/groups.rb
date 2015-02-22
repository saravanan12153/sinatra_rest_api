# routes/groups.rb - Group routes
get '/groups' do
  content_type :json
  Group.all.to_json
end

get '/groups/:name' do
  content_type :json
  group = Group.find_by_name(params[:name])
  return status 404 if group.nil? || group.users.empty?
  members = Hash.new
  members[:users] = Array.new
  group.users.each do |user|
    members[:users] << user.userid
  end
  members.to_json
end

post '/groups/:name' do
  content_type :json
  return status 409 if Group.exists?(name: params[:name])
  group = Group.create(name: params[:name])
  status 201
  group.to_json
end

put '/groups/:name' do
  content_type :json
  body = JSON.parse request.body.read
  group = Group.find_by_name(params[:name])
  return status 404 if group.nil?
  body['users'].each do |userid|
    return status 500 unless user = User.find_by(userid: userid)
    unless group.users.any? { |u| u.userid == userid }
      group.memberships.create(user: user) 
    end
  end
  group.users.each do |user|
    membership = group.memberships.find_by(user: user)
    membership.destroy unless body['users'].include? user.userid
  end
  return status 500 unless group.save
  status 202
  group.to_json
  members = Hash.new
  members[:users] = Array.new
  Group.find_by_name(params[:name]).users.each do |user|
    members[:users] << user.userid
  end
  members.to_json
end

delete '/groups/:name' do
  group = Group.find_by_name(params[:name])
  return status 404 if group.nil?
  group.memberships.each do |membership|
    membership.destroy
  end
  return 500 unless group.save
end