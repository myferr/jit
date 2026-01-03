module Jit
  module Commands
    module Branch
      extend self

      def run(args : Array(String), options : Hash(String, String | Bool))
        if args.empty?
          list_branches
        elsif args.size == 1
          branch_name = args[0]

          if options["delete"]?.as(Bool?) || options["force_delete"]?.as(Bool?)
            delete_branch(branch_name, options["force_delete"]?.as(Bool?) || false)
          else
            create_branch(branch_name)
          end
        else
          puts Color.error("Error: Too many arguments")
          return 1
        end
      end

      private def list_branches
        current = Git.run(["branch", "--show-current"], capture: true)
        branches = Git.run(["branch", "--format=%(refname:short)%(HEAD)%(objectname)"], capture: true)

        branches.split("\n").each do |line|
          parts = line.split("\x00")
          name = parts[0]
          is_head = parts[1] == "*"
          commit = parts[2][0..7]

          prefix = is_head ? Color.green("* ") : "  "
          branch_name = is_head ? Color.branch(name) : name
          puts "#{prefix}#{branch_name}  #{Color.dim(commit)}"
        end
      rescue
        Git.run(["branch"])
      end

      private def create_branch(name : String)
        Git.run(["branch", name])
        puts Color.success("Created branch '#{name}'")
      end

      private def delete_branch(name : String, force : Bool)
        current = Git.run(["branch", "--show-current"], capture: true)
        if name == current
          puts Color.error("Error: Cannot delete the current branch")
          return 1
        end

        flag = force ? "-D" : "-d"
        Git.run(["branch", flag, name])
        puts Color.success("Deleted branch '#{name}'")
      end
    end
  end
end
