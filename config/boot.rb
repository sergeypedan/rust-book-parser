# frozen_string_literal: true

require "bundler/setup"
Bundler.require

require_relative "book"
require_relative "../lib/ebook/opf"
require_relative "../lib/ebook/wrapper"
require_relative "../lib/html_fetchers/chrome"
require_relative "../lib/html_fetchers/httprb"
require_relative "../lib/html_fetchers/local"
require_relative "../lib/name"
require_relative "../lib/page_transformer"
require_relative "../lib/processor"
require_relative "../lib/saver"
