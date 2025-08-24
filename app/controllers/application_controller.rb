class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :redirect_if_blocky

  private

  def redirect_if_blocky
    redirect_to redirect_to_blocker_page if redirect_to_blocker_page
  end

  def redirect_to_blocker_page
    # Define how `xyz` is determined, e.g., from params, session, or a method
    "/secret_code"
  end 
end
