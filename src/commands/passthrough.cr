module Jit
  module Commands
    module Passthrough
      extend self

      def run(command : String, args : Array(String), options : Hash(String, String | Bool))
        full_args = [command] + args

        options.each do |key, value|
          if value == true
            full_args << "--#{key}"
          elsif value.is_a?(String)
            full_args << "--#{key}=#{value}"
          end
        end

        exit_code, output, error = Git.run_with_exit(full_args)

        unless output.empty?
          puts output
        end

        unless error.empty?
          STDERR.puts error
        end

        exit_code
      end
    end
  end
end
