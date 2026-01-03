require "colorize"

module Jit
  module Color
    extend self

    def green(text : String) : String
      text.colorize(:green).to_s
    end

    def red(text : String) : String
      text.colorize(:red).to_s
    end

    def yellow(text : String) : String
      text.colorize(:yellow).to_s
    end

    def blue(text : String) : String
      text.colorize(:blue).to_s
    end

    def magenta(text : String) : String
      text.colorize(:magenta).to_s
    end

    def cyan(text : String) : String
      text.colorize(:cyan).to_s
    end

    def bold(text : String) : String
      text.colorize(:bold).to_s
    end

    def dim(text : String) : String
      text.colorize(:dark_gray).to_s
    end

    def branch(text : String) : String
      green(text)
    end

    def commit_hash(text : String) : String
      text.colorize(:light_cyan).to_s
    end

    def committed(text : String) : String
      text.colorize(:green).mode(:bold).to_s
    end

    def tracked(text : String) : String
      green(text)
    end

    def modified(text : String) : String
      yellow(text)
    end

    def staged_file(text : String) : String
      green(text)
    end

    def unstaged_file(text : String) : String
      yellow(text)
    end

    def untracked_file(text : String) : String
      red(text)
    end

    def error(text : String) : String
      red(text)
    end

    def success(text : String) : String
      text.colorize(:green).mode(:bold).to_s
    end

    def warning(text : String) : String
      yellow(text)
    end

    def info(text : String) : String
      cyan(text)
    end

    def header(text : String) : String
      cyan(text)
    end

    def section_header(text : String) : String
      text.colorize(:light_cyan).to_s
    end

    def diff_add(text : String) : String
      text.colorize(:green).to_s
    end

    def diff_remove(text : String) : String
      text.colorize(:red).to_s
    end

    def diff_header(text : String) : String
      text.colorize(:light_cyan).to_s
    end
  end
end
