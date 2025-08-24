class CountdownController < ApplicationController
  skip_before_action :redirect_if_blocky

  def index
    est_zone = ActiveSupport::TimeZone["Eastern Time (US & Canada)"]
    target_time = est_zone.local(2025, 8, 30, 0, 0, 0) 
    now = Time.current.in_time_zone(est_zone)

    diff = target_time - now

    if diff.positive?
      days = (diff / 1.day).floor
      hours = ((diff % 1.day) / 1.hour).floor
      minutes = ((diff % 1.hour) / 1.minute).floor
      seconds = (diff % 1.minute).floor

      render plain: "#{days}d #{hours}h #{minutes}m #{seconds}s"
    else
      render plain: "I should be out by now??!"
    end
  end
end
