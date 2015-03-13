class User < ActiveRecord::Base
  before_create do
    crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
    self.password = crypt.encrypt_and_sign(self.password)
  end
  # after_find do
  #   crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base)
  #   self.password = crypt.decrypt_and_verify(self.password)
  # end
end