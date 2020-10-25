MIN_PASS_LEN = GeneratePassword::MIN_PASSWORD_LENGTH
MAX_PASS_LEN = GeneratePassword::MAX_PASSWORD_LENGTH

RSpec.describe GeneratePassword, type: :interactor do
  let(:length) { 15 }
  let(:word) { Word.new(text: 'some_word') }

  before do
    allow_any_instance_of(WordRepository).to receive(:sample).and_return word
  end

  describe '.words_exist?' do
    let(:subject) { described_class.new.send(:words_exist?, {}) }
    context 'when there\'s no words in database' do
      it { expect { subject }.to raise_error(StandardError, 'there\'s no words in database') }
    end

    context 'when words exist' do
      it do
        allow_any_instance_of(WordRepository).to receive(:exists?).and_return true
        expect { subject }.to_not raise_error
      end
    end
  end

  describe '.validate' do
    let(:subject) { described_class.new.send(:validate, length: length) }

    it "is expected to be in range #{MIN_PASS_LEN}..#{MAX_PASS_LEN}" do
      is_expected.to be_success_with length: length
    end

    context 'when no length passed' do
      let(:subject) { described_class.new.send(:validate, {}) }
      it { is_expected.to be_failure_with length: ['is missing'] }
    end

    context 'when length is not integer' do
      let(:length) { false }
      it { is_expected.to be_failure_with length: ['must be an integer'] }
    end

    context 'when length is out of range' do
      let(:length) { MIN_PASS_LEN - 1 }
      it { is_expected.to be_failure_with length: ["must be one of: #{MIN_PASS_LEN} - #{MAX_PASS_LEN}"] }
    end
  end

  describe '.add_numbers' do
    let(:password) { '' }
    before { described_class.new.send(:add_numbers, password: password, length: length) }

    it do
      expect(password).to satisfy('contain only digits') do |str|
        !str.empty? && str.scan(/\D/).empty?
      end
    end
  end

  describe '.add_alphas' do
    let(:password) { '15' }
    let(:subject) { described_class.new.send(:add_alphas, password: password, length: length) }

    it 'is expected to fit password length and contain both alphas and 1..2 numbers' do
      is_expected.to eq(password: 'ord_some_word15')
    end
  end

  describe '.first_underscore_to_digit' do
    let(:password) { '_pas1' }
    let(:subject) { described_class.new.send(:first_underscore_to_digit, password: password) }

    it 'is expected to replace first underscore (if it exists) with random digit' do
      expect(subject[:password]).to match(/\dpas1/)
    end
  end

  describe '.call' do
    let(:subject) { described_class.new.call(length: length) }
    it do
      allow_any_instance_of(WordRepository).to receive(:exists?).and_return true
      expect(subject.success[:password]).to match(/[A-Za-z|\d][A-z]+\d{1,2}/)
    end
  end
end
