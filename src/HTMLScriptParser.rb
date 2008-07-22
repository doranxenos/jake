
class HTMLScriptParser
  attr_reader :scriptSrcs

  ScriptRegExp = /\<script(.*?)\>(.*?)\<\/script\>/m
  Src = /src\=["|'](.*?)["|']/

  @htmlFile
  @scriptSrcs

  def initialize(htmlFile)
    @htmlFile = htmlFile
  end

  def parse
    @scriptSrcs = []
    @htmlFile.read.scan(ScriptRegExp) do |script|
      src = script[0].scan(Src)
      src = src.size > 0 ? src[0][0] : nil

      @scriptSrcs.push(src) unless src == nil
    end
  end

  def scriptSrcs
    parse() unless @scriptSrcs
    return @scriptSrcs
  end

end
