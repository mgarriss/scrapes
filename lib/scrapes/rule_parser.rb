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
#--
# This started as a branch of the uformatparser lib by:
#   Author:: Assaf Arkin assaf@labnotes.org
#   Documentation:: http://trac.labnotes.org/cgi-bin/trac.cgi/wiki/Ruby/MicroformatParser
#   Copyright:: Copyright (c) 2005 Assaf Arkin
#   License:: Creative Commons Attribution-ShareAlike
# Rewrite and Hpricot support by Michael Garriss
#++
################################################################################
require 'yaml'
require 'scrapes/hpricot'
################################################################################
module Scrapes
  ################################################################################
  # The methods defined here are available at the class scope level of a Scrapes::Page
  # subclass.  For example:
  #   class Foobar < Scrapes::Page
  #     rule :foo, 'foo'
  #     rule_1 :bar, 'bar', 'text()'
  #   end
  #--
  # === Using <tt>rule</tt>
  # === Using <tt>rule_1</tt>
  # === Using <tt>selector</tt>
  # === Using <tt>extractor</tt>
  #++
  module RuleParser
    ################################################################################
    # name:: the name later used to invoke this rule
    # select:: the selector to use, String or Symbol
    # extract:: the extractor to use, String, Symbol, or Class. See RuleParser#extractor
    # limit:: the limit of nodes to send to extractor
    # block:: a block extractor, must not be defined if extract is non-nil
    # Example:
    #   class Foobar < Scrapes::Page
    #     rule :foo, 'foo'
    #   end
    # Later it's used as an instance method on the Scrapes::Page objects like this:
    #   foobar.foo.each do |foo|
    #     example.attr << foo
    #   end
    def rule(name, select = '', extract = nil, limit = -1, &block)
      raise InvalidRuleException, "First argument (rule name) is required" unless name
      attr name, true
      self.rules << Rule.new(name, selector(nil,select), extractor(nil,extract,&block), limit)
    end

    ################################################################################
    # Almost the same as rule except forces limit to be 1.  The other difference is
    # that RuleParser#rule returns collections of matches (an Array or size 1 even) where as
    # RuleParser#rule_1 just returns the match.
    # name:: the name later used to invoke this rule
    # select:: the selector to use, String or Symbol
    # extract:: the extractor to use, String, Symbol, or Class
    # block:: a block extractor, must not be defined if extract is non-nil
    # Example:
    #   class Foobar < Scrapes::Page
    #     rule_1 :bar, 'tr'
    #   end
    # Later it's used as an instance method on the Scrapes::Page objects like this:
    #   example.attr = foobar.bar
    def rule_1(name, selector = '', extractor = nil, &block)
      rule(name, selector, extractor, 1, &block)
    end
   
    ################################################################################
    # Creates a standalone selector that can later be used in a rule.  Example:
    #   class Foobar < Scrapes::Page
    #     selector :foo_select, 'table'
    #     rule_1 :bar, :foo_select # a Symbol triggers use of the selector
    #   end
    # name:: the name later used to invoke this selector
    # select:: the selector to use, String or NilClass
    # block:: a block selector, must not be defined if select is non-nil
    # A block selector is yielded the Hpricot doc object just once.  The collection it
    # returns is interated over and each match is passed to the extractor.  Example:
    #   class Foobar < Scrapes::Page
    #     selector :foo_select_2 do |hpricot_doc|
    #       doc.search('table')
    #     end
    #     rule_1 :bar, :foo_select_2 # a Symbol triggers use of the selector
    #   end
    # String selectors passed to <tt>rule</tt> or <tt>rule_1</tt> are interpreted as Hpricot
    # search strings.  See http://code.whytheluckystiff.net/hpricot/wiki/AnHpricotShowcase
    def selector(name, select = nil, &block)
      tor '@selector', name, select, &block
    end

    ################################################################################
    # Creates a standalone extractor that can later be used in a rule.  Example:
    #   class Foobar < Scrapes::Page
    #     extractor :mailto_extract do |elem|
    #       elem.attributes['href'].sub(/mailto:/,'') # remove the mailto: string
    #     end
    #     rule :emails, 'a[@href^="mailto:"]', :mailto_extract
    #   end
    # name:: the name later used to invoke this selector
    # extract:: the extractor to use, String or NilClass
    # block:: a block extractor, must not be defined if extract is non-nil
    # A block extractor is yielded each object that matched the rules's selector.
    #
    # Extractors passed to <tt>rule</tt> or <tt>rule_1</tt> are interpreted based on
    # the class of the extractor as follows
    # ==== NilClass
    # The result of the selector is just re-returned.  Thus <tt>foo.my_rule</tt> would
    # just return the selector results defined on the :my_rule rule.
    # ==== Symbol
    # An custom extractor is used.  See above docs for this method for an example.
    # ==== Class
    # A nested class of the given name is used as a new inner-parser. An instance of that
    # class is returned from each invocation of the extractor.  Example:
    #    class Outer < Scrapes::Page
    #      class Inner < Scrapes::Page
    #       rule_1 :bold_text, 'b', 'text()'
    #       rule_1 :img_src, 'img[@src]', '@src'
    #      end
    #      rule :items, 'tr', Inner
    #    end
    # Now calling <tt>my_page.items</tt> returns an Array of Inner objects that each
    # separately parses out the bold text and image source of each table row in the
    # document.
    # ==== String
    # Two patterns:
    # @foobar:: extract out the contents of an attibute named 'foobar'
    # foobar():: invoke the foobar builtin extractor, see Scrapes::Hpricot::Extractors
    def extractor(name, extract = nil, &block)
      tor '@extractor', name, extract, &block
    end

    ################################################################################
    def parse(node, context = nil, rules = nil) # :nodoc:
      context = self.new() unless context                               
      rules   = self.rules unless rules
      if rules
        rules.each_with_index do |rule, index|
          if rule and rule.process(node, context)
            less_rules = rules.clone unless less_rules
            less_rules[index] = nil
          end
        end
      end
      context
    end

    ################################################################################
    def rules() # :nodoc:
      @microparser_rules ||= []
    end

    private

    ################################################################################
    def tor(type, name, tor_arg = nil, &block)
      raise InvalidRuleException, "can't use both arg and block" if tor_arg and block
      result = case (tor_arg ||= block)
      when NilClass     then proc {|node| node}
      when String
        if type == '@selector'
          proc {|node| node.search(tor_arg)}
        else
          Extractor.new self, tor_arg
        end
      when Proc, Method then tor_arg
      when Symbol       then proc {|node| send(tor_arg,node) }
      when Class
        begin
          tor_arg.method(:parse)
        rescue NameError=>error
          raise InvalidRuleException,
            "Selector class must implement the method parse", error.backtrace
        end
        tor_arg
      else
        raise InvalidRuleException,
          "Invalid tor type: must be a string, parser class, block or nil"
      end
      # TODO dry
      if type == "@selector"
        self.class.class_eval { (@selector ||= {})[name] = result }
        class_def(name) do |node|
          self.class.class_eval { @selector[name].call(node) }
        end if name
      else
        self.class.class_eval { (@extractor ||= {})[name] = result }
        class_def(name) do |node|
          self.class.class_eval { @extractor[name].call(node) }
        end if name
      end
      result
    end

    ################################################################################
    def self.included(mod) # :nodoc:
      mod.extend(self)
      mod.extend(Scrapes::Hpricot::Extractors)
    end

    ################################################################################
    class Rule #:nodoc:all
      attr :name
      attr :limit,true
      attr :selector
      attr :extractor

      ################################################################################
      def initialize(name, selector, extractor, limit)
        @name, @selector, @extractor, @limit = name.to_s.intern, selector, extractor, limit
      end

      ################################################################################
      def process(node, context)
        context.instance_variable_set '@hpricot', node
        return true if @limit == 0
        result = @selector.call(node)
        result = [result] unless result.respond_to? :each
        current = context.instance_variable_set "@#@name", []
        result.compact.each do |node|
          value = case @extractor
          when UnboundMethod then @extractor.bind(context).call(node)
          when Extractor     then @extractor.extract(node)
          when Proc, Method  then @extractor.call(node)
          when Class         then @extractor.parse(node)
          end
          next unless value
          current << value
          break if current.size == @limit
        end
        context.instance_variable_set "@#@name", current[0] if @limit == 1
        true
      end

      ################################################################################
      def inspect
        @selector ? "[to #{@name} from #{@selector.inspect}, #{@extractor.inspect}, limit #{@limit}]" : "[to #{@name} from #{@extractor.inspect}, limit #{@limit}]"
      end
    end

    ################################################################################
    class Extractor # :nodoc:all
      # TODO review this
      # Parse each extractor into three parts:
      # $1 function name (excluding parentheses)
      # $2 element name
      # $3 attribute name (including leading @)
      # If a match is found the result is either $1, or $2 and/or $3
      REGEX = /^(\w+)\(\)|([A-Za-z][A-Za-z0-9_\-:]*)?(@[A-Za-z][A-Za-z0-9_\-:]*)?$/

      ################################################################################
      def initialize(context, statement) # :nodoc:
        statement.strip!
        @extracts = []
        statement.split('|').each do |extract|
          parts = REGEX.match(extract)
          if parts[1]
            begin
              @extracts << context.method(parts[1])
            rescue NameError=>error
              raise InvalidRuleException, error.message, error.backtrace
            end
          elsif parts[2] and parts[3]
            attr_name = parts[3][1..-1]
            @extracts << proc do |node|
              node.attributes[attr_name] if node.name == parts[2]
            end
          elsif parts[2]
            @extracts << proc { |node| text(node) if node.name == parts[2] }
          elsif parts[3]
            attr_name = parts[3][1..-1]
            @extracts << proc do |node|
              if node.respond_to? :each
                node.all.attributes.all[attr_name]
              else
                node.attributes[attr_name]
              end
            end
          else
            raise InvalidRuleException, "Invalid extraction statement"
          end
        end
        raise InvalidRuleException, "Invalid (empty) extraction statement" if
          @extracts.size == 0
      end

      ################################################################################
      def extract(node) # :nodoc:
        value = nil
        @extracts.find do |extract|
          value = extract.call(node)
        end
        value
      end

      ################################################################################
      def inspect() # :nodoc:
        @extracts.join('|')
      end
    end

    ################################################################################
    class InvalidRuleException < Exception # :nodoc:all
    end
  end
end
