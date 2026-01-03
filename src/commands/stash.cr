module Jit
  module Commands
    module Stash
      extend self

      def run(args : Array(String))
        if args.empty?
          create_stash
        elsif args[0] == "pop"
          pop_stash
        elsif args[0] == "list"
          list_stashes
        else
          puts Color.error("Error: Unknown stash command")
          return 1
        end
      end

      private def create_stash
        dirty = working_tree_dirty?
        unless dirty
          puts Color.info("No changes to stash")
          return
        end

        changes = Git.run(["status", "--short"], capture: true)
        puts Color.header("Stashing changes:")
        puts changes

        Git.run(["stash", "push", "-m", "WIP: #{Time.local.to_s("%Y-%m-%d %H:%M")}"])
        puts Color.success("Changes stashed")
      end

      private def pop_stash
        stashes = Git.run(["stash", "list"], capture: true)
        if stashes.empty?
          puts Color.warning("No stashes to pop")
          return
        end

        Git.run(["stash", "pop"])
        puts Color.success("Stash popped")
      end

      private def list_stashes
        stashes = Git.run(["stash", "list"], capture: true)
        if stashes.empty?
          puts Color.info("No stashes")
        else
          puts stashes
        end
      end

      private def working_tree_dirty? : Bool
        status = Git.run(["status", "--porcelain"], capture: true)
        !status.empty?
      end
    end
  end
end
