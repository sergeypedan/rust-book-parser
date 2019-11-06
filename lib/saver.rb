# frozen_string_literal: true

class Saver

  def self.save_epub_page!(html, index)
    name = Name.output_file_path(index)
    File.open(name, "w") do |f| f << html end
  end

  def self.save_cached_html!(html, url, index)
    name = Name.cached_html_file_path(url, index)
    File.open(name, "w") do |f| f << html end
  end

  def self.save_opf!(html)
    name = Ebook::Opf::PATH
    File.open(name, "w") do |f| f << html end
  end

end
