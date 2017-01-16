$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'action_policy'

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each { |f| require f }
