class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!
  helper_method :current_project

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end

  def current_project
    @current_project ||= Project.find(params[:project_id]) if params[:project_id]
  end
end
