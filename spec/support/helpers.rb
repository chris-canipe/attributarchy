module Helpers
  def rails_view_path
    File.join(::Rails.root, %w[app views])
  end
end
