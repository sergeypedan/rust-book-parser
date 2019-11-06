# frozen_string_literal: true

require_relative "../config/boot.rb"

class Processor

  def self.create_pages!
    Book::PAGE_PATHS.each_with_index do |path, index|
      url          = Name.page_url(path)
      html         = cached_or_new_html(url, index)
      transformer  = PageTransformer.new(html, url)
      page_title   = transformer.page_title # cannot be called after `transformer.html`
      content_html = transformer.html
      ebook_html   = Ebook::Wrapper.new(content: content_html, title: page_title).html
      Saver.save_epub_page!(ebook_html, index)
    end
  end


  def self.create_opf!
    file_names = Book::PAGE_PATHS.map.with_index { |path, index| Name.output_file_name(index) }
    opf = Ebook::Opf.new(pages_data: file_names).result
    Saver.save_opf!(opf)
  end


  def self.create_epub!
    Dir.chdir("output/epub")
    system "zip -0Xq my-book.epub mimetype"  # create the new ZIP archive and add the mimetype file with no compression
    system "zip -Xr9Dq my-book.epub *"        # add the remaining items
    # The flags -X and -D minimize extraneous information in the .zip file
    # -r will recursively include the contents of META-INF and OEBPS directories
    # https://www.ibm.com/developerworks/xml/tutorials/x-epubtut/index.html
  end


  def self.cached_or_new_html(url, index)
    html = Name.cached_html(url, index)

    if html.to_s != ""
      puts "Found cached #{Name.file_name_w_index_from_url(url, index)}"
      return html
    end

    puts "Not found in cache: #{Name.file_name_from_url url}"
    html = HtmlFetchers::Httprb.new(url: url).html
    Saver.save_cached_html!(html, url, index)
    return html
  end

end
