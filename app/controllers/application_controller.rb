class ApplicationController < ActionController::API
  include Graphiti::Rails::Responders

  # Mock authentication
  def authenticate_user!
    render json: { errors: ['Unauthorized'] }, status: 401 unless current_user
  end

  def current_user
    @current_user ||= User.find_by(token: request.headers['Authorization'])
  end
end
