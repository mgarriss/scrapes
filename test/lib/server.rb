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
# TODO figure out how to suppress get output
################################################################################
require 'logger'
require 'webrick'
require 'net/http'
################################################################################
# webrick localhost http server
module LocalHTTPServer
  ################################################################################
  # start the server and return it
  def start_server
    @server = WEBrick::HTTPServer.new :Port=>4270, :Logger=>Logger.new(nil),
      :DocumentRoot=>File.expand_path('test/public'), :AccessLog=>[]
    @server_thread = Thread.new { @server.start }
  end

  ################################################################################
  # wait for server to shutdown and return it
  def stop_server
    if @server
      @server.shutdown
      @server_thread.join
      @server
    end
  end

  ################################################################################
  # return a localhost url given a doc path
  def localhost_url path = nil
    "http://localhost:4270/#{path}"
  end

  ################################################################################
  # get a page from the localhost http server
  def localhost_http_get path = nil
    Net::HTTP.get(URI.parse(localhost_url(path)))
  end
end
################################################################################
