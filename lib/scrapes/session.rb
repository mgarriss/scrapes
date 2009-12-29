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
require 'scrapes/crawler'

module Scrapes
  ################################################################################
  # Session is used to process all web pages under a single session.  This may
  # be necessary when some web sites need you to login, or otherwise create 
  # a session ID with a cookie before you can continue processing pages.
  class Session
    ################################################################################
    attr_reader :log

    ################################################################################
    attr_accessor :post
    
    ################################################################################
    attr_accessor :timeout

    ################################################################################
    attr_accessor :cookies

    ################################################################################
    attr_reader :uri

    ################################################################################
    attr_reader :when
    
    ################################################################################
    attr_reader :crawler

    ################################################################################
    attr_reader :base_uris

    ################################################################################
    # Start a session using a HTTP GET
    def self.from_get (uri, &block)
      start_time = Time.now
      session = self.new
      session.uri = uri
      block ? yield(session) : session
      Time.now - start_time
    end

    ################################################################################
    # Start a session using HTTP POST
    def self.from_post (uri, post, &block)
      session = self.new
      session.uri = uri
      session.post = post
      block ? yield(session) : session
    end

    ################################################################################
    # Start a session witout having to create a session with the web site first.
    def self.start (log=nil,&block)
      session = self.new(log)
      block ? yield(session) : session
    end

    ################################################################################
    def initialize log = nil
      @uri = nil
      @post = {}
      @when = Time.at(0)
      @timeout = 900
      @cookies = Cookies.new
      @base_uris = []
      @crawler = Crawler.new(self)
      @crawler.log = @log = log
      @refreshing = false
    end

    ################################################################################
    def uri= (uri)
      @uri = uri
      @base_uris << uri
    end
    
    ################################################################################
    # Process a web page
    def page (page_class, link, post={}, &block)
      return if link.nil?
      link = [link] unless link.respond_to?(:to_ary)
      block ||= lambda {|data| data}
      result = nil

      link.each do |u|
        fetch(u, post) do |res|
          result = page_class.extract(res.body, u, self, &block)
        end
      end

      result
    end

    ################################################################################
    # redifne for fetch times
    def report_time time
    end

    ################################################################################
    # Fetch a URL in the session, but without a Scrapes::Page
    def fetch (uri, post={}, &block)
      start_time = Time.now
      u = absolute_uri(uri)
      @base_uris.push(u)
      yield(@crawler.fetch(u, post))
      report_time(Time.now - start_time)
      @base_uris.pop
    end

    ################################################################################
    # Refresh the session, sometimes necessary when you are getting pages out of the
    # cache, but then go to the real web site and the session has expired.
    def refresh
      if !@refreshing and @uri and (Time.now - @when) > @timeout
        begin
          @refreshing = true
          @when = Time.now
          @cookies.clear

          @crawler.cache.without_cache do
            @crawler.fetch(uri, post)
          end
        ensure
          @refreshing = false
        end
      end

      self
    end

    ################################################################################
    # Convert a relative URI to an absolute URI
    def absolute_uri (uri)
      return uri if @base_uris.empty?
      base = URI.parse(@base_uris.last)
      base.merge(uri).to_s
    end

  end
  ################################################################################
end
################################################################################
