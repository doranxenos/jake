require "rake"
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
  s.executables = %w( jake )
  s.require_path = "lib"
end

Rake::GemPackageTask.new(spec) do |package|
  package.gem_spec = spec
end

task :install => :package do
  sh %{#{sudo} gem install #{install_home} --local pkg/#{NAME}-#{VERSION}.gem --no-rdoc --no-ri}
end

desc "Builds the jake executable"
task :build do
  Dir::mkdir('bin') unless File::exists?('bin')
  
  Dir::foreach('src').each do |f|
    if f =~ /.*?\.rb$/
      
    end
  end
  
end
