#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

require "./config/application.rb"

app = BestQuotes::Application.new

use Rack::ContentType

app.route do
  root "quotes#index"
  match "sub-app", proc { [200, {}, ["Hello, sub-app!"]] }

  match ":controller/:id/:action"
  get ":controller/:id", :default => { "action" => "show" }
  post ":controller/:id", :default => { "action" => "show" }
  head ":controller/:id", :default => { "action" => "show" }
  put ":controller/:id", :default => { "action" => "show" }
  delete ":controller/:id", :default => { "action" => "show" }
  patch ":controller/:id", :default => { "action" => "show" }
  match ":controller", :default => { "action" => "index" }
end

run app
