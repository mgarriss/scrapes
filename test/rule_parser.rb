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
$REXTRA_DEBUG = true
require 'rextra/debug'
include Rextra::Debug
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
    Scrapes::Session.start do |session|
      @page = session.page(RuleParserTest, localhost_url('rule_parser.html'))
    end
  end

  def teardown
    stop_server
  end

  def test_truth
    assert @server
    assert @page
  end

  def test_rule
    assert @page.p_test
    assert @page.div_test
    assert_equal Array, @page.p_test.class
    assert_equal Hpricot::Elem, @page.p_test.first.class
    assert_equal 3, @page.p_test.size
    assert_equal 4, @page.div_test.size
  end

  def test_rule_1
    assert @page.p_test_1
    assert @page.div_test_1
    assert(Array != @page.p_test_1.class)
    assert(Hpricot::Elements != @page.p_test_1.class)
    assert(Hpricot::Doc != @page.div_test_1.class)
  end

  def test_selector
    assert @page.just_doc_test
    assert @page.css_search_test
    assert @page.xpath_search_test
    assert_equal @page.just_doc_test.class, ::Hpricot::Doc
    assert_equal @page.css_search_test.class, ::Hpricot::Elem
    assert_equal @page.css_search_test.name, 'div'
    assert_equal @page.xpath_search_test.class, ::Hpricot::Elem
    assert_equal @page.xpath_search_test.name, 'div'
  end

  def test_extractor
    assert @page.just_node_test
    assert_equal @page.just_node_test.class, ::Hpricot::Doc
    assert_equal @page.attributes_class_test.class, Array
    assert_equal @page.attributes_class_test.size, 3
    assert_equal @page.attributes_class_test, ['a','ya','inner']
  end

  def test_content
    assert @page.font_content
    assert_equal @page.font_content, ["a","b","c"]
    assert @page.font_content_1
    assert_equal @page.font_content_1, "a"
    assert_equal @page.div_this.strip, ""
    assert_equal @page.title, "Rule Parser Test"
  end

  def test_contents
    assert @page.font_contents
    assert_equal @page.font_contents, [["a"],["b"],["c"]]
    assert @page.font_contents_1
    assert_equal @page.font_contents_1, ["a"]
    assert_equal @page.div_this_s.map{|e|e.strip}, ["","","","",""]
    assert_equal @page.title_s, ["Rule Parser Test"]
  end

  def test_text
    assert @page.font_text
    assert_equal @page.font_text, ["a","b","c"]
    assert @page.font_text_1
    assert_equal @page.font_text_1, "a"
    #assert_equal @page.div_this_t.strip, ""
    assert_equal @page.title_t, "Rule Parser Test"
  end

  def test_texts
    assert @page.font_texts
    assert_equal @page.font_texts, [["a"],["b"],["c"]]
    assert @page.font_texts_1
    assert_equal @page.font_texts_1, ["a"]
    #assert_equal @page.div_this_ts.flatten.map{|e|e.strip}, ["","","","",""]
    assert_equal @page.title_ts, ["Rule Parser Test"]
  end

  def test_word
    assert @page.font_word
    assert_equal @page.font_word, ["a","b","c"]
    assert @page.font_word_1
    assert_equal @page.font_word_1, "a"
    #assert_equal @page.div_this_t.strip, ""
    assert_equal @page.title_w, "Rule Parser Test"
  end

  def test_words
    assert @page.font_texts
    assert_equal @page.font_texts, [["a"],["b"],["c"]]
    assert @page.font_texts_1
    assert_equal @page.font_texts_1, ["a"]
    #assert_equal @page.div_this_ts.flatten.map{|e|e.strip}, ["","","","",""]
    assert_equal @page.title_ts, ["Rule Parser Test"]
  end

  def test_standalone_text
    assert text(@page.div_test.first)
    assert text(@page.div_test)
  end
end
