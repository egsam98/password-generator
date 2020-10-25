MIN_PASS_LEN = GeneratePassword::MIN_PASSWORD_LENGTH
MAX_PASS_LEN = GeneratePassword::MAX_PASSWORD_LENGTH

RSpec.describe Api::Controllers::Password::Index, type: :action do
  let(:action) { subject.call(params) }
  let(:params) { { length: length } }
  let(:status) { action[0] }
  let(:content_type) { action[1]['Content-Type'] }
  let(:body) { JSON.parse(action[2][0], symbolize_names: true) }

  let(:length) { 15 }

  context 'when ok' do
    before { WordRepository.new.create(text: 'word') }
    it { expect(status).to eq 200 }
    it { expect(content_type).to eq 'application/json; charset=utf-8' }
    it { expect(body).to include(:password) }
  end

  context 'when user input error' do
    before do
      allow_any_instance_of(WordRepository).to receive(:exists?).and_return true
      expect(status).to eq 400
      expect(content_type).to eq 'application/json; charset=utf-8'
    end

    context 'when no length provided as query param' do
      let(:params) { {} }
      it { expect(body).to eq length: ['is missing'] }
    end

    context 'when length is not an integer' do
      let(:length) { 'XZ' }
      it { expect(body).to eq length: ['must be an integer'] }
    end

    context 'when GeneratePassword error' do
      let(:length) { 0 }
      it { expect(body).to eq error: { length: ["must be one of: #{MIN_PASS_LEN} - #{MAX_PASS_LEN}"] } }
    end
  end

  context 'when internal GeneratePassword error' do
    let(:length) { 0 }
    it { expect(status).to eq 500 }
  end
end
