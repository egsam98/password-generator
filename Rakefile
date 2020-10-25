require 'rake'
require 'hanami/rake_tasks'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  # ignored
end


task load_words: :environment do
  repository = WordRepository.new
  next if repository.exists?

  data = File.open('./db/words.txt').each_line.map { |line| { text: line.split(' ', 2).first } }
  repository.create data
end
