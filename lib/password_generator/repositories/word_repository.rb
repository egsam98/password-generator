class WordRepository < Hanami::Repository
  # Check if words table is non-empty
  # @return [Boolean]
  def exists?
    words.read('select 1 from words limit 1').count.positive?
  end

  # Random Word-object from database
  # @return [Hanami::Entity<Word>]
  def sample
    ids = words.select(:id).pluck(:id)
    find ids.sample
  end
end
