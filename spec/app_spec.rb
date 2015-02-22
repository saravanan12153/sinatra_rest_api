require_relative 'spec_helper'

# Cleanup after ourselves
DatabaseCleaner.strategy = :deletion
class MiniTest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

##### USERS TESTS #####

describe 'GET /users/:userid' do
  before do
    @user = User.create(first_name: 'Bill',
                        last_name:  'Preston',
                        userid:     'bpreston'
                       )
    @user_group = Group.create(name: 'users')
    @user.memberships.create(group: @user_group)
    userpath = '/users/' + @user.userid
    get userpath
  end

  it { last_response.must_be :ok? }
  it { last_response.body.must_include @user.first_name }
  it { last_response.body.must_include @user.last_name }
  it { last_response.body.must_include @user.userid }
  it { last_response.body.must_include 'groups' }
  it { last_response.headers['Content-Type'].must_equal 'application/json' }

  it 'should return 404 if user not found' do
    get '/users/mysteryman'
    last_response.must_be_not_found
  end
end

describe 'POST /users/:userid' do
  before do
    @data = {first_name: Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             userid: Faker::Internet.user_name,
             groups: ['admins', 'users']
            }
    userpath = '/users/' + @data[:userid]
    post userpath, @data.to_json, {'Content-Type' => 'application/json'}
  end

  it { last_response.must_be_created }
  it { last_response.body.must_include @data[:first_name] }
  it { last_response.body.must_include @data[:last_name] }
  it { last_response.body.must_include @data[:userid] }
  it { last_response.body.must_include 'groups' }
  it { last_response.headers['Content-Type'].must_equal 'application/json' }

  it 'should return 409 if user already exists' do
    @data = {first_name: 'Theodore',
             last_name: 'Logan',
             userid: 'tlogan',
             groups: ['admins', 'users']
            }
    userpath = '/users/' + @data[:userid]
    # First post to create the user
    post userpath, @data.to_json, {'Content-Type' => 'application/json'}
    
    # Second post should fail since it already exists
    post userpath, @data.to_json, {'Content-Type' => 'application/json'}
    last_response.status.must_equal 409
  end
end

describe 'PUT /users/:userid' do
  before do
    @data = {first_name: Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             userid: Faker::Internet.user_name,
             groups: ['admins', 'users']
            }
    userpath = '/users/' + @data[:userid]
    post userpath, @data.to_json, {'Content-Type' => 'application/json'}
  
    @data[:groups] << 'devs'
    put userpath, @data.to_json, {'Content-Type' => 'application/json'}
  end

  it { last_response.must_be_accepted }
  it { last_response.body.must_include @data[:first_name] }
  it { last_response.body.must_include @data[:last_name] }
  it { last_response.body.must_include @data[:userid] }
  it { last_response.body.must_include 'devs' }
  it { last_response.headers['Content-Type'].must_equal 'application/json' }

  it 'should return 404 if user not found' do
    put '/users/mysteryman', @data.to_json, {'Content-Type' => 'application/json'}
    last_response.must_be_not_found
  end
end

describe 'DELETE /users/:userid' do
  before do
    @data = {first_name: Faker::Name.first_name,
             last_name: Faker::Name.last_name,
             userid: Faker::Internet.user_name,
             groups: ['admins', 'users']
            }
    userpath = '/users/' + @data[:userid]
    post userpath, @data.to_json, {'Content-Type' => 'application/json'}
    delete userpath
  end

  it { last_response.must_be_ok }

  it 'should return 404 if user not found' do
    delete '/users/mysteryman'
    last_response.must_be_not_found
  end
end


##### GROUPS TESTS #####

describe 'GET /groups/:groupname' do
  before do
    @user1 = User.create(first_name: 'Bill',
                        last_name:  'Preston',
                        userid:     'bpreston'
                       )
    @user2 = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         userid: Faker::Internet.user_name
                        )
    @user3 = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         userid: Faker::Internet.user_name
                        )
    @group = Group.create(name: Faker::Lorem.word)
    users = [@user1, @user2, @user3]
    users.each do |user|
      user.memberships.create(group: @group)
    end
    grouppath = '/groups/' + @group.name
    get grouppath
  end

  it { last_response.must_be :ok? }
  it { last_response.body.must_include @user1.userid }
  it { last_response.body.must_include @user2.userid }
  it { last_response.body.must_include @user3.userid }
  it { last_response.headers['Content-Type'].must_equal 'application/json' }

  it 'should return 404 if group not found' do
    get '/groups/secretsquirrel'
    last_response.must_be_not_found
  end
end

describe 'POST /groups/:groupname' do
  before do
    @data = { name: Faker::Lorem.word }
    grouppath = '/groups/' + @data[:name]
    post grouppath, @data.to_json, {'Content-Type' => 'application/json'}
  end

  it { last_response.must_be_created }
  it { last_response.body.must_include @data[:name] }
  it { last_response.headers['Content-Type'].must_equal 'application/json' }

  it 'should return 409 if group already exists' do
    @data = { name: Faker::Lorem.word }
    grouppath = '/groups/' + @data[:name]
    # First post to create the group
    post grouppath, @data.to_json, {'Content-Type' => 'application/json'}
    
    # Second post should fail since it already exists
    post grouppath, @data.to_json, {'Content-Type' => 'application/json'}
    last_response.status.must_equal 409
  end
end

describe 'PUT /groups/:groupname' do
  before do
    @user1 = User.create(first_name: 'Bill',
                         last_name:  'Preston',
                         userid:     'bpreston'
                        )
    @user2 = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         userid: Faker::Internet.user_name
                        )
    @user3 = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         userid: Faker::Internet.user_name
                        )
    @user4 = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         userid: Faker::Internet.user_name
                        )
    @user5 = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         userid: Faker::Internet.user_name
                        )
    @data = { users: [ @user1.userid,
                       @user2.userid,
                       @user3.userid,
                       @user4.userid,
                       @user5.userid
                      ]
            }
    @group = Group.create(name: Faker::Lorem.word)
    @grouppath = '/groups/' + @group.name
    put @grouppath, @data.to_json, {'Content-Type' => 'application/json'}
  end

  it 'should add new users to the group' do
    put @grouppath, @data.to_json, {'Content-Type' => 'application/json'}
    last_response.must_be_accepted
    last_response.body.must_equal @data.to_json
    last_response.headers['Content-Type'].must_equal 'application/json'
    @group.users.count.must_equal 5
  end

  it 'should remove missing users from the group' do
    2.times { @data[:users].shift }
    put @grouppath, @data.to_json, {'Content-Type' => 'application/json'}
    last_response.must_be_accepted
    last_response.body.must_equal @data.to_json
    last_response.headers['Content-Type'].must_equal 'application/json'
    @group.users.count.must_equal 3
  end

  it 'should return 404 if group not found' do
    put '/groups/secretsquirrel', @data.to_json, {'Content-Type' => 'application/json'}
    last_response.must_be_not_found
  end
end

describe 'DELETE /groups/:groupname' do
  before do
    @group = Group.create(name: Faker::Lorem.word)
    @user1 = User.create(first_name: 'Bill',
                         last_name:  'Preston',
                         userid:     'bpreston'
                        )
    @user2 = User.create(first_name: Faker::Name.first_name,
                         last_name: Faker::Name.last_name,
                         userid: Faker::Internet.user_name
                        )
    @grouppath = '/groups/' + @group.name
    users = [@user1, @user2]
    users.each do |user|
      user.memberships.create(group: @group)
    end
  end

  it 'should remove all users from the group' do
    delete @grouppath
    last_response.must_be_ok
    @group.users.count.must_equal 0
  end

  it 'should return 404 if group not found' do
    delete '/groups/secretsquirrel'
    last_response.must_be_not_found
  end
end
