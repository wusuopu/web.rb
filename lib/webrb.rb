require "webrb/version"
require "webrb/routing"
require "webrb/util"
require "webrb/dependencies"
require "webrb/controller"
require "webrb/file_model"

module Webrb
  class Application
    def call env
      rack_app = get_rack_app env
      rack_app.call env
    end
  end
end
