RSpec::Matchers.define :be_failure_with do |hash|
  match do |actual|
    actual.is_a?(Dry::Monads::Failure) && actual.failure == hash
  end
end

RSpec::Matchers.define :be_success_with do |hash|
  match do |actual|
    actual.is_a?(Dry::Monads::Success) && actual.success == hash
  end
end
