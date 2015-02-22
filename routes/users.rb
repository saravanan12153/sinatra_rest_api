# routes/users.rb - User routes
get '/users' do
  content_type :json
  User.all.to_json
end

get '/users/:userid' do
  content_type :json
  return status 404 unless User.exists?(userid: params[:userid])
  User.build_user(params[:userid]).to_json
end

post '/users/:userid' do
  content_type :json
  return status 409 if User.exists?(userid: params[:userid])
  body = JSON.parse request.body.read
  user = User.create(first_name: body['first_name'],
                     last_name:  body['last_name'],
                     userid:     body['userid']
                     )
  body['groups'].each do |group_name|
    group = Group.find_or_create_by(name: group_name)
    user.memberships.create(group: group) 
  end
  status 201
  User.build_user(params[:userid]).to_json
end

put '/users/:userid' do
  content_type :json
  body = JSON.parse request.body.read
  user = User.find_by_userid(params[:userid])
  return status 404 if user.nil?
  user.update(first_name: body['first_name'],
              last_name:  body['last_name'],
              userid:     body['userid'] 
              )
  body['groups'].each do |group_name|
    unless user.groups.any? { |g| g.name == group_name } 
      group = Group.find_or_create_by(name: group_name)
      user.memberships.create(group: group) 
    end
  end
  user.groups.each do |group|
    membership = user.memberships.find_by(group: group)
    membership.destroy unless body['groups'].include? group.name
  end
  return status 500 unless user.save
  status 202
  User.build_user(params[:userid]).to_json
end

delete '/users/:userid' do
  user = User.find_by_userid(params[:userid])
  return status 404 if user.nil?
  return status 500 unless user.destroy
end