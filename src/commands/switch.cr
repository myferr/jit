module Jit
  module Commands
    module Switch
      extend self

      def run(args : Array(String))
        if args.empty?
          interactive_switch
        else
          branch_name = args[0]
          switch_to_branch(branch_name)
        end
      end

      private def interactive_switch
        branches = Git.run(["branch", "--format=%(refname:short)"], capture: true)
        branch_list = branches.split("\n").reject(&.empty?)

        current = Git.run(["branch", "--show-current"], capture: true)

        puts Color.header("Select a branch to switch to:")
        branch_list.each_with_index do |branch, idx|
          prefix = branch == current ? Color.green("* ") : "  "
          branch_name = branch == current ? Color.branch(branch) : branch
          puts "  #{Color.dim("#{idx + 1}.")} #{prefix}#{branch_name}"
        end

        print "\nEnter branch number or name: "
        input = gets.not_nil!.strip

        if input =~ /^\d+$/
          idx = input.to_i - 1
          if idx >= 0 && idx < branch_list.size
            switch_to_branch(branch_list[idx])
          else
            puts Color.error("Invalid selection")
            return 1
          end
        else
          switch_to_branch(input)
        end
      end

      private def switch_to_branch(branch_name : String)
        Git.run(["checkout", branch_name])
        puts Color.success("Switched to branch '#{branch_name}'")
      end
    end
  end
end
