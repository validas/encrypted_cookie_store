require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'


require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name              = "scottwb-encrypted_cookie_store"
  gem.homepage          = "https://github.com/scottwb/encrypted_cookie_store"
  gem.summary           = "A Rails 3.0 version of Encrypted Cookie Store by FooBarWidget"
  gem.description       = "A Rails 3.0 version of Encrypted Cookie Store by FooBarWidget"
  gem.email             = "scottwb@gmail.com"
  gem.authors           = ["FooBarWidget", "Scott W. Bradley"]
end
Jeweler::RubygemsDotOrgTasks.new


require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end
task :default => :spec


desc "Run benchmark"
task :benchmark do
  $LOAD_PATH.unshift(File.expand_path("lib"))
  require 'rubygems'
  require 'benchmark'
  require "rails"
  require 'action_controller'
  require 'encrypted_cookie_store'

  secret = "b6a30e998806a238c4bad45cc720ed55e56e50d9f00fff58552e78a20fe8262df61" <<
           "42fcfdb0676018bb9767ed560d4a624fb7f3603b4e53c77ec189ae3853bd1"
  encryption_key = "dd458e790c3b995e3606384c58efc53da431db892f585aa3ca2a17eabe6df75b"
  store  = EncryptedCookieStore::EncryptedCookieStore.new(
    nil,
    :secret => secret,
    :key => 'my_app',
    :encryption_key => encryption_key
  )
  object = {
    :hello => "world",
    :user_id => 1234,
    :is_admin => true,
    :shopping_cart => ["Tea x 1", "Carrots x 13", "Pocky x 20", "Pen x 4"],
    :session_id => "b6a30e998806a238c4bad45cc720ed55e56e50d9f00ff"
  }
  count  = 50_000

  puts "Marshalling and unmarshalling #{count} times..."
  result = Benchmark.measure do
    count.times do
      data = store.send(:set_session, nil, nil, object)
      store.send(:unmarshal, data)
    end
  end
  puts result
  printf "%.3f ms per marshal+unmarshal action\n", result.real * 1000 / count
end


require "rake/rdoctask"
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "scottwb-encrypted_cookie_store #{version}"
  rdoc.rdoc_files.include("README*")
  rdoc.rdoc_files.include("lib/**/*.rb")
  #rdoc.main = "README.md"
end
