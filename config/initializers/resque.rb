Resque.redis = ENV.fetch('REDIS_URL', 'redis://localhost:6379')
Resque.redis.namespace = ENV.fetch('RESQUE_NAMESPACE', 'resque:development')
