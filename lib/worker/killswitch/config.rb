# frozen_string_literal: true

module Worker::Killswitch
  class Config
    attr_writer :logger
    attr_writer :cache
    attr_writer :metrics_provider

    def logger
      @logger ||= Rails.logger
    end

    def cache
      @cache ||= Rails.cache
    end

    def metrics_provider
      @metrics_provider = nil
    end

  end
end