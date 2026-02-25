class AuthController < ApplicationController
  include Authenticatable
  before_action :authenticate_request!, only: [:me]

  def register
    user = User.new(user_params)
    if user.save
      render json: { token: encode_token(user), user: user_response(user) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      render json: { token: encode_token(user), user: user_response(user) }
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def me
    render json: { user: user_response(current_user) }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def encode_token(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, JWT_SECRET, "HS256")
  end

  def user_response(user)
    { id: user.id, email: user.email }
  end
end
