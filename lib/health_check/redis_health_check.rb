module HealthCheck
  class RedisHealthCheck
    extend BaseHealthCheck

    def initialize()
      unless defined?(::Redis)
        raise "Wrong configuration. Missing 'redis' gem"
      end

      @redis_client ||= ::Redis.new(url: HealthCheck.redis_url)
    end

    def self.check
      res = @redis_client.ping
      res == 'PONG' ? '' : "Redis.ping returned #{res.inspect} instead of PONG"
    rescue Exception => e
      create_error 'redis', e.message
    end
  end
end
