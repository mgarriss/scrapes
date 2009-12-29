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

  def test_local_redhanded
    Scrapes::Session.start do |session|
      @page = session.page(LocalRedhanded, localhost_url('redhanded.html'))
    end
    assert_equal  Array          , @page.syndicate_content.class
    assert_equal  2              , @page.syndicate_content.size 
    assert_equal  '/index.xml'   , @page.syndicate_link         
    assert_equal  'JavaScript'   , @page.script_language        
    assert_equal  274            , @page.links.size
    #assert_equal  0              , @page.element.size
    assert_equal  'RSS'          , @page.syndicate_content[0]   
    assert_equal  '2.0'          , @page.syndicate_content[1]   
  end

  def test_local_redhanded_enties
    Scrapes::Session.start do |session|
      @entries = session.page(LocalRedhandedEntries, localhost_url('redhanded.html'))
    end
    assert_equal 20, @entries.size
    #assert_equal "Denver Accord#", @entries[0].entry_title
  end

  def test_local_pagination_1
    Scrapes::Session.start do |session|
      @foil = session.page(LocalPagination, localhost_url('foil74.html'))
    end
  end
end
