#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

require "webrb"

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'app', 'controllers')

module BestQuotes
  class Application < Webrb::Application
  end
end
