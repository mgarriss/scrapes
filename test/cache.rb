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
require 'scrapes/cache'
require 'test/unit'

class TestCache < Test::Unit::TestCase
  include LocalHTTPServer

  def setup
    start_server
    @cache = Scrapes::Cache.new
  end

  def teardown
    stop_server
    FileUtils.remove_dir 'cache' if File.exist? 'cache'
  end

  def test_truth
    assert @server
    assert @cache
  end

  def test_directory_attr
    assert_equal @cache.directory, File.expand_path('cache')
    assert_nothing_raised { @cache.directory = 'cache' }
    assert_equal @cache.directory, 'cache'
  end

  def test_enabled_attr
    assert_equal @cache.enabled, false
    assert_nothing_raised { @cache.enabled = true }
    assert @cache.enabled
  end

  def test_update
    assert_nothing_raised { @cache.update 'foo.txt', localhost_http_get('foo.txt') }
    assert(!@cache.check('foo.txt'))
    assert_nothing_raised { @cache.enabled = true }
    assert_nothing_raised { @cache.update 'foo.txt', localhost_http_get('foo.txt') }
    assert(@cache.check('foo.txt'))
  end

  def test_without_cache
    assert_nothing_raised { @cache.enabled = true }
    @cache.without_cache do
      assert_nothing_raised { @cache.update 'foo.txt', localhost_http_get('foo.txt') }
      assert(!@cache.check('foo.txt'))
    end
  end
end
