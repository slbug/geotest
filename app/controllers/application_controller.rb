# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ::ActionController::HttpAuthentication::Basic::ControllerMethods
  include ::UnifiedResponseFormat
  include ::ActionProxy

  before_action :authenticate_user!

  private

  def authenticate_user!
    authenticate_with_http_basic do |email, password|
      user = User.find_by(email: email)

      return if user&.authenticate(password)
    end

    render status: :unauthorized
  end
end
