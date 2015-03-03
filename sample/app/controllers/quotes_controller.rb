#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

class QuotesController < Webrb::Controller
  def a_quote
    @noun = :winking
    render :a_quote
  end
  def index
    @quotes = FileModel.all
    render :index
  end
  def quote_1
    @obj = FileModel.find 1
    render :quote
  end
  def new_quote
    attrs = {
      "submitter" => "web user",
      "quote" => "A picture is worth one k pixels",
      "attribution" => "Me"
    }
    @obj = FileModel.create attrs
    render :quote
  end
  def show
    @obj = FileModel.find(params["id"])
    render_response :quote
  end
end
