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
  module RE
    EMAIL = /[a-zA-Z]([.]?([[:alnum:]_-]+)*)?@([[:alnum:]\-_]+\.)+[a-zA-Z]{2,4}/
    US_PHONE_NUMBER = /\(?\d{3}[-) ]\s{0,3}\d{3}[- ]\d{4}/
  end
  ################################################################################
  def self.normalize_name names
    require 'unicode'
    result = names.map do |part|
      result = ""
      Unicode.normalize_D(part).each_byte{|byte| (result << byte) if byte < 128}
      result = result.strip.chomp('.')
      result.upcase! if result =~ /^(jr|sr|ii+|iv|vi*)$/i
      result = nil if result =~ /^Rev|Ph\.D$/i
      result
    end.compact
    if result[-2] =~ /,$/
      extra = result.pop
      result.unshift result.pop
      result << extra
      result.join(' ')
    else                                                                                  
      result.unshift(result.pop + ',').join(' ')
    end
  end
  ################################################################################
end
################################################################################
