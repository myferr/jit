module Jit
  module Git
    extend self

    def run(args : Array(String), capture : Bool = false) : String
      cmd = ["git"] + args
      if capture
        output = IO::Memory.new
        error = IO::Memory.new
        status = Process.run("git", args, output: output, error: error)
        unless status.success?
          raise GitError.new(error.to_s.strip)
        end
        output.to_s.strip
      else
        status = Process.run("git", args)
        raise GitError.new("Git command failed") unless status.success?
        ""
      end
    end

    def run_with_exit(args : Array(String)) : {Int32, String, String}
      cmd = ["git"] + args
      output = IO::Memory.new
      error = IO::Memory.new
      status = Process.run("git", args, output: output, error: error)
      {status.exit_code, output.to_s.strip, error.to_s.strip}
    end

    class GitError < Exception
    end
  end
end
