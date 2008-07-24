require "rake"
require "rake/clean"
require "rake/gempackagetask"

NAME = 'jake'
VERSION = "0.0.1"

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.version = VERSION
  s.platform = Gem::Platform::RUBY
  s.author = "Ben Rose"
  s.author = "doranxenos@gmail.com"
  s.summary = "Simple build tool for JavaScript projects"
  s.bindir = "bin"
  s.description = s.summary
  s.executables = [ "jake" ]
  s.default_executable = "jake"
  s.require_path = "lib"
  s.files = ["lib/jake/JSMinifier.rb", "lib/jake/HTMLScriptParser.rb", "lib/Jake.rb", "bin/jake"]
end

CLEAN.include [ "pkg", "*.gem" ]

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

desc "Build gem and install it"
task :install => :package do
  sh %{gem install -w --local pkg/#{NAME}-#{VERSION}.gem --no-rdoc --no-ri}
end

desc "Completely remove gem and clobber"
task :uninstall => [:clobber_package, :clobber] do
  sh %{gem uninstall #{NAME}}
end
