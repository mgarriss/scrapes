################################################################################ #
# Copyright (C) 2006 Peter J Jones (pjones@pmade.com)
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
################################################################################
require 'rubygems'
################################################################################
require 'scrapes'
################################################################################
require 'test/lib/server'
require 'test/unit'

class TestRedhandedPage < Test::Unit::TestCase
  include LocalHTTPServer

  def setup
    start_server
    Scrapes::Initializer.run do |initializer|
      initializer.pages_parent = 'test'
      initializer.process
    end
  end

  def teardown
    stop_server
  end

  def test_truth
    assert @server
  end

  def test_texts
    Scrapes::Session.start do |session|
      @page = session.page(LocalRedhanded, localhost_url('redhanded.html'))
    end
  end
end
