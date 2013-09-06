module Helpers

  def html_tidy(html)
    html.
      gsub(/\A\s+|\s+\z/, '').
      gsub(/>\s+/, '>').
      gsub(/\s+</, '<')
  end

  def rails_view_path
    File.join(::Rails.root, %w[app views])
  end

end
