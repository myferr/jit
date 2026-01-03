module Jit
  module Commands
    module Status
      extend self

      def run
        branch_info = get_branch_info
        staged_files = get_staged_files
        unstaged_files = get_unstaged_files
        untracked_files = get_untracked_files

        puts branch_info
        puts

        unless staged_files.empty?
          puts Color.header("Staged (#{staged_files.size})")
          staged_files.each { |f| puts "  + #{Color.staged_file(f)}" }
          puts
        end

        unless unstaged_files.empty?
          puts Color.header("Unstaged (#{unstaged_files.size})")
          unstaged_files.each { |f| puts "  ~ #{Color.unstaged_file(f)}" }
          puts
        end

        unless untracked_files.empty?
          puts Color.header("Untracked (#{untracked_files.size})")
          untracked_files.each { |f| puts "  ? #{Color.untracked_file(f)}" }
          puts
        end

        if staged_files.empty? && unstaged_files.empty? && untracked_files.empty?
          puts Color.success("Working tree clean")
        end
      end

      private def get_branch_info : String
        branch = Git.run(["branch", "--show-current"], capture: true)
        upstream = Git.run(["rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}"], capture: true)
        ahead = Git.run(["rev-list", "--count", "@{u}..HEAD"], capture: true).to_i
        behind = Git.run(["rev-list", "--count", "HEAD..@{u}"], capture: true).to_i

        divergence = ""
        if ahead > 0 || behind > 0
          divergence = Color.yellow(" ↑#{ahead}") if ahead > 0
          divergence += Color.red(" ↓#{behind}") if behind > 0
        end

        "On branch #{Color.branch(branch)}#{divergence}"
      rescue
        "On branch #{Color.branch(branch || "HEAD")}"
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

      private def get_untracked_files : Array(String)
        output = Git.run(["ls-files", "--others", "--exclude-standard"], capture: true)
        output.empty? ? [] of String : output.split("\n")
      rescue
        [] of String
      end
    end
  end
end
