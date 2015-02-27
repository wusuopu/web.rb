#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

require "erubis"
require "webrb/file_model"
require "rack/request"
require "rack/response"

module Webrb
  class Controller
    include Webrb::Model
    attr_reader :env
    def initialize env
      @env = env
    end
    def render view_name, ctx={}
      filename = File.join("app", "views", controller_name, "#{view_name}.html.erb")
      template = File.read filename
      eruby = Erubis::Eruby.new template
      instance_variables.each do |v|
        ctx[v.to_s[1..-1]] = instance_variable_get v
      end
      eruby.result ctx.merge(:env => @env)
    end
    def controller_name
      klass = self.class.to_s.gsub(/Controller$/, "")
      Webrb.to_underscore klass
    end

    def request
      @request ||= Rack::Request.new(env)
    end
    def params
      request.params
    end

    def response text, status=200, headers={}
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end
    def get_response
      @response
    end
    def render_response *args
      response render(*args)
    end
  end
end
