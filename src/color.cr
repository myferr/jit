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
      text.colorize(:green).mode(:bold).to_s
    end

    def commit_hash(text : String) : String
      text.colorize(:yellow).to_s
    end

    def staged_file(text : String) : String
      text.colorize(:green).to_s
    end

    def unstaged_file(text : String) : String
      text.colorize(:yellow).to_s
    end

    def untracked_file(text : String) : String
      text.colorize(:red).to_s
    end

    def error(text : String) : String
      text.colorize(:red).mode(:bold).to_s
    end

    def success(text : String) : String
      text.colorize(:green).mode(:bold).to_s
    end

    def warning(text : String) : String
      text.colorize(:yellow).to_s
    end

    def info(text : String) : String
      text.colorize(:blue).to_s
    end

    def header(text : String) : String
      text.colorize(:cyan).mode(:bold).to_s
    end
  end
end
