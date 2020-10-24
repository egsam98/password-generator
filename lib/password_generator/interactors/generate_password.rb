class GeneratePassword
  include Hanami::Interactor
  expose :password

  # @return [String]
  def call
    @password = "GENERATED"
  end
end
