module ApplicationHelper

  # This returns the full page title on a per-page basis

  def full_title(page_title)
    base_title = 'Opuss BETA'
    if page_title.empty?
      base_title
    else
      "#{base_title}  | #{page_title}"
    end
  end

  def is_active()
  end

  # Heroku / Rails throws a hissy fit if the image is null, only on production.  Not local..
  def safe_image_tag(source, options = {})
    source ||= "pawfeed.png"
    image_tag(source, options)
  end

end
