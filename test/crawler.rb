################################################################################
#
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
require 'fileutils'
require 'test/lib/server'
require 'scrapes/crawler'
require 'scrapes/session'
require 'test/unit'

class TestCrawler < Test::Unit::TestCase
  include LocalHTTPServer

  def setup
    @session = Scrapes::Session::new
    start_server
    @crawler = Scrapes::Crawler.new @session
  end

  def teardown
    stop_server
    FileUtils.remove_dir 'cache' if File.exist? 'cache'
  end

  def test_truth
    assert @session
    assert @server
    assert @crawler
  end

  def test_cache_attr
    assert @crawler.cache
    cache = Scrapes::Cache.new
    assert_nothing_raised { @crawler.cache = cache }
    assert_equal @crawler.cache, cache
  end

  def test_log_attr
    assert @crawler.log.nil?
    log = Object.new
    assert_nothing_raised { @crawler.log = log }
    assert_equal @crawler.log, log
  end

  def test_fetch
    assert @crawler.fetch(localhost_url('foo.txt'))
    assert_equal @crawler.fetch(localhost_url('dummy')).class, Net::HTTPNotFound
  end
end
