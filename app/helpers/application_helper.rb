module ApplicationHelper

  # This returns the full page title on a per-page basis

  def full_title(page_title)
    base_title = 'Opuss Web App - *** ALPHA ***'
    if page_title.empty?
      base_title
    else
      "#{base_title}  | #{page_title}"
    end
  end

  def is_active()
  end


end
