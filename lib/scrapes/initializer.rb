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
module Scrapes
  ################################################################################
  # Initialize the Scrapes library
  class Initializer
    ################################################################################
    # The directory name where the pages classes are kept
    attr_accessor :pages_dir

    ################################################################################
    # The parent directory where the pages_dir can be found
    attr_accessor :pages_parent

    ################################################################################
    # Create a new Initializer and run it
    def self.run (&block)
      initializer = self.new
      yield initializer if block
      initializer
    end

    ################################################################################
    # Establish all the defaults
    def initialize
      @pages_dir = 'pages'
      @pages_parent = File.dirname($0)
    end

    ################################################################################
    # Run all the initilization methods
    def process
      load_pages
    end

    ################################################################################
    private

    ################################################################################
    # load all files in the pages directory
    def load_pages
      reloader(Dir.glob(@pages_parent + '/' + @pages_dir + '/*.rb').sort)
    end

    ################################################################################
    # try to keep loading files until all NameError issues are resolved
    def reloader (files, limit=4)
      reload = []

      files.each do |file|
        begin
          load File.expand_path(file)
        rescue NameError
          raise if limit <= 0
          reload << file
        end
      end

      reloader(reload, limit - 1) unless reload.empty?
    end

  end
end
################################################################################
