[![Build Status](https://secure.travis-ci.org/validas/encrypted_cookie_store.png)](http://travis-ci.org/validas/encrypted_cookie_store)
EncryptedCookieStore
====================
EncryptedCookieStore is similar to Ruby on Rails's CookieStore (it saves
session data in a cookie), but it uses encryption so that people can't read
what's in the session data. This makes it possible to store sensitive data
in the session.

This version of EncryptedCookieStore is written for Rails 3.1.0+. It will not work with Rails 3.0.0 or earlier. It does work with Rails 3.2.

The original version for Rails 2.3 can be found here: https://github.com/FooBarWidget/encrypted_cookie_store

For a version that probably works with Rails 3.0.0.beta - 3.0.0.beta3, check here: https://github.com/twoism-dev/encrypted_cookie_store

Installation and usage
----------------------

First, install it:

    gem install validas-encrypted_cookie_store

Then, add it to you bundler Gemfile:

    gem 'validas-encrypted_cookie_store', :require => 'encrypted_cookie_store'

Then edit `config/initializers/session_store.rb` and set your session store to
EncryptedCookieStore:

    MyApp::Application.config.session_store(
      EncryptedCookieStore::EncryptedCookieStore,
      :key            => '_myapp_session',
      :encryption_key => '966a4....'
    )

The encryption key *must* be a hexadecimal string of exactly 32 bytes. It
should be entirely random, because otherwise it can make the encryption weak.

You can generate a new encryption key by running `rake secret:encryption_key`.
This command will output a random encryption key that you can then copy and
paste into your environment.rb.

You also need to make sure you have a secret token defined in `config/initializers/secret_token.rb`, just as you work for the standard CookieStore, e.g.:

    MyApp::Application.config.secret_token = 'f75bb....'

Operational details
-------------------
Upon generating cookie data, EncryptedCookieStore generates a new, random
initialization vector for encrypting the session data. This initialization
vector is then encrypted with 128-bit AES in ECB mode. The session data is
first protected with an HMAC to prevent tampering. The session data, along
with the HMAC, are then encrypted using 256-bit AES in CFB mode with the
generated initialization vector. This encrypted session data + HMAC are
then stored, along with the encrypted initialization vector, into the cookie.

Upon unmarshalling the cookie data, EncryptedCookieStore decrypts the
encrypted initialization vector and use that to decrypt the encrypted
session data + HMAC. The decrypted session data is then verified against
the HMAC.

The reason why HMAC verification occurs after decryption instead of before
decryption is because we want to be able to detect changes to the encryption
key and changes to the HMAC secret key, as well as migrations from CookieStore.
Verifying after decryption allows us to automatically invalidate such old
session cookies.

EncryptedCookieStore is quite fast: it is able to marshal and unmarshal a
simple session object 5000 times in 8.7 seconds on a MacBook Pro with a 2.4
Ghz Intel Core 2 Duo (in battery mode). This is about 0.174 ms per
marshal+unmarshal action. See `rake benchmark` in the EncryptedCookieStore
sources for details.

EncryptedCookieStore vs other session stores
--------------------------------------------
EncryptedCookieStore inherits all the benefits of CookieStore:

 * It works out of the box without the need to setup a seperate data store (e.g. database table, daemon, etc).
 * It does not require any maintenance. Old, stale sessions do not need to be manually cleaned up, as is the case with PStore and ActiveRecordStore.
 * Compared to MemCacheStore, EncryptedCookieStore can "hold" an infinite number of sessions at any time.
 * It can be scaled across multiple servers without any additional setup.
 * It is fast.
 * It is more secure than CookieStore because it allows you to store sensitive data in the session.

There are of course drawbacks as well:

 * It is prone to session replay attacks. These kind of attacks are explained in the [Ruby on Rails Security Guide](http://guides.rubyonrails.org/security.html#session-storage). Therefore you should never store anything along the lines of `is_admin` in the session.
 * You can store at most a little less than 4 KB of data in the session because that's the size limit of a cookie. "A little less" because EncryptedCookieStore also stores a small amount of bookkeeping data in the cookie.
 * Although encryption makes it more secure than CookieStore, there's still a chance that a bug in EncryptedCookieStore renders it insecure. We welcome everyone to audit this code. There's also a chance that weaknesses in AES are found in the near future which render it insecure. If you are storing *really* sensitive information in the session, e.g. social security numbers, or plans for world domination, then you should consider using ActiveRecordStore or some other server-side store.

JRuby: Illegal Key Size error
-----------------------------
If you get this error (and your code works with MRI)...

    Illegal key size
    
    [...]/vendor/plugins/encrypted_cookie_store/lib/encrypted_cookie_store.rb:62:in `marshal'

...then it probably means you don't have the "unlimited strength" policy files
installed for your JVM.
[Download and install them.](http://www.ngs.ac.uk/tools/jcepolicyfiles)
You probably have the "strong" version if they are already there.

As a workaround, you can change the cipher type from 256-bit AES to 128-bit by
inserting the following in `config/initializer/session_store.rb`:

    EncryptedCookieStore.data_cipher_type = 'aes-128-cfb'.freeze  # was 256

Please note that after changing to 128-bit AES, EncryptedCookieStore still
requires a 32 bytes hexadecimal encryption key, although only half of the key
is actually used.
