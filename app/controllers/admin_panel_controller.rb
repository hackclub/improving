class AdminPanelController <  ApplicationController
  before_action :authenticate
  def index
    # You can add logic here if needed
    @projects = Submission.all
  end

  def authenticate
    authenticate_or_request_with_http_basic("Restricted Area") do |username, password|
      allowed = {
        ENV["ADMIN_USER"] => ENV["ADMIN_PASS"],
        ENV["EDITOR_USER"] => ENV["EDITOR_PASS"]
      }

      allowed[username] == password
    end
  end
end
# admin ui css <html> border-2 md:border-4 border-dashed border-orange-300 box-border text-sm md:text-base