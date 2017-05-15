require 'mumukit'

Mumukit.runner_name = 'cpp'
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-cppunit-worker'
end

require_relative './test_hook'
require_relative './version_hook'
require_relative './metadata_hook'