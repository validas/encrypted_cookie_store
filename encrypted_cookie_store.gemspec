# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{encrypted_cookie_store}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["FooBarWidget", "Ben Sales"]
  s.date = %q{2011-01-19}
  s.email = %q{ben@twoism.co.uk}
  s.extra_rdoc_files = ["README.markdown"]
  s.files = ["LICENSE.txt", "Rakefile", "README.markdown", "test/encrypted_cookie_store_test.rb", "lib/encrypted_cookie_store/constants.rb", "lib/encrypted_cookie_store/encrypted_cookie_store.rb", "lib/encrypted_cookie_store/railtie.rb", "lib/encrypted_cookie_store.rb", "lib/tasks/encrypted_cookie_store.rake"]
  s.homepage = %q{https://github.com/FooBarWidget/encrypted_cookie_store}
  s.rdoc_options = ["--main", "README.markdown"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Rails 3 version of Encrypted Cookie Store by FooBarWidget}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
