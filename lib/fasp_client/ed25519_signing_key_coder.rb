module FaspClient
  class Ed25519SigningKeyCoder
    def self.dump(value)
      Base64.strict_encode64(value.to_bytes)
    end

    def self.load(string)
      Ed25519::SigningKey.new(Base64.strict_decode64(string)) if string
    end
  end
end
