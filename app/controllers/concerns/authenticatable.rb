module Authenticatable
  extend ActiveSupport::Concern

  def current_user
    @current_user
  end

  private

  def authenticate_request!
    token = extract_bearer_token
    return render_unauthorized unless token

    payload = decode_token(token)
    return render_unauthorized unless payload

    @current_user = User.find_by(id: payload["user_id"])
    render_unauthorized unless @current_user
  end

  def extract_bearer_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header&.start_with?("Bearer ")

    auth_header.sub("Bearer ", "")
  end

  def decode_token(token)
    JWT.decode(token, JWT_SECRET, true, { algorithm: "HS256" })[0]
  rescue JWT::DecodeError
    nil
  end

  def render_unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
