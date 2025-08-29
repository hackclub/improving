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
