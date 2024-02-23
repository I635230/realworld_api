module JwtAuthenticator
  SECRET_KEY = Rails.application.credentials.secret_key_base

  # 暗号化処理
  def encode(payload)
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  # 復号化処理
  def decode(encoded_token)
    decoded_dwt = JWT.decode(encoded_token, SECRET_KEY, true, algorithm: "HS256")
    decoded_dwt.first
  end

  private
    def can_decode?(encoded_token)
      !!JWT.decode(encoded_token, SECRET_KEY, true, algorithm: "HS256")
    rescue
      false
    end
end
