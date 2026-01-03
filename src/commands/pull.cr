module Jit
  module Commands
    module Pull
      extend self

      def run(force : Bool)
        unless force
          dirty = working_tree_dirty?
          if dirty
            puts Color.error("Error: Working tree has uncommitted changes")
            puts Color.dim("Commit or stash your changes before pulling, or use --force")
            return 1
          end
        end

        show_preview unless force

        Git.run(["pull"])
        puts Color.success("Pull completed")
      end

      private def working_tree_dirty? : Bool
        status = Git.run(["status", "--porcelain"], capture: true)
        !status.empty?
      end

      private def show_preview
        puts Color.info("Fetching changes...")
        Git.run(["fetch"])

        ahead = Git.run(["rev-list", "--count", "@{u}..HEAD"], capture: true).to_i
        behind = Git.run(["rev-list", "--count", "HEAD..@{u}"], capture: true).to_i

        if behind > 0
          puts Color.info("Will pull #{behind} commit(s) from remote")
        end
      rescue
      end
    end
  end
end
