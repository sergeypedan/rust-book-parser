# frozen_string_literal: true

module HtmlFetchers
  class Chrome

    def initialize(url:)
      @browser = create_browser(head: false)
      @url = url
    end

    def html
      @browser.get(@url)
      @browser.page_source
    end

    def create_browser(head: false)
      @br ||= if head
                Selenium::WebDriver.for(:chrome)
              else
                Selenium::WebDriver.for(:chrome, options: Selenium::WebDriver::Chrome::Options.new(args: ['headless']))
              end
    end

  end
end
