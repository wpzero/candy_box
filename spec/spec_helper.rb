$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'candy_box'
require 'byebug'
RSpec.configure do |config|
  config.raise_errors_for_deprecations!
  # config.filter_run focus: true
end
