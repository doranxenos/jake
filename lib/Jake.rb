#!/usr/bin/env ruby

require 'jake/JSMinifier'
require 'jake/HTMLScriptParser'
require 'getoptlong'

class Jake

  @minify = nil
  @file_list = nil
  @html_file = nil
  @output = nil

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
                          ['--html-parse', '-h', GetoptLong::REQUIRED_ARGUMENT],
                          ['--minify', '-m', GetoptLong::NO_ARGUMENT],
                          ['--output', '-o', GetoptLong::REQUIRED_ARGUMENT]
                          )

    opt.each_option do |name, arg|
      case name
      when '--file-list'
        @file_list = true
      when '--html-parse'
        @html_file = arg
      when '--minify'
        @minify = true
      when '--output'
        @output = arg
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
          @built_str << JSMinifier::new(js_file).minified
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
