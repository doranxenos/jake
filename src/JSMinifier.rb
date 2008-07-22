
class JSMinifier
  attr_reader :minified

  InlineCommentRegExp = /\/\/.*\n/
  BlockCommentRegExp = /\/\*.*?\*\//m
  SpaceRegExp = /\s{2,}/
  NewLineRegExp = /\n/
  BeginEndSpace = /(^\s|\s$)/

  @jsFile
  @minified

  def initialize(jsFile)
    @jsFile = jsFile
  end

  def minify
    @minified = @jsFile.read.
      gsub(InlineCommentRegExp, "").
      gsub(BlockCommentRegExp, "").
      gsub(SpaceRegExp, " ").
      gsub(NewLineRegExp, "").
      gsub(BeginEndSpace, "")

    return @minified
  end

  def minified
    minify unless @minified
    @minified
  end

  def toFile(fileName)
    minify unless @minified
    File::new(fileName, APPEND)
  end

end
