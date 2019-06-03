class UsersController < ApplicationController
  skip_before_action :authorize_request

  def signup
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  def login
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    json_response(auth_token: auth_token)
  end

  private

  def auth_params
    params.permit(:email, :password)
  end

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
