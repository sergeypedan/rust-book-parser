# frozen_string_literal: true

require "erb"

module Ebook

  class Wrapper

    def initialize(content:, title:)
      @context = PageContext.new(content: content, title: title)
    end

    def html
      fail ArgumentError, "layout file is empty" if template.to_s == ""
      ERB.new(template, 0, '>').result(@context.get_binding)
    end

    private

    def template
      File.read "templates/layout.erb"
    end

  end

  class PageContext

    def initialize(content:, title:)
      fail ArgumentError, "`content` must not be an empty string" if content == ""
      fail ArgumentError,   "`title` must not be an empty string" if title == ""
      @content = content
      @title = title
    end

    def get_binding
      binding
    end

  end
end
