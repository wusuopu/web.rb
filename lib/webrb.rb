require "webrb/version"
require "webrb/routing"
require "webrb/array"

module Webrb
  class Application
    def call env
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(act)
      [200, {"Content-Type" => 'text/html'}, [text]]
    end
  end

  class Controller
    attr_reader :env
    def initialize env
      @env = env
    end
  end
end
