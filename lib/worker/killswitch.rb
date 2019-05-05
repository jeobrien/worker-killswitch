require 'worker/killswitch/config'
require "active_support/time"
require "rails"

module Worker
  module Killswitch

    class << self
      KILLSWITCH_ENABLED_KEY = "worker_killswitch_enabled".freeze
      RETRY_AFTER = 5.seconds

      def config
        config ||= Config.new
      end

      def configure(&block)
        yield config
      end

      def logger
        config.logger
      end

      def cache
        config.cache
      end

      def metrics_provider
        config.metrics_provider
      end

      def enable
        metrics_provider&.count("Killswitch::Toggle.enabled", 1)
        metrics_provider&.event("workers_killswitch_enabled", "Worker Killswitch Enabled")

        cache.write(KILLSWITCH_ENABLED_KEY, true)
      end

      def disable
        metrics_provider&.count("Killswitch::Toggle.disabled", 1)
        metrics_provider&.event("workers_killswitch_disabled", "Worker Killswitch Disabled")

        cache.write(KILLSWITCH_ENABLED_KEY, false)
      end

      def enabled?
        status = cache.fetch(KILLSWITCH_ENABLED_KEY)
        status ? status : false
      rescue StandardError => e
        # If there are any cache connectivity issues, the switch fails open.
        metrics_provider&.increment("Killswitch::Toggle.cache_failure", tags: { exception: e.class.to_s })
        false
      end

      def wait_for_resume
        Kernel.sleep(RETRY_AFTER + random_sub_sleep)
      end

      # So that we aren’t having all workers polling at exactly the same time
      def random_sub_sleep
        Kernel.rand(0.0..1.0)
      end
    end

  end
end
