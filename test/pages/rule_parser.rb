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
class RuleParserTest < Scrapes::Page
  ################################################################################
  rule :p_test, 'p'
  rule :div_test, 'div'
  rule_1 :p_test_1, 'p'
  rule_1 :div_test_1, 'div'
  ################################################################################
  selector :just_doc     do |doc| doc end
  selector :css_search   do |doc| doc.search(".ya") end
  selector :xpath_search do |doc| doc.search("//span/div") end
  rule_1 :just_doc_test, :just_doc
  rule_1 :css_search_test, :css_search
  rule_1 :xpath_search_test, :xpath_search
  ################################################################################
  selector :font
  rule :font_test, :font
  selector :string, "//span/p"
  rule :string_test, :string
  ################################################################################
  extractor :just_node do |node| node end
  extractor :attributes_class do |node| node.attributes['class'] end
  rule_1 :just_node_test, nil, :just_node
  rule :attributes_class_test, 'div', :attributes_class
  ################################################################################
  # TODO dry!
  ################################################################################
  rule :font_content, 'font', 'content()'
  rule_1 :font_content_1, 'font', 'content()'
  rule_1 :div_this, 'div#this', 'content()'
  rule_1 :title, 'title', 'content()'
  ################################################################################
  rule :font_contents, 'font', 'contents()'
  rule_1 :font_contents_1, 'font', 'contents()'
  rule_1 :div_this_s, 'div#this', 'contents()'
  rule_1 :title_s, 'title', 'contents()'
  ################################################################################
  rule :font_text, 'font', 'text()'
  rule_1 :font_text_1, 'font', 'text()'
  rule_1 :div_this_t, 'div#this', 'text()'
  rule_1 :title_t, 'title', 'text()'
  ################################################################################
  rule :font_texts, 'font', 'texts()'
  rule_1 :font_texts_1, 'font', 'texts()'
  rule_1 :div_this_ts, 'div#this', 'texts()'
  rule_1 :title_ts, 'title', 'texts()'
  ################################################################################
  rule :font_word, 'font', 'text()'
  rule_1 :font_word_1, 'font', 'text()'
  rule_1 :div_this_w, 'div#this', 'word()'
  rule_1 :title_w, 'title', 'word()'
  ################################################################################
  rule :font_words, 'font', 'texts()'
  rule_1 :font_words_1, 'font', 'texts()'
  rule_1 :div_this_ws, 'div#this', 'words()'
  rule_1 :title_ws, 'title', 'words()'
end
################################################################################
