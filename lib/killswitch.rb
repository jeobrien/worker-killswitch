require "killswitch/version"
require "active_support/time"

module Killswitch
  class Error < StandardError; end

  KILLSWITCH_ENABLED_KEY = "worker_killswitch_enabled".freeze
  RETRY_AFTER = 5.seconds

  def initialize(cache: nil, metrics_provider: nil)
    @cache = cache
    @metrics_provider = metrics_provider
  end

  def self.enable
    @cache.write(KILLSWITCH_ENABLED_KEY, true)
  end

  def self.disable
    @cache.write(KILLSWITCH_ENABLED_KEY, false)
  end

  def self.enabled?
    status = @cache.fetch(KILLSWITCH_ENABLED_KEY)
    status ? status : false
  rescue StandardError => e
    false
  end

  def self.enable_for_muster_profile(profile)
    @cache.write(build_profile_key(profile), true)
  end

  def self.disable_for_muster_profile(profile)
    @cache.write(build_profile_key(profile), false)
  end

  def self.enabled_for_muster_profile?(profile)
    status = @cache.fetch(build_profile_key(profile))
    status ? status : false
  rescue StandardError => e
    false
  end

  def self.build_profile_key(profile)
    profile.to_s + KILLSWITCH_ENABLED_KEY
  end

  def self.wait_for_resume
    Kernel.sleep(RETRY_AFTER + random_sub_sleep)
  end

  def self.random_sub_sleep
    Kernel.rand(0.0..1.0)
  end

end
