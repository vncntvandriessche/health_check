module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck

    def self.check
      unless defined?(::Redis)
        raise "Wrong configuration. Missing 'redis' gem"
      end

      redis_client ||= ::Redis.new(url: HealthCheck.redis_url)
      res = redis_client.ping
      res == 'PONG' ? '' : "Redis.ping returned #{res.inspect} instead of PONG"
    rescue Exception => e
      create_error 'redis', e.message
    ensure
      redis_client.disconnect!
    end
  end
end
