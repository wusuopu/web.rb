#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

require_relative "test_helper"

class TestApp < Webrb::Application
end

class WebrbAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    TestApp.new
  end

  def test_request
    get "/"

    assert last_response.ok?
    assert last_response.body['Hello']
  end
end
