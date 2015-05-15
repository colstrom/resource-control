module User
  def self.setup
    %w(ben kinnan chris andrew).each do |user|
      redis.sadd 'acl.users', user
    end
  end

  def self.exists?(user)
    redis.sismember 'acl.users', user
  end
end
