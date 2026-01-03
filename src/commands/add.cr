module Jit
  module Commands
    module Add
      extend self

      def run(args : Array(String))
        if args.empty?
          puts Color.error("Error: No files specified")
          puts Color.dim("Usage: jit add <file|directory|...>")
          return 1
        end

        args.each do |arg|
          if arg == "."
            add_all
            break
          else
            add_path(arg)
          end
        end

        show_summary
      end

      private def add_all
        Git.run(["add", "-A"])
      end

      private def add_path(path : String)
        unless File.exists?(path)
          STDERR.puts Color.warning("Warning: #{path} does not exist")
          return
        end

        Git.run(["add", path])
      end

      private def show_summary
        staged = Git.run(["diff", "--cached", "--name-only"], capture: true)
        if staged.empty?
          puts Color.info("No files staged")
        else
          count = staged.split("\n").size
          puts Color.success("Staged #{count} file(s)")
        end
      rescue
        puts Color.info("No files staged")
      end
    end
  end
end
