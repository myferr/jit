module Jit
  module Commands
    module Stage
      extend self

      def run
        staged_files = get_staged_files
        unstaged_files = get_unstaged_files
        modified_files = get_modified_files
        untracked_files = get_untracked_files

        show_section_header

        unless modified_files.empty?
          show_modified_files(modified_files)
          puts
        end

        unless staged_files.empty?
          show_staged_files(staged_files)
          puts
        end

        unless untracked_files.empty?
          show_untracked_files(untracked_files)
          puts
        end

        if staged_files.empty? && modified_files.empty? && untracked_files.empty?
          puts Color.success("Working tree clean")
        end
      end

      private def show_section_header
        puts Color.section_header("Stage Status")
        puts
      end

      private def show_modified_files(files : Array(String))
        puts Color.yellow("Modified files (unstaged):")
        files.each do |file|
          puts "  ~ #{Color.modified(file)}"
        end
      end

      private def show_staged_files(files : Array(String))
        puts Color.green("Staged files:")
        files.each do |file|
          puts "  + #{Color.staged_file(file)}"
        end
      end

      private def show_untracked_files(files : Array(String))
        puts Color.magenta("Untracked files:")
        files.each do |file|
          puts "  ? #{Color.untracked_file(file)}"
        end
      end

      private def get_staged_files : Array(String)
        output = Git.run(["diff", "--cached", "--name-only"], capture: true)
        output.empty? ? [] of String : output.split("\n")
      rescue
        [] of String
      end

      private def get_unstaged_files : Array(String)
        output = Git.run(["diff", "--name-only"], capture: true)
        output.empty? ? [] of String : output.split("\n")
      rescue
        [] of String
      end

      private def get_modified_files : Array(String)
        get_unstaged_files
      end

      private def get_untracked_files : Array(String)
        output = Git.run(["ls-files", "--others", "--exclude-standard"], capture: true)
        output.empty? ? [] of String : output.split("\n")
      rescue
        [] of String
      end
    end
  end
end
