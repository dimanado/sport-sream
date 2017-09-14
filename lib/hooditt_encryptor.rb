require "digest/sha1"

class HoodittEncryptor < Devise::Encryptable::Encryptors::Base

  SALT = "X8k;aoeri39erfvmb,2we rrd98ap-2]:qcfJE3"

  def self.digest(password, stretches, salt, pepper)
    ::Digest::SHA1.hexdigest(salt + password)
  end

  def self.salt(stretches = 1)
    SALT
  end

  def self.compare(encrypted_password, password, stretches, salt, pepper)
    Devise.secure_compare(encrypted_password, digest(password, stretches, salt, pepper))
  end
end