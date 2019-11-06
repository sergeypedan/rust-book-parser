# frozen_string_literal: true

module Ebook
  class Opf

    PATH = "output/epub/OEBPS/content.opf".freeze

    def initialize(pages_data:)
      fail ArgumentError, "`pages_data` must be an Array" unless pages_data.is_a? Array
      @context = OpfContext.new(pages_data)
    end

    def result
      fail ArgumentError, "layout file is empty" if template.to_s == ""
      bnd = @context.get_binding
      ERB.new(template, 0, '>').result(bnd)
    end

    private

    def template
      File.read "templates/opf.erb"
    end

  end

  class OpfContext

    def initialize(pages_data)
      @authors      = Book::AUTHORS
      @contributors = Book::CONTRIBUTORS
      @pages        = pages_data
      @meta         = { book_id: Book::ID, book_title: Book::TITLE, language: Book::LANGUAGE }
    end

    def get_binding
      binding
    end

  end
end
