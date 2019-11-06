# frozen_string_literal: true

module HtmlFetchers
  class Local

    def initialize(url:)
      @url = url
    end

    def html
      File.read("fixtures/chapter.html")
    end

  end
end
