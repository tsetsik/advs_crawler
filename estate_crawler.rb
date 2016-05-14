require 'rubygems'
require 'bundler/setup'
require 'require_all'
require 'yaml'
require 'active_support/inflector'
require 'byebug'

require_all 'lib', 'db', 'adapters', 'observers'

mail_settings = YAML.load_file('config/notifier.yml')

proccessor = Proccessor.new
Notifier.new(proccessor, mail_settings)

Dir['adapters/*'].each do |f|
  adapter = File.basename(f, '.rb').classify.constantize
  proccessor.add_adapter(adapter.new)
end

proccessor.run
