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
###############################################################################
class LocalPagination < Scrapes::Page
  paginated
  acts_as_array(:links)

  selector(:select_next_image) do |doc|
    doc.search '//img'
  end

  extractor(:extract_next_link) do |element|
    p = element.parent and p.name.downcase == 'a' and p.attributes['href'].match(/foil/)
    p.attributes['href']
  end

  validates_presence_of(:next_link)
  rule(:next_link, :select_next_image, :extract_next_link, 1)

  selector(:select_llink) do |doc|
    doc.search 'a[@href^="foil"]'
  end

  validates_presence_of(:llink)
  rule(:llink, :select_llink, '@href')

  def next_page
    return nil if self.next_link == self.uri
    self.next_link
  end

  def append_page (sister)
    self.llink += sister.llink
  end

  def links
    self.llink.sort.uniq
  end
end
###############################################################################
