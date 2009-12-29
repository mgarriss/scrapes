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
require 'net/http'
require 'pathname'
require 'scrapes/cache'
################################################################################
module Scrapes
  ################################################################################
  # Try to suck down a URI
  class Crawler
    ################################################################################
    # The cache object that this crawler is using
    attr_accessor :cache
    
    ################################################################################
    # The optional log object that this crawler is using
    attr_accessor :log

    ################################################################################
    # Create a new crawler for the given session
    def initialize (session)
      @session = session
      @log = nil
      @verbose = 0
      @delay = 0.5
      @cache = Cache.new
    end

    ################################################################################
    # Fetch a URI, using HTTP GET unless you supply <tt>post</tt>.
    def fetch (uri, post={}, headers={})
      @session.refresh
      uri = URI.parse(@session.absolute_uri(uri))

      post.empty? and cached = @cache.check(uri)
      @log.info((cached ? 'C ' : 'N ') + uri.to_s) if @log

      return cached if cached # FIXME
      sleep(@delay) if @delay != 0

      path = uri.path.dup
      path << "/" if path.empty?
      path << "?" + uri.query if uri.query

      req = post.empty? ? Net::HTTP::Get.new(path) : Net::HTTP::Post.new(path)
      req.set_form_data(post) unless post.empty?

      req['Cookie'] = @session.cookies.to_header
      headers.each {|k,v| req[k] = v}

      res = Net::HTTP.new(uri.host, uri.port).start {|http| http.request(req)}

      if @verbose >= 2
        STDERR.puts "-----------------------------------------------"
        STDERR.puts res.class
        res.each_header {|k,v| STDERR.puts "#{k}: #{v}"}
      end

      # FIXME, what to do about more than one cookie
      @session.cookies.from_header(res['set-cookie']) if res.key?('set-cookie')

      case res
      when Net::HTTPRedirection
        @session.base_uris[-1] = @session.absolute_uri(res['location'])
        res = fetch(res['location'], {}, headers)
      end

      post.empty? and @cache.update(uri, res.body)
      res
    end

  end
  ################################################################################
end
################################################################################
