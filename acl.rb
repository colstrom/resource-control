#!/usr/bin/env ruby

require 'redis'

require_relative 'lib/user'
require_relative 'lib/group'
require_relative 'lib/resource'

def redis
  @redis ||= Redis.new
end

user, resource, value = ARGV.pop 3

Group.setup unless redis.exists 'acl.groups'
User.setup unless redis.exists 'acl.users'

Group.add_to 'dev', 'ben'
Group.add_to 'ops', 'chris'

Resource.grant 'onlyops', 'ops'

if User.exists?(user) and Resource.allowed?(resource, user)
  Resource.change resource, value
  puts Resource.read resource
else
  puts "#{resource} is #{Resource.read resource}"
end
