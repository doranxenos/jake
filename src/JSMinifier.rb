
class JSMinifier
  attr_reader :minified

  InlineCommentRegExp = /\/\/.*\n/
  BlockCommentRegExp = /\/\*.*?\*\//m
  SpaceRegExp = /\s/m

  @jsFile
  @minified

  def initialize(jsFile)
    @jsFile = jsFile
  end

  def minify
    @minified = @jsFile.read.
      gsub(InlineCommentRegExp, "").
      gsub(BlockCommentRegExp, "").
      gsub(SpaceRegExp, " ")

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
