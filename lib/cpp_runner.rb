require 'mumukit'

I18n.load_translations_path File.join(__dir__, 'locales', '*.yml')

Mumukit.runner_name = 'cpp'
Mumukit.configure do |config|
  config.content_type = 'markdown'
  config.docker_image = 'mumuki/mumuki-cppunit-worker'
end

require_relative './test_hook'
require_relative './version_hook'
require_relative './metadata_hook'
require_relative './feedback_hook'