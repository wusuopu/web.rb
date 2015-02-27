require "webrb/version"
require "webrb/routing"
require "webrb/util"
require "webrb/dependencies"
require "webrb/controller"
require "webrb/file_model"

module Webrb
  class Application
    def call env
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(act)

      if controller.get_response
        st, hd, rs = controller.get_response.to_a
        [st, hd, [rs.body].flatten]
      else
        [200, {"Content-Type" => 'text/html'}, [text]]
      end
    end
  end
end
