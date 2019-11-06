# frozen_string_literal: true

module Name

  CACHE_DIR_NAME  = "cache".freeze
  OUTPUT_DIR_NAME = "output/epub/OEBPS/html".freeze

  module_function

  def file_base_name_from_url(url)
    url.file_name_from_url(url).sub(".html", "")
  end

  def file_name_from_url(url)
    fail ArgumentError, "`url` must not be empty" if url.to_s.nil?
    fail ArgumentError, "`url` must be a String" unless url.is_a? String
    url.sub(Book::PAGES_BASE, "")
  end

  def file_name_w_index_from_url(url, index)
    [
      index.to_s.rjust(3, "0"),
      "-",
      file_name_from_url(url)
    ].join
  end

  def output_file_path(index)
    fail ArgumentError, "`index` must be an Integer" unless index.is_a? Integer
    [OUTPUT_DIR_NAME, "/", output_file_name(index), ".xhtml"].join
  end

  def output_file_name(index)
    fail ArgumentError, "`index` must be an Integer" unless index.is_a? Integer
    ["page-", index.to_s.rjust(4, "0")].join
  end

  def cached_html_file_path(url, index)
    fail ArgumentError, "`index` must be an Integer" unless index.is_a? Integer
    [CACHE_DIR_NAME, file_name_w_index_from_url(url, index)].join("/")
  end

  def cached_html_exists?(url, index)
    fail ArgumentError, "`index` must be an Integer" unless index.is_a? Integer
    File.exists?(cached_html_file_path(url, index))
  end

  def cached_html(url, index)
    fail ArgumentError, "`index` must be an Integer" unless index.is_a? Integer
    return unless cached_html_exists?(url, index)
    File.read cached_html_file_path(url, index)
  end

  def page_url(path)
    [Book::PAGES_BASE, path, ".html"].join
  end

end
