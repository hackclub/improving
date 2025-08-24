class SecretCodeController < ApplicationController
  skip_before_action :redirect_if_blocky

  def index
    # You can add logic here if needed
    render plain: "Hey! you found this coolify url, early early dang, instead of sharing this what if you dm neon this fe9aa19d-57fb-486e-beef-1c62e6aa47f5 :3 if the url is shared into a channel then nobody gets the secrets :<"
  end
end