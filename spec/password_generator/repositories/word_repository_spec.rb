RSpec.describe WordRepository, type: :repository do
  describe '.exists?' do
    context 'when one row in table exists' do
      before { subject.create(text: 'TEST') }
      it { expect(subject.exists?).to be true }
    end

    context 'when table is empty' do
      it { expect(subject.exists?).to be false }
    end
  end

  describe '.sample' do
    context 'when 1000 rows exist' do
      before { subject.create(1000.times.map { { text: '' } }) }
      it { expect(subject.sample).to be_an_instance_of Word }
      it 'is expected to be different on every call' do
        expect(subject.sample).to_not eq subject.sample
      end
    end

    context 'when table is empty' do
      it { expect(subject.sample).to be_nil }
    end
  end
end
