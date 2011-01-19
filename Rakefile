desc "Run unit tests"
task :test do
	sh "spec -f s -c test/*_test.rb"
end

desc "Run benchmark"
task :benchmark do
	$LOAD_PATH.unshift(File.expand_path("lib"))
	require 'rubygems'
	require 'benchmark'
	require 'action_controller'
	require 'encrypted_cookie_store'
	
	secret = "b6a30e998806a238c4bad45cc720ed55e56e50d9f00fff58552e78a20fe8262df61" <<
		"42fcfdb0676018bb9767ed560d4a624fb7f3603b4e53c77ec189ae3853bd1"
	encryption_key = "dd458e790c3b995e3606384c58efc53da431db892f585aa3ca2a17eabe6df75b"
	store  = EncryptedCookieStore.new(nil, :secret => secret, :key => 'my_app',
		:encryption_key => encryption_key)
	object = { :hello => "world", :user_id => 1234, :is_admin => true,
	        :shopping_cart => ["Tea x 1", "Carrots x 13", "Pocky x 20", "Pen x 4"],
	        :session_id => "b6a30e998806a238c4bad45cc720ed55e56e50d9f00ff" }
	count  = 50_000
	
	puts "Marshalling and unmarshalling #{count} times..."
	result = Benchmark.measure do
		count.times do
			data = store.send(:marshal, object)
			store.send(:unmarshal, data)
		end
	end
	puts result
	printf "%.3f ms per marshal+unmarshal action\n", result.real * 1000 / count
end

require "rubygems"
require "rake/gempackagetask"
require "rake/rdoctask"

require "rake/testtask"
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end


task :default => ["test"]

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "encrypted_cookie_store"
  s.version           = "0.2.0"
  s.summary           = "A Rails 3 version of Encrypted Cookie Store by FooBarWidget"
  s.authors           = ["FooBarWidget", "Ben Sales"]
  s.email             = "ben@twoism.co.uk"
  s.homepage          = "https://github.com/FooBarWidget/encrypted_cookie_store"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README.markdown)
  s.rdoc_options      = %w(--main README.markdown)

  # Add any extra files to include in the gem
  s.files             = %w(LICENSE.txt Rakefile README.markdown) + Dir.glob("{test,lib}/**/*")
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  # s.add_dependency("some_other_gem", "~> 0.1.0")

  # If your tests use any gems, include them here
  # s.add_development_dependency("mocha") # for example
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more 
# about that here: http://gemcutter.org/pages/gem_docs
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# If you don't want to generate the .gemspec file, just remove this line. Reasons
# why you might want to generate a gemspec:
#  - using bundler with a git source
#  - building the gem without rake (i.e. gem build blah.gemspec)
#  - maybe others?
task :package => :gemspec

# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "README.markdown"
  rd.rdoc_files.include("README.markdown", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
