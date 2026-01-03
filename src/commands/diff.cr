module Jit
  module Commands
    module Diff
      extend self

      def run(staged : Bool)
        args = ["diff"]

        if staged
          args << "--cached"
        end

        args << "--color=always"

        output = Git.run(args, capture: true)
        if output.empty?
          puts "No changes to show"
        else
          puts output
        end
      end
    end
  end
end
