require 'spec_helper'

RSpec.describe Worker::Killswitch::Middleware::Server do
  subject(:middleware) { described_class.new }

  context "while the queues are disabled" do
    it "does not perform the next job" do
      allow(::Worker::Killswitch).to receive(:enabled?).and_return(true, true, false)
      expect(::Worker::Killswitch).to receive(:wait_for_resume).twice
      expect(Rails.logger).to receive(:info).twice
      middleware.call("my_worker", {"jid" => "12345"}, "my_queue") { }
    end
  end

  context "while the queues are enabled" do
    it "performs the next job" do
      allow(::Worker::Killswitch).to receive(:enabled?).and_return(false)
      test_block = proc { throw :test_block_was_called }

      expect {
        middleware.call("my_worker", {"jid" => "12345"}, "my_queue") { test_block.call }
      }.to throw_symbol :test_block_was_called
    end
  end
end
