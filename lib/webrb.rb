require "webrb/version"
require "webrb/array"

module Webrb
  class Application
    def call env
      [200, {"Content-Type" => 'text/html'}, ["Hello from web.rb!"]]
    end
  end
end
