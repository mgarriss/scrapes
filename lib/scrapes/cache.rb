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
require 'ostruct'
require 'digest/md5'
################################################################################
module Scrapes
  ################################################################################
  # Cache web pages
  class Cache
    ################################################################################
    # Enable/disable caching
    attr_accessor :enabled

    ################################################################################
    # Set the directory to use for caching
    attr_accessor :directory

    ################################################################################
    # Set to a proc that given an URI, translates it to a file system name
    # default is to MD5 the URL
    attr_accessor :uri_translator

    ################################################################################
    def initialize
      @directory = File.expand_path('cache')
      @enabled = false
      @uri_translator = nil
    end

    ################################################################################
    # Disables caching while the given block is active.
    def without_cache
      state = @enabled
      @enabled = false
      yield if block_given?
      @enabled = state
    end

    ################################################################################
    # Checks the cache to see if there is a match for the given URI
    def check (uri)
      return nil unless @enabled

      # FIXME check some time limits around this
      cache_name = translate_uri(uri)
      
      file = File.join(@directory, cache_name)
      File.exist?(file) and File.open(file) do |f|
        return OpenStruct.new(:body => f.read, :cache_file => file)
      end
    end

    ################################################################################
    # Updates the cache by placing the data for the give URI on the file system.
    def update (uri, data)
      return nil unless @enabled

      cache_name = translate_uri(uri)
      mkdir # FIXME include cache_name to build all necessary directories 

      File.open(File.join(@directory, cache_name), 'w') do |f|
        f << data
      end
    end

    ################################################################################
    # helper method to translate a URL to a MD5
    def uri_to_md5 (uri)
      Digest::MD5.hexdigest(uri.to_s)
    end

    ################################################################################
    private

    ################################################################################
    def mkdir
      Dir.mkdir(@directory) unless File.exist?(@directory)
    end
    
    ################################################################################
    def translate_uri (uri)
      @uri_translator ? @uri_translator.call(uri) : uri_to_md5(uri)
    end

  end
  ################################################################################
end
################################################################################
