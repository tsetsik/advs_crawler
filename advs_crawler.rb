require 'rubygems'
require 'bundler/setup'
require 'require_all'
require 'yaml'
require 'active_support/inflector'
require 'byebug'

require_all 'lib', 'db', 'adapters', 'observers', 'services', 'mailers'

mail_settings = Config.new('notifier').parse
adapter_settings = Config.new('adapters').parse

diff_watcher = DiffWatchService.new
proccessor = Proccessor.new(diff_watcher)

Notifier.new(proccessor, mail_settings.except(:notify_design_changes))
DesignChangesNotifier.new(diff_watcher, mail_settings.except(:emails_to_notify))

Dir['adapters/*'].each do |f|
  adapter = File.basename(f, '.rb').classify.constantize
  proccessor.add_adapter(adapter.new) if adapter_settings[:execute_adapters].nil? ||
                                         adapter_settings[:execute_adapters].include?(adapter.to_s)
end

proccessor.run
