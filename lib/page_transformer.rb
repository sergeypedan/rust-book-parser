# frozen_string_literal: true

require "nokogiri"

class PageTransformer

  CLASSES_TO_REMOVE = %w[
    does_not_compile
    header
    hljs
    hljs-built_in
    hljs-class
    hljs-comment
    hljs-function
    hljs-keyword
    hljs-meta
    hljs-number
    hljs-string
    hljs-symbol
    hljs-title
    ignore
  ]


  def initialize(page_html, current_url)
    @current_url = current_url
    @document = Nokogiri::HTML.parse page_html
  end


  def page
    @document
  end


  def html
    return @html if defined? @html
    process!
    @html = @document.at_css("body").inner_html.strip
  end

  def page_title
    @document.at_css("title").text.sub(Book::PAGE_TITLE_PREFIX, "")
  end


  def process!
    @document.at_css("head")&.remove
    @document.at_css("html").remove_attribute("class")
    @document.at_css("body").remove_attribute("class")
    @document.at_css("body").inner_html = @document.at_css("main").inner_html
    @document.css("script").each do |node| node.remove end
    @document.css(".buttons").each do |node| node.remove end
    @document.css(".hidden").each do |node| node.remove end
    @document.css(".header").each do |node| node.remove_attribute("id") end
    @document.css("a").each do |node| node.remove if node["href"].include?("#ferris") end

    CLASSES_TO_REMOVE.each do |class_name_to_remove|
      @document.css(".#{class_name_to_remove}").each do |node|
        node.remove_class(class_name_to_remove)
      end
    end

    @document.css("a").each do |link| make_link_absolute!(link) end
    @document.css("img").each do |img| make_img_source_absolute!(img) end

    remove_comments_from_paragraphs!
    remove_returns_from_content_tags!

    refactor_double_pre!
    convert_captions!

    @document.entries.each do |node|
      node.remove_attribute("class") if node["class"] == ""
    end

    @document
  end

  private


  def convert_captions!
    @document.css("pre + p > span.caption").each do |node|
      node.parent.name = "caption"
      node.remove_attribute("class")
      caption = node.parent
      caption.inner_html = node.inner_html
      figure = @document.create_element("figure")
      caption.next = figure
      pre = caption.previous_element
      pre.parent = figure
      caption.parent = figure
    end
  end


  def refactor_double_pre!
    @document.css("pre pre").each do |inner_pre|
      outer_pre = inner_pre.parent
      outer_pre.inner_html = inner_pre.inner_html
    end
  end


  def make_link_absolute!(link)
    href = link["href"]
    return unless is_an_anchor?(href)
    link.attributes["href"].value = [@current_url, href].join
  end


  def make_img_source_absolute!(img)
    src = img["src"]
    return if "http" === src
    img.attributes["src"].value = [Book::PAGES_BASE, src].join("/")
  end


  def remove_returns_from_content_tags!
    ["p", "li"].each do |node_type|
      @document.css(node_type).each do |p|
        p.inner_html = p.inner_html.gsub("\n", " ")
      end
    end
  end


  def remove_comments_from_paragraphs!
    @document.css("p").each do |p|
      p.inner_html = p.inner_html.gsub("<!-- ignore -->", " ")
    end
  end


  private def is_an_anchor?(href)
    return false if href.nil?
    return false if href == ""
    return href[0] == "#"
  end

end
