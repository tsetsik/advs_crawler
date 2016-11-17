require 'rubygems'
require 'bundler/setup'
require 'require_all'
require 'yaml'
require 'active_support/inflector'
require 'byebug'

require_all 'lib', 'db', 'adapters', 'observers', 'services', 'mailers'

mail_settings = YmlConfig.new('notifier').parse
adapter_settings = YmlConfig.new('adapters').parse

diff_watcher = DiffWatchService.new
proccessor = Proccessor.new(diff_watcher)

Notifier.new(proccessor, mail_settings.except(:notify_design_changes))
DesignChangesNotifier.new(diff_watcher, mail_settings.except(:emails_to_notify))

Dir['adapters/*'].each do |f|
  adapter = File.basename(f, '.rb').classify.constantize
  next if adapter_settings[:run_adapters].present? &&
          adapter_settings[:run_adapters].exclude?(adapter.to_s)

  adapter_searches = adapter_settings[:searches].fetch(adapter.to_s.to_sym, [])
  proccessor.add_adapter(adapter.new(adapter_searches))
end

proccessor.run
