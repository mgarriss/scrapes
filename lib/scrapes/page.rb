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
require 'scrapes/rule_parser'
require 'hpricot'
#require 'rextra'
################################################################################
module Scrapes
  def __meta() class << self; self end end
  def meta_eval(&blk) __meta.instance_eval( &blk ) end
  ################################################################################
  # The page class is used as a base class for scraping data out of one web
  # page.  To use it, you inherit from it and setup some rules.  You can also
  # use validators to ensure that the page was scraped correctly.
  #
  # == Setup
  #
  #   class MyPageScraper < Scrapes::Page
  #     rule :rule_name, blah
  #   end
  # Scrapes::RuleParser explains the use of rules.
  #
  # == Auto Loading
  #
  # Scrapes will automatically 'require' ruby files placed in a special 'pages' directory.
  # The idea is to place one Scrapes::Page derived class per file in the pages directory,
  # and have it required for you.
  #
  # == Validations
  #
  # There are a few class methods that you can use to validate the contents you scraped
  # from a given web page.
  class Page
    include Scrapes::Hpricot::Extractors

    XSLTPROC = 'xsltproc' # :nodoc

    ################################################################################
    # RuleParser is used to extract data from web pages using CSS selectors
    # and raw element access by using procs.
    include RuleParser
    
    ################################################################################
    # Access the URI where this page's data came from
    attr_accessor :uri

    ################################################################################
    # Access the session object that was used to fetch this page's data
    attr_accessor :session

    ################################################################################
    # Access the Hpricot object that the selectors are passed
    attr_accessor :hpricot

    ################################################################################
    # If the page that you are parsing is paginated (one page in many of similar data)
    # you can use this class method to automatically fetch all pages.  In order for this
    # to work, you need to provide a few special methods:
    #
    # === Next Page
    #
    # If you know the URL to the next page, then provide a instance method called 
    # <tt>next_page</tt>.  It should return the URL for the next page, or nil when 
    # the current page is the last page.
    #
    # class NextPageExample < Scrapes::Page
    #   rule(:next_page, 'a[href~=next]', '@href', 1)
    # end
    #
    # === Link for Page
    #
    # Alternatively, you can provide a instance method <tt>link_for_page</tt> and
    # another one called <tt>pages</tt>.  The <tt>pages</tt> method should return the
    # number of pages in this paginated set.  The <tt>link_for_page</tt> method should
    # take a page number, and return a URL to fetch that page.
    #
    # class LinkForPageExample < Scrapes::Page
    #   rule_1(:page) {|e| m = e.text.match(/Page\s+\d+\s+of\s+(\d+)/) and m[1].to_i}
    #
    #   def link_for_page (page)
    #     uri.sub(/page=\d+/, "page=#{page}")
    #   end
    # end
    #
    # === Append to Page
    #
    # Finally, you must provide a <tt>append_page</tt> method.  It takes an instance
    # of your Scrapes::Page derived class as an argument.  Its job is to add the data
    # found on the current page to its instance variables.  This is because when you use
    # paginated, it only returns one instance of your class.
    def self.paginated
      meta_eval { @paginated = true }
    end

    ################################################################################
    # Make Page.extract return an array by calling the given method.  This can be 
    # very useful for when your class does nothing more than collect a set of links
    # for some other page to process.  It cases Session#page to call the given block
    # once for each object returned from method_to_call.
    def self.acts_as_array (method_to_call)
      meta_eval { @as_array = method_to_call }
    end

    ################################################################################
    # Preprocess the HTML by sending it through an XSLT stylesheet.  The stylesheet
    # should return a document that can be then processed using your rules.  Using
    # this feature requires that you have the xsltproc utility in your PATH.
    # You can get xsltproc from libxslt: http://xmlsoft.org/XSLT/
    def self.with_xslt (filename)
      raise "#{XSLTPROC} could not be found" unless `#{XSLTPROC} --version 2>&1`.match(/libxslt/)
      meta_eval { @with_xslt = filename }
    end

    ################################################################################
    # Ensure that the given attributes have been set by matching rules
    def self.validates_presence_of (*attrs)
      attrs, options = attrs_options(attrs, {
        :message => 'rule never matched',
      })

      validates_from(attrs, options, lambda {|a| !a.nil?})
    end

    ################################################################################
    # Ensure that the given attributes are not #blank?
    def self.validates_not_blank (*attrs)
      attrs, options = attrs_options(attrs, {
        :message => 'rule never matched',
      })

      validates_from(attrs, options, lambda {|a| !a.blank?})
    end

    ################################################################################
    # Ensure that the given attributes have the correct format
    def self.validates_format_of (*attrs)
      attrs, options = attrs_options(attrs, {
        :message  => 'did not match regular expression',
        :with     => /.*/,
      })

      validates_from(attrs, options, lambda {|a| a.to_s.match(options[:with])})
    end

    ################################################################################
    # Ensure that the given attributes have values in the given list
    def self.validates_inclusion_of (*attrs)
      attrs, options = attrs_options(attrs, {
        :message  => 'is not in the list of accepted values',
        :in       => [],
      })

      validates_from(attrs, options, lambda {|a| options[:in].include?(a)})
    end

    ################################################################################
    # Ensure that the given attribute is a number
    def self.validates_numericality_of (*attrs)
      attrs, options = attrs_options(attrs, {
        :message  => 'is not a number',
      })

      closure = lambda do |a|
        begin
          Kernel.Float(a.to_s)
        rescue ArgumentError, TypeError
          false
        else
          true
        end
      end

      validates_from(attrs, options, closure)
    end

    ################################################################################
    # If using acts_as_array that returns links, send them to another class
    def self.to (other_class)
      ToProxy.new(self, other_class)
    end

    ################################################################################
    # Called by the crawler to process a web page
    def self.extract (data, uri, session, &block)
      obj = process_page(data, uri, session)

      if meta_eval {@paginated}
        if obj.respond_to?(:next_page)
          sister = obj

          while sister_uri = sister.next_page
            sister = extract_sister(session, obj, sister_uri)
          end
        elsif obj.respond_to?(:link_for_page)
          (2 .. obj.pages).each do |page|
            sister_uri = obj.link_for_page(page)
            extract_sister(session, obj, sister_uri)
          end
        end
      end

      as_array = meta_eval {@as_array}
      obj = obj.send(as_array) if as_array

      return obj unless block
      obj.respond_to?(:each) ? obj.each {|o| yield(o)} : yield(obj)
    end

    ################################################################################
    # Have a chance to do something after parsing, but before validataion
    def after_parse
    end

    ################################################################################
    # Have a chance to do something after successful validataion
    def after_validate
    end

    ################################################################################
    # Called by the extract method to validate scraped data.  If you override this 
    # method, you should call super.  This method will probably be changed in the
    # future so that you don't have to call super.
    def validate
      validations = self.class.meta_eval { @validations }

      validations.each do |v|
        raise "#{self.class}.#{v[:name]} #{v[:options][:message]}" unless
          v[:proc].call(send(v[:name]))
      end

      self
    end

    ################################################################################
    protected

    ################################################################################
    # Called by extract to process a page object
    def self.process_page (data, uri, session)
      if file = meta_eval { @with_xslt }
        options = "--html '#{file}' -"

        open("|#{XSLTPROC} #{options} 2> /dev/null", 'w+') do |xsltproc|
          xsltproc << data
          xsltproc.close_write
          data = xsltproc.read
        end
      end

      obj = parse(Hpricot(data))
      obj.uri = uri
      obj.session = session
      obj.after_parse
      obj.validate
      obj.after_validate
      obj
    end

    ################################################################################
    # Called by extract to process paginated objects
    def self.extract_sister (session, obj, sister_uri)
      res = session.crawler.fetch(sister_uri)
      sister = process_page(res.body, sister_uri, session)
      obj.append_page(sister)
      sister
    end

    ################################################################################
    private
    
    ################################################################################
    # Add some things to sub-classes
    def self.inherited (klass)
      klass.meta_eval do
        @validations = []
        @paginated   = false
        @as_array    = false
      end
    end

    ################################################################################
    # generic way to add validation
    def self.validates_from (attrs, options, closure)
      meta_eval do
        attrs.each do |a|
          @validations << {
            :name     => a, 
            :options  => options,
            :proc     => closure,
          }
        end
      end
    end

    ################################################################################
    # helper to correctly parse the validate calls
    def self.attrs_options (attrs, options)
      ops = attrs.pop if attrs.last.is_a?(Hash)
      options.update(ops) if ops
      [attrs, options]
    end

  end
  ################################################################################
end
################################################################################
