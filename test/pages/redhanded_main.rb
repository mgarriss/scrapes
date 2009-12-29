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
class LocalRedhanded < Scrapes::Page
  rule :syndicate_link, 'a[@title^="Syndicate"]', '@href', 1
  rule :syndicate_content, 'a[@title^="Syndicate"]', 'text()', 2
  rule :script_language, 'script[@language="JavaScript"]', '@language', 1
  rule :links, 'a', '@href'
  rule :yo, 'div', 'texts()'
  rule :foo, 'div', 'content()'
  rule :bar, 'div', 'contents()'

  rule :element, nil, nil, 1 do |doc|
    doc.search('.div')
  end

  selector :dude do |doc|
    doc.search('div')
  end
  extractor :dudes do |elem|
    elem.name
  end
  rule :dude_rule, :dude, :dudes
  rule :li, 'li' do |elem|
    nil
  end

  validates_presence_of \
    :syndicate_link,
    :syndicate_content,
    :links,
#    :element,
    :dude_rule,
#    :dude_rule2,
    :script_language
end
################################################################################
