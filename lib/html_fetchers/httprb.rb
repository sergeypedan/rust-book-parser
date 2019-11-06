# frozen_string_literal: true

module HtmlFetchers
  class Httprb

    require "http"

    def initialize(url:)
      @url = url
    end

    def html
      puts "Downloading #{@url}"
      HTTP.get(@url).body.to_s
    end

  end
end
