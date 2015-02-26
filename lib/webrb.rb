require "webrb/version"
require "webrb/routing"
require "webrb/util"
require "webrb/dependencies"
require "webrb/controller"

module Webrb
  class Application
    def call env
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(act)
      [200, {"Content-Type" => 'text/html'}, [text]]
    end
  end
end
