module Helpers
  def fixture_file(path)
    Pathname.new(__FILE__).parent.join(path)
  end

  def fixture_file_content(path)
    fixture_file(path).read
  end
end
