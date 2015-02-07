#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

class Object
  def self.const_missing c
    require Webrb.to_underscore(c.to_s)
    Object.const_get(c)
  end
end
