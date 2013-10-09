module Helpers

  def html_tidy(html)
    html.
      gsub(/\A\s+|\s+\z/, '').
      gsub(/>\s+/, '>').
      gsub(/\s+</, '<')
  end

  def fixture_content_of(*path)
    File.read(File.join(path))
  end

  def load_fixtures_into(path)
    FileUtils.mkdir_p(path)
    FakeFS::FileSystem.clone('spec/fixtures')
    Dir.glob('spec/fixtures/*/*') do |fixture|
      FileUtils.cp fixture, File.join(path, File.basename(fixture))
    end
    subject.prepend_view_path(path)
  end

  def rails_view_path
    File.expand_path('.')
  end

end
