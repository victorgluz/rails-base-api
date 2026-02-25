module CacheHelper
  def cache_get(key)
    redis.get(key)
  end

  def cache_set(key, value, ttl: nil)
    if ttl
      redis.setex(key, ttl, value.to_s)
    else
      redis.set(key, value.to_s)
    end
  end

  def cache_delete(key)
    redis.del(key)
  end

  private

  def redis
    @redis ||= Redis.new(url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" })
  end
end
