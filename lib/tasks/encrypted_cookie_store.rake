namespace :secret do
	desc "Generate an encryption key for EncryptedCookieStore that's cryptographically secure."
	task :encryption_key do
		require 'encrypted_cookie_store/constants'
		puts SecureRandom.hex(EncryptedCookieStoreConstants::ENCRYPTION_KEY_SIZE)
	end
end
