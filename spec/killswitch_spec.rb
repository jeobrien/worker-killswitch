RSpec.describe Killswitch do
  let(:cache) { double }
  subject(:worker_killswitch) { described_class.new(cache: cache) }

  before :each do
    allow(cache).to receive(:write).and_return(true)
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

  context "disabling queues for specific profiles" do
    it 'returns false if not enabled for profile' do
      worker_killswitch.enable_for_muster_profile("other")
      expect(worker_killswitch.enabled_for_muster_profile?("profile")).to eql(false)
    end

    it 'returns true if enabled for profile' do
      worker_killswitch.enable_for_muster_profile("profile")
      expect(worker_killswitch.enabled_for_muster_profile?("profile")).to eql(true)
    end

    it 'returns false when disabled for profile' do
      worker_killswitch.enable_for_muster_profile("profile")
      worker_killswitch.disable_for_muster_profile("profile")
      expect(worker_killswitch.enabled_for_muster_profile?("profile")).to eql(false)
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
