
class JSMinifier
  attr_reader :minified

  InlineCommentRegExp = /\/\/.*\n/
  BlockCommentRegExp = /\/\*.*?\*\//m
  SpaceRegExp = /\s{2,}/
  NewLineRegExp = /\n/
  BeginEndSpace = /(^\s|\s$)/

  @jsFile
  @minified
  @strip_newlines

  def initialize(jsFile)
    if jsFile.nil? or !jsFile.is_a? File then
      raise "Invalid file passed to JSMinifier"
    end

    @jsFile = jsFile
  end

  def minify(strip_newlines = false)
    @strip_newlines = strip_newlines

    @minified = @jsFile.read.
      gsub(InlineCommentRegExp, "").
      gsub(BlockCommentRegExp, "").
      gsub(SpaceRegExp, " ")

    if @strip_newlines
      @minified.gsub!(NewLineRegExp, "")
    end

    @minified.gsub!(BeginEndSpace, "")

    return @minified
  end

  def minified(strip_newlines = false)
    minify(strip_newlines) unless @minified
    @minified
  end

  def toFile(fileName)
    minify unless @minified
    File::new(fileName, APPEND)
  end

end
