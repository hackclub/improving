require 'net/http'
require 'uri'
require 'json'

class SubmitController < ApplicationController
  protect_from_forgery with: :exception

  SLACK_BOT_TOKEN = ENV['SLACK_BOT_TOKEN']

  def index
    email = params[:email]  # grab the email from query param
    if email.present?
      @slack_id = get_slack_id_by_email(email)
    else
      @slack_id = nil
    end
  end
  def create
    # print all info from req body to user
    Rails.logger.info "Submission received: #{params.inspect}"
    # Here you can add any additional processing or response logic
    # TODO: add thumbnail
    # after that ur done pretty much tho
 Submission.create!(
  code_url:        params[:code_url],
  demo_url:        params[:demo_url],
  first_name:      params[:first_name],
  last_name:       params[:last_name],
  email:           params[:email],
  slack_id:        params[:slack_id],
  ship_name:       params[:ship_name],
  description:     params[:description],
  is_hardware:     ActiveModel::Type::Boolean.new.cast(params[:is_hardware]),
  # video_upload:    params[:video_upload],   # or .attach if Active Storage

  birthday:        params[:birthday],
  street:          params[:street],
  address_line2:   params[:address_line2],
  city:            params[:city],
  state:           params[:state],
  zip:             params[:zip],
  country:         params[:country],
  shipping_name:   params[:shipping_name],
  github_username: params[:github_username],
  hackatime_project: params[:hackatime_project],
  hours_collected: params[:hours_collected],
  desired_prize:   params[:desired_prize],
  in_gallery:      ActiveModel::Type::Boolean.new.cast(params[:in_gallery])
)

    # now send it to the client
    render plain: "Thanks for submitting! lack of html is intentional... maybe i should improve..."
  end
  private

  def get_slack_id_by_email(email)
    uri = URI("https://slack.com/api/users.lookupByEmail?email=#{email}")
    req = Net::HTTP::Get.new(uri)
    req["Authorization"] = "Bearer #{SLACK_BOT_TOKEN}"

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    data = JSON.parse(res.body)
    Rails.logger.debug "Slack API response for #{email}: #{data}"
    data["ok"] ? data["user"]["id"] : "Not found"
  rescue => e
    Rails.logger.error("Slack API error for #{email}: #{e.message}")
    "Error"
  end
end
