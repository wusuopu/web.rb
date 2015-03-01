#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

module Webrb
  class RouteObject
    def initialize
      @rules = []
    end
    def root *args
      match "", *args
    end

    %w(get post head put delete patch).each do |method|
      define_method(method) { |url, *args|
      options = {}
      options = args[-1] if args[-1].is_a?(Hash)
      options[:via] = method.upcase
      match url, *args
      }
    end
    def match url, *args
      options = {}
      options = args.pop if args[-1].is_a?(Hash)
      options[:default] ||= {}

      dest = nil
      dest = args.pop if args.size > 0
      raise "Too many args!" if args.size > 0

      parts = url.split "/"
      parts.select! { |p| !p.empty? }

      vars = []
      regexp_parts = parts.map do |part|
        if part[0] == ":"
          vars << part[1..-1]
          "([a-zA-Z0-9]+)"
        elsif part[0] == "*"
          vars << part[1..-1]
          "(.*)"
        else
          part
        end
      end

      regexp = regexp_parts.join "/"
      @rules.push({
        :regexp => Regexp.new("^/#{regexp}$"),
        :vars => vars,
        :dest => dest,
        :options => options,
      })
    end
    def check_url url, request_method="GET"
      @rules.each do |r|
        m = r[:regexp].match url
        if !m
          next
        end

        options = r[:options]
        if options[:via] && options[:via].upcase != request_method
          next
        end

        params = options[:default].dup
        r[:vars].each_with_index do |v, i|
          params[v] = m.captures[i]
        end
        if r[:dest]
          return get_dest r[:dest], params
        else
          controller = params["controller"]
          action = params["action"]
          return get_dest "#{controller}" + "##{action}", params
        end
      end

      nil
    end
    def get_dest dest, routing_params={}
      return dest if dest.respond_to?(:call)
      if dest =~ /^([^#]+)#([^#]+)$/
        name = $1.capitalize
        cont = Object.const_get("#{name}Controller")
        return cont.action($2, routing_params)
      end
      raise "No destination: #{dest.inspect}!"
    end
  end
  class Application
    def route &block
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
    end
    def get_rack_app env
      raise "No routes!" unless @route_obj
      rack_app = @route_obj.check_url env['PATH_INFO'], env['REQUEST_METHOD']
      raise "No routes!" unless rack_app
      rack_app
    end
    def get_controller_and_action env
      _, controller, action, _ =
        env["PATH_INFO"].split('/', 4)
      controller.capitalize!.concat "Controller"
      [Object.const_get(controller), action]
    end
  end
end
