module Jit
  module Commands
    module Push
      extend self

      def run(options : Hash(String, String | Bool))
        force = options["force"]?.as(Bool?) || false
        explain = options["explain"]?.as(Bool?) || false

        if explain
          return show_explanation(force)
        end

        if force
          warn_force_push
        end

        count = get_commit_count
        if count > 0
          puts Color.info("Pushing #{count} commit(s)")
        end

        args = ["push"]
        args << "--force" if force

        Git.run(args)
        puts Color.success("Push completed")
      end

      private def show_explanation(force : Bool)
        current = Git.run(["branch", "--show-current"], capture: true)
        ahead = Git.run(["rev-list", "--count", "@{u}..HEAD"], capture: true).to_i

        remote = get_remote
        puts Color.header("This will push:")
        puts "  branch: #{Color.branch(current)}"
        puts "  remote: #{Color.dim(remote)}"
        puts "  commits: #{Color.yellow(ahead.to_s)}"
        puts "  force: #{force ? Color.red("true") : Color.dim("false")}"
      end

      private def warn_force_push
        puts Color.warning("Warning: Force pushing will rewrite remote history")
        print "Continue? (y/N): "
        input = gets.not_nil!.strip.downcase
        unless input == "y"
          puts Color.warning("Aborted")
          exit 0
        end
      end

      private def get_commit_count : Int32
        Git.run(["rev-list", "--count", "@{u}..HEAD"], capture: true).to_i
      rescue
        0
      end

      private def get_remote : String
        Git.run(["remote", "show"], capture: true).split("\n").first || "origin"
      end
    end
  end
end
