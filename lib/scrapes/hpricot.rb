################################################################################
#
# Copyright (C) 2006 Peter J Jones (pjones@pmade.com)
# Copyright (C) 2010 Michael D Garriss (mgarriss@gmail.com)
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
require 'cgi'
require 'hpricot'
################################################################################
module Scrapes
  ################################################################################
  module Hpricot # :nodoc:
    ################################################################################
    module Extractors
      ################################################################################
      # Returns the text of any child text nodes recursively concatenated.
      def text(node)
        text_process(node,String) do |e| text(e) end
      end

      ################################################################################
      # Returns the text of any child text nodes recursively as nested Array.
      def texts(node)
        text_process(node,Array) do |e| texts(e) end
      end

      ################################################################################
      # Returns the text of any child text nodes concatenated.
      def content(node)
        text_process(node,String) do |e| e.content end
      end

      ################################################################################
      # Returns the text of any child text nodes as an Array.
      def contents(node)
        text_process(node,Array) do |e| e.content end
      end

      ################################################################################
      # The result of text() with whitespace reduceded to single spaces and striped.
      def word(node)
        text_process(node,String) do |e| word(e).gsub(/\s+/,' ').strip end
      end

      ################################################################################
      # The result of texts() striped, flattened, whitespace reduced to single spaces, and
      # with all blank?s rejected.
      def words(node)
        texts(node).flatten.compact.map{|e|e.gsub(/\s+/,' ').strip}.reject{|e| e.blank?}
      end

      ################################################################################
      # Just reuturn the yielded node.
      def xml(node)
        node
      end

      protected
      ################################################################################
      def unescape
        case result = yield
        when String then CGI::unescapeHTML(result).gsub('&nbsp;', ' ')
        when Array then result.map{|e| Extractors::unescape{e}}
        when NilClass then nil
        else raise "should be Array or String, was: #{result.class}"
        end
      end
      ################################################################################
      def text_process(node, klass, &block)
        Extractors::unescape do
          case node
          when Array, ::Hpricot::Elements
            node.map do |elem|
              text_process(elem,klass,&block)
            end
          when ::Hpricot::Elem, ::Hpricot::Doc
            node.children.inject(klass.new) do |value,child|
              (value << block.call(child)) rescue nil
              value
            end
          when ::Hpricot::Text then node.content
          end
        end
      end

      module_function :word, :words, :text, :texts, :content, :contents, :text_process
    end
    ################################################################################
  end
  ################################################################################
end
################################################################################
