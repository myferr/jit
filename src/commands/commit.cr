module Jit
  module Commands
    module Commit
      extend self

      def run(message : String?)
        if message.nil? || message.empty?
          return run_interactive
        end

        run_with_message(message)
      end

      private def run_interactive
        staged_files = Git.run(["diff", "--cached", "--name-only"], capture: true)
        if staged_files.empty?
          puts Color.error("No files staged. Stage files with 'jit add' first.")
          return 1
        end

        files = staged_files.split("\n")
        puts Color.header("Files to be committed:")
        files.each { |f| puts "  #{Color.staged_file(f)}" }
        puts

        temp_file = File.tempfile("jit-commit", ".txt") do |file|
          file.puts ""
        end

        editor = ENV["GIT_EDITOR"]? || ENV["EDITOR"]? || "vim"
        system("#{editor} #{temp_file.path}")

        message = File.read(temp_file.path).strip
        File.delete(temp_file.path)

        if message.empty?
          puts Color.warning("Aborting commit due to empty message")
          return 1
        end

        run_with_message(message)
      end

      private def run_with_message(message : String)
        staged_files = Git.run(["diff", "--cached", "--name-only"], capture: true)
        if staged_files.empty?
          puts Color.error("No files staged. Stage files with 'jit add' first.")
          return 1
        end

        puts Color.header("Files to be committed:")
        staged_files.split("\n").each { |f| puts "  #{Color.staged_file(f)}" }
        puts

        Git.run(["commit", "-m", message])
        puts Color.success("Committed successfully")
      end
    end
  end
end
