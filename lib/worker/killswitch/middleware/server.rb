module Worker
  module Killswitch
    module Middleware
      class Server

        def call(worker, job, queue)
          while ::Workers::Killswitch.enabled?
            ::Rails.logger.info("Sidekiq worker #{worker.class.name} paused queue #{queue} before processing job #{job['jid']}")
            Metrics.increment("workers_disabled", tags: { type: "sidekiq", name: identifier.to_s })
            ::Worker::Killswitch.wait_for_resume
          end
          yield
        end
      end
    end
  end
end
