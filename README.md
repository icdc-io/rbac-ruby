# RBAC Ruby

A simple way to manage access and visibillity scopes to objects in your Rails applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rbac-ruby'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rbac

## Requirements
Your application should contain model User with methods `current_user` which will return attributes to filtering your objects.


## Usage

Write config file with buissiness logic (see examples). Include Rbac modules into your application. And have fun :)

EXAMPLE:

Models:
- HelpdeskSystem
- Project
- Request
- User (can be abstract model)

Relations:
- HelpdeskSystem 1-M Project
- Project 1-M Request

Roles:
- admin (can see and modify each object in application)
- supported (can see and modify each object in region)
- guest (can see and modify own request into projects which available in region)



```ruby
# For example class User.
# Cause User.current_user IS REQUIRED for this gem
class User
  attr_reader :userid, :region, :role
  thread_mattr_accessor :current_user

  def initialize(opts)
    @userid = opts[:userid]
    @region = opts[:region]
    @role = opts[:role]
  end
end
```

Define a [RBAC Routes file](https://github.com/ahrechushkin/rbac-ruby/blob/master/rbac_routes.example.yml) which configure access to controllers for autheticated users and include to your controllers and write custom buissiness logic.

Define a [RBAC Scopes file](https://github.com/ahrechushkin/rbac-ruby/blob/master/rbac_scopes.example.yml) which containe logic how our application will filter records and include Rbac::Filterer into app/models/application.rb (to include filtering method to all models) OR into specific model to use filtation only here. Now you can call Model.filtered (e.g. HelpdeskSystem.filtered, Project.filtered, Request.filtered)








