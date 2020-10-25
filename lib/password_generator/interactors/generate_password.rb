# Generate user-readable password
class GeneratePassword
  include Dry::Transaction

  MIN_PASSWORD_LENGTH = 5
  MAX_PASSWORD_LENGTH = 20
  NUMBERS_COUNT_RANGE = (1..2).freeze

  # Input data validator for this class
  class Validator
    include Hanami::Validations
    validations do
      required(:length).value(:int?, included_in?: MIN_PASSWORD_LENGTH..MAX_PASSWORD_LENGTH)
    end
  end

  try :words_exist?, catch: StandardError
  step :validate
  map :init
  tee :add_numbers
  map :add_alphas
  map :first_underscore_to_digit

  def initialize
    super
    @repository = WordRepository.new
  end

  private

  def words_exist?(input)
    raise 'there\'s no words in database' unless @repository.exists?

    input
  end

  def validate(input)
    res = Validator.new(input).validate
    return Failure(res.errors) if res.failure?

    Success(res.output)
  end

  def init(length:)
    { password: '', length: length }
  end

  def add_numbers(password:, **)
    rand(NUMBERS_COUNT_RANGE).times { password << rand(10).to_s }
  end

  def add_alphas(password:, length:)
    loop do
      random_word = @repository.sample.text
      password.prepend random_word
      return { password: password[password.length - length..password.length] } if
          password.length >= length

      password.prepend '_'
    end
  end

  # replace first underscore in password to digit if one exists
  def first_underscore_to_digit(password:)
    password[0] = rand(10).to_s if password[0] == '_'
    { password: password }
  end
end
