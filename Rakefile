require 'rake/testtask'

Rake::TestTask.new do |t|
  t.options = "-p"
  t.libs << "lib" << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
end

task :default => :test
