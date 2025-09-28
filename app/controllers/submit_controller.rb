require 'net/http'
require 'uri'
require 'json'
require 'streamio-ffmpeg'

class SubmitController < ApplicationController
  protect_from_forgery with: :exception

  SLACK_BOT_TOKEN = ENV['SLACK_BOT_TOKEN']

  def index
    email = params[:email]
    @slack_id = email.present? ? get_slack_id_by_email(email) : nil
  end

  def create
    Rails.logger.info "Submission received: #{params.inspect}"

    begin
      # check if prev submission
      if Submission.exists?(email: params[:email])
        render plain: "You have already submitted a project with this email and ship name.",
      submission = Submission.new(submission_params)

      if params[:video_upload].present?
        # Attach the uploaded video
        submission.video_upload.attach(params[:video_upload])

        # Save so the blob exists
        submission.save!

        # Download video into tempfile
        Tempfile.create(["video", ".mp4"]) do |file|
          file.binmode
          file.write(submission.video_upload.download)
          file.flush

          # Generate thumbnail
          movie = FFMPEG::Movie.new(file.path)
          thumb_path = Rails.root.join("tmp", "thumb_#{SecureRandom.hex}.jpg")
          movie.screenshot(thumb_path.to_s, seek_time: 3, resolution: "320x240")

          # Attach thumbnail
          submission.thumbnail.attach(
            io: File.open(thumb_path),
            filename: File.basename(thumb_path),
            content_type: "image/jpeg"
          )

          File.delete(thumb_path) if File.exist?(thumb_path)
        end
      else
        submission.save!
      end

      render plain: "Thanks for submitting!"
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error("Submission save failed: #{e.message}")
      render plain: "Error saving submission: #{e.record.errors.full_messages.join(', ')}",
             status: :unprocessable_entity
    rescue => e
      Rails.logger.error("Unexpected error in submission: #{e.message}")
      render plain: "An unexpected error occurred.", status: :internal_server_error
    end
  end

  private

  def submission_params
    {
      code_url:        params[:code_url],
      demo_url:        params[:demo_url],
      first_name:      params[:first_name],
      last_name:       params[:last_name],
      email:           params[:email],
      slack_id:        params[:slack_id],
      ship_name:       params[:ship_name],
      description:     params[:description],
      is_hardware:     ActiveModel::Type::Boolean.new.cast(params[:is_hardware]),
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
    }
  end

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
