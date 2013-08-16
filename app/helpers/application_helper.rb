module ApplicationHelper

  def full_title(page_title)
    base_title = 'ZendeskTestApp'
    page_title.empty? ? base_title : "#{base_title} | #{page_title}"
  end

  def utc_to_pst(time)
    pst = Time.parse("#{time} UTC").in_time_zone("Pacific Time (US & Canada)")
    pst.strftime("%l:%M%P on %a %b %-d %Y")
  end

  def separate
    puts '=' * 50
  end
end
