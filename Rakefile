task default: %i(run_crawler)

task :run_crawler do
  ruby 'advs_crawler.rb'
end

task :test do
  require 'rake/testtask'

  Rake::TestTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_spec.rb']
    t.verbose = true
  end
end
