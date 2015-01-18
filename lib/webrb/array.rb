#!/usr/bin/env ruby
#-*- coding:utf-8 -*-

class Array
  def sum start=0
    inject start, &:+
  end
end
