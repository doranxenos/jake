#!/usr/bin/env ruby

require 'jake/JSMinifier'
require 'jake/HTMLScriptParser'
require 'getoptlong'

class Jake

  @minify = nil
  @file_list = nil
  @html_file = nil
  @output = nil
  @remove_newlines = false

  def get_file_list
    l = []
    ARGV.reverse_each do |a|
      if a == '--file-list' || a == '-f'
        break
      end
      l.unshift(a)
    end
    
    return l
  end

  def run
    opt = GetoptLong::new(
                          ['--file-list', '-f', GetoptLong::NO_ARGUMENT],
                          ['--src-parse', '-s', GetoptLong::REQUIRED_ARGUMENT],
                          ['--minify', '-m', GetoptLong::NO_ARGUMENT],
                          ['--output', '-o', GetoptLong::REQUIRED_ARGUMENT],
                          ['--help', '-h', GetoptLong::NO_ARGUMENT],
                          ['--remove-newlines', '-r', GetoptLong::NO_ARGUMENT]
                          )

    opt.each_option do |name, arg|
      case name
      when '--file-list'
        @file_list = true
      when '--src-parse'
        @html_file = arg
      when '--minify'
        @minify = true
      when '--output'
        @output = arg
      when '--remove-newlines'
        @remove_newlines = true
      when '--help'
        print <<-EOF
Jake is a build utility for JavaScript projects. It supports merging
and minifying files by removing comments and extraneous lines and
spaces.

Supported Command Line options are:

       --file-list, -f       Merge all files passed as command line arguments

       --html-parse, -h      Merge all files referenced as 'src' attributes of
                             script tags within the passed html file

       --minify, -m          Remove extraneous lines, spaces, and comments

       --remove-newlines, -r Remove all newlines, THIS WILL BREAK SOME JAVASCRIPT CODE!!!

       --output, -o          Put resulting merged JavaScript into specified file

       --help, -h            Show this help info
EOF
      end
    end

    @file_list = get_file_list() unless !@file_list
    
    @js_files = []
    
    if @html_file && File::readable?(@html_file)
      dir = File::dirname(@html_file)
      
      HTMLScriptParser::new(File::open(@html_file)).scriptSrcs.each do |script|
        @js_files.push(dir + File::SEPARATOR + script)
      end
    end
    
    if @file_list
      @js_files.concat(@file_list)
    end
    
    @built_str = ""
    
    @js_files.each do |js_file|
      if File::readable?(js_file)
        print "Merging file: #{js_file}\n"
        
        js_file = File::open(js_file)
        
        if @minify
          @built_str << JSMinifier::new(js_file).minify(@remove_newlines)
        else
          @built_str << js_file.read << "\n"
        end
      else
        raise "File #{js_file} unreadable"
      end
    end
    
    if @output
      if File::exists?(@output)
        raise "Output file #{@output} already exists, unable to overwrite"
      else
        file = File::open(@output, 'w')
        file << @built_str
        file.close
      end
    else
      print @built_str, "\n"
    end
  end

end
