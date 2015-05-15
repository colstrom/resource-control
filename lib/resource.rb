module Resource
  def self.read(resource)
    redis.get "acl.resource.#{resource}"
  end

  def self.change(resource, value)
    redis.set "acl.resource.#{resource}", value
  end

  def self.allowed?(resource, user)
    redis.sinter("acl.resource.#{resource}.writable", "acl.user.#{user}.groups").length > 0
  end

  def self.grant(resource, group)
    if group.respond_to? :each
      grant_multiple resource, group
    else
      redis.sadd "acl.resource.#{resource}.writable", group
    end
  end

  def self.grant_multiple(resource, groups)
    groups.each do |group|
      grant resource, group
    end
  end

  def self.revoke(resource, group)
    if group.respond_to? each
      revoke_multiple resource, group
    else
      redis.srem "acl.resource.#{resource}.writable", group
    end
  end

  def self.revoke_multiple(resource, groups)
    groups.each do |group|
      revoke resource, group
    end
  end
end
