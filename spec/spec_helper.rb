require 'rspec'
require 'pry'

require 'gender_ru'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :should }
end
