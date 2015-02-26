#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

require "erubis"

module Webrb
  class Controller
    attr_reader :env
    def initialize env
      @env = env
    end
    def render view_name, ctx={}
      filename = File.join("app", "views", controller_name, "#{view_name}.html.erb")
      template = File.read filename
      eruby = Erubis::Eruby.new template
      eruby.result ctx.merge(:env => @env)
    end
    def controller_name
      klass = self.class.to_s.gsub(/Controller$/, "")
      Webrb.to_underscore klass
    end
  end
end
