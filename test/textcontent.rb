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

class TestSimpleHTMLPage < Test::Unit::TestCase
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
      @page = session.page(LocalSimple, localhost_url('simple.html'))

      assert_equal ["OneenO"], @page.content_one
      assert_equal ["TwoowT"], @page.content_two
      assert_equal ["Three"], @page.content_three

      assert_equal [["One", "enO"]], @page.contents_one
      assert_equal [["Two", "owT"]], @page.contents_two
      assert_equal [["Three"]], @page.contents_three

      assert_equal ["OneTwoThreeowTenO"], @page.text_one
      assert_equal ["TwoThreeowT"], @page.text_two
      assert_equal ["Three"], @page.text_three

      assert_equal [["One", ["Two", ["Three"], "owT"], "enO"]], @page.texts_one
      assert_equal [["Two", ["Three"], "owT"]], @page.texts_two
      assert_equal [["Three"]], @page.texts_three
    end
  end
end
