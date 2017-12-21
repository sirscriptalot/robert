desc 'open irb in gs context'
task :console do
  sh './bin/gs irb -r ./app.rb'
end

task :default do
  sh 'rake -T'
end

desc 'installs gems'
task :install do
  sh 'mkdir -p .gs & ./bin/gs bundle install --system'
end

desc 'tests the given [test]_test.rb'
task :test, :name do |t, args|
  name = args[:name] || "*"

  sh "./bin/gs cutest -r ./lib/robert ./test/#{name}_test.rb"
end
