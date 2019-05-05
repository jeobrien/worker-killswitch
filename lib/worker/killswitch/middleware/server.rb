module Worker
  module Killswitch
    module Middleware
      class Server

        def call(worker, job, queue)
          while ::Worker::Killswitch.enabled?
            Worker::Killswitch.logger.info("Worker #{worker.class.name} paused queue #{queue} before processing job #{job['jid']}")
            Worker::Killswitch.metrics_provider&.increment("workers_disabled")
            ::Worker::Killswitch.wait_for_resume
          end
          yield
        end
      end
    end
  end
end
