module ApplicationHelper
  def format_hours(hours)
    return "-" unless hours

    total_minutes = (hours * 60).round
    h = total_minutes / 60
    m = total_minutes % 60

    "#{h}h #{m}m"
  end
end
