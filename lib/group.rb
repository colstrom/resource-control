module Group
  def self.setup
    %w(dev-telus.com devops management).each do |group|
      redis.sadd 'acl.groups', group
    end
  end

  def self.add_to(group, user)
    redis.sadd "acl.group.#{group}", user if exists? group
    redis.sadd "acl.user.#{user}.groups", group
  end

  def self.exists?(group)
    redis.sismember 'acl.groups', group
  end
end
