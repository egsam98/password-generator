class WordRepository < Hanami::Repository
  # @return [Boolean]
  def exists?
    words.read('select 1 from words limit 1').count.positive?
  end
end
