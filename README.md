Sinatra REST API Project
=================

For a recent interview, I was asked to complete a small project. The requirements for the project are detailed below, but basically I was asked to implement a basic REST API that accepts and returns JSON objects.

Although I was given free choice of language to use and most of my experience has been in Ruby on Rails, I used this project as an opportunity to start learning Sinatra. This is the result of my first look and attempt at using the Sinatra framework. 

Project Description
------------
This is a Sinatra app to implement a REST API service for storing, fetching, and updating user records and group memberships. A user record is a JSON hash like so:

```
{"first_name": "Joe",
 "last_name": "Smith",
 "userid": "jsmith",
 "groups": ["admins", "users"]}
```

Feature Requirements
------------
```GET /users/<userid>```
Returns the matching user record or 404 if none exist.

```POST /users/<userid>```
Creates a new user record. The body of the request should be a valid user record. POSTs to an existing user should be treated as errors and flagged with the appropriate HTTP status code.

```DELETE /users/<userid>```
Deletes a user record. Returns 404 if the user doesn't exist.

```PUT /users/<userid>```
Updates an existing user record. The body of the request should be a valid user record. PUTs to a non-existant user should return a 404.

```GET /groups/<group name>```
Returns a JSON list of userids containing the members of that group. Should return a 404 if the group doesn't exist or has no members.

```POST /groups/<group name>```
Creates a empty group. POSTs to an existing group should be treated as errors and flagged with the appropriate HTTP status code.

```PUT /groups/<group name>```
Updates the membership list for the group. The body of the request should be a JSON list describing the group's members.

```DELETE /groups/<group name>```
Removes all members from the named group. Should return a 404 for unknown groups.

Assumptions
-------------------
This implementation assumes the following:
* no authentication is desired
* no versioning support is required
* this REST API will not require a frontend client for usage
* results and output are desired in JSON format

Installation Notes
--------------------
Clone the repo and change directory into it:
```bash
git clone https://github.com/vidkun/sinatra_rest_api.git
cd sinatra_rest_api
```
Install required gems:
```bash
bundle install
```
Run database migrations:
```bash
rake db:migrate
```
Run app:
```bash
ruby app.rb
```

Test Suite
--------------------
There is full test coverage for all feature requirements.
To run test suite:
```bash
rake test
```


Original README from project
=================
Starter Project
=================

Description
------------
Implement a REST service to store, fetch, and update user records. A user record is a JSON hash like so:

```
{"first_name": "Joe",
 "last_name": "Smith",
 "userid": "jsmith",
 "groups": ["admins", "users"]}
```

```GET /users/<userid>```
Returns the matching user record or 404 if none exist.

```POST /users/<userid>```
Creates a new user record. The body of the request should be a valid user record. POSTs to an existing user should be treated as errors and flagged with the appropriate HTTP status code.

```DELETE /users/<userid>```
Deletes a user record. Returns 404 if the user doesn't exist.

```PUT /users/<userid>```
Updates an existing user record. The body of the request should be a valid user record. PUTs to a non-existant user should return a 404.

```GET /groups/<group name>```
Returns a JSON list of userids containing the members of that group. Should return a 404 if the group doesn't exist or has no members.

```POST /groups/<group name>```
Creates a empty group. POSTs to an existing group should be treated as errors and flagged with the appropriate HTTP status code.

```PUT /groups/<group name>```
Updates the membership list for the group. The body of the request should be a JSON list describing the group's members.

```DELETE /groups/<group name>```
Removes all members from the named group. Should return a 404 for unknown groups.

Implementation Notes
--------------------
Acceptable implementation languages are Java, Ruby, Erlang, JavaScript, and Intercal.

Any design decisions not specified herein are fair game. Completed projects will be evaluated on how closely they follow the spec, their design, and cleanliness of implementation.

Completed projects must include a README with enough instructions for evaluators to build and run the code. Bonus points for builds which require minimal manual steps.

Remember this project should take a maximum of 8 hours to complete. Do not get hung up on scaling or persistence issues. This is a project used to evaluate your design and coding skills only.




