module EncryptedCookieStore
  class Railtie < Rails::Railtie
    initializer "encrypted_cookie_store_railtie.boot" do |app|
    end

    rake_tasks do
      load 'tasks/encrypted_cookie_store.rake'
    end
  end
end