require "killswitch/version"
require "active_support/time"
require "rails"

module Killswitch
  class Switch
    class Error < StandardError; end

    KILLSWITCH_ENABLED_KEY = "worker_killswitch_enabled".freeze
    RETRY_AFTER = 5.seconds

    def initialize(cache: nil, metrics_provider: nil)
      @cache = cache ? cache : Rails.cache
      @metrics_provider = metrics_provider
    end

    def enable
      @cache.write(KILLSWITCH_ENABLED_KEY, true)
    end

    def disable
      @cache.write(KILLSWITCH_ENABLED_KEY, false)
    end

    def enabled?
      status = @cache.fetch(KILLSWITCH_ENABLED_KEY)
      status ? status : false
    rescue StandardError => e
      false
    end

    def wait_for_resume
      Kernel.sleep(RETRY_AFTER + random_sub_sleep)
    end

    def random_sub_sleep
      Kernel.rand(0.0..1.0)
    end
  end
end
