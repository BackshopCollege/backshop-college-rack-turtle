ENV['RACK_ENV'] = 'test'
require 'rack/test'

require 'turtle'
require 'timecop'

module UtilHelper

  def limit
    5
  end

  def app
    Turtle::Minute.new(proc {|env| [200, {}, ["success"] ] } , :maximum => limit)
  end

  def with_ip(ip)
    ::Rack::Request.any_instance.stub(:ip).and_return(ip)
      yield if block_given?
    ensure
    ::Rack::Request.any_instance.unstub(:ip)
  end

end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
  config.include Rack::Test::Methods
  config.include UtilHelper
end
