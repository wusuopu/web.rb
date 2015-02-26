#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

require_relative "test_helper"

class TestController < Webrb::Controller
  def index
    "Hello!"
  end
end
class TestApp < Webrb::Application
  def get_controller_and_action env
    [TestController, "index"]
  end
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
