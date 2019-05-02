RSpec.describe Killswitch::Switch do
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) } 
  subject(:worker_killswitch) { described_class.new(cache: Rails.cache) }

  before :each do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  context "disabling queues" do
    it 'returns false if there is no key set in the cache' do
      expect(worker_killswitch.enabled?).to eql(false)
    end

    it 'returns true if the key in the cache is set to true' do
      worker_killswitch.enable
      expect(worker_killswitch.enabled?).to eql(true)
    end

    it 'returns false if the key in the cache is set to false' do
      worker_killswitch.disable
      expect(worker_killswitch.enabled?).to eql(false)
    end
  end

  context '#wait_for_resume' do
    it 'calls sleep with 5 seconds plus a float beteen 0 and 1, differing each time' do
      allow(::Kernel).to receive(:rand).with(0.0..1.0).and_return(0.3, 0.7)
      expect(::Kernel).to receive(:sleep).once.with(5.3)
      expect(::Kernel).to receive(:sleep).once.with(5.7)
      worker_killswitch.wait_for_resume
      worker_killswitch.wait_for_resume
    end
  end

end
