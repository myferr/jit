module Jit
  module Commands
    module Diff
      extend self

      def run(staged : Bool, paths : Array(String) = [] of String)
        args = ["diff", "--color=never"]

        if staged
          args << "--cached"
        end

        args.concat(paths) unless paths.empty?

        output = Git.run(args, capture: true)
        if output.empty?
          puts Color.dim("No changes to show")
          return
        end

        parsed_diff = parse_diff(output)
        display_diff_summary(parsed_diff, staged)
        display_diff_content(parsed_diff)
      end

      private def parse_diff(output : String) : Array(NamedTuple(file: String, changes: String, additions: Int32, deletions: Int32))
        diffs = [] of NamedTuple(file: String, changes: String, additions: Int32, deletions: Int32)

        current_file = ""
        current_changes = [] of String
        additions = 0
        deletions = 0
        in_file = false

        output.each_line do |line|
          if line.starts_with?("diff --git")
            if in_file && !current_changes.empty?
              diffs << {file: current_file, changes: current_changes.join("\n"), additions: additions, deletions: deletions}
            end
            current_file = line.split(" b/").last? || ""
            current_changes = [] of String
            additions = 0
            deletions = 0
            in_file = true
          else
            current_changes << line
            if line.starts_with?("+") && !line.starts_with?("+++")
              additions += 1
            elsif line.starts_with?("-") && !line.starts_with?("---")
              deletions += 1
            end
          end
        end

        if in_file && !current_changes.empty?
          diffs << {file: current_file, changes: current_changes.join("\n"), additions: additions, deletions: deletions}
        end

        diffs
      end

      private def display_diff_summary(diffs : Array, staged : Bool)
        total_additions = diffs.sum(&.[:additions])
        total_deletions = diffs.sum(&.[:deletions])
        total_files = diffs.size

        puts "#{Color.cyan("┌")} #{Color.section_header(staged ? "Staged changes" : "Unstaged changes")}"
        puts "#{Color.cyan("│")} #{total_files} file(s) changed"
        puts "#{Color.cyan("│")} #{Color.diff_add("+#{total_additions}")} addition#{total_additions == 1 ? "" : "s"}"
        puts "#{Color.cyan("│")} #{Color.diff_remove("-#{total_deletions}")} deletion#{total_deletions == 1 ? "" : "s"}"
        puts "#{Color.cyan("└")}"
        puts
      end

      private def display_diff_content(diffs : Array)
        diffs.each_with_index do |diff, index|
          if index > 0
            puts
          end

          puts "#{Color.cyan("┌─")} #{Color.section_header(diff[:file])}"
          puts "#{Color.cyan("│")}"

          diff[:changes].each_line do |line|
            if line.starts_with?("+") && !line.starts_with?("+++")
              puts "#{Color.cyan("│")} #{Color.diff_add(line)}"
            elsif line.starts_with?("-") && !line.starts_with?("---")
              puts "#{Color.cyan("│")} #{Color.diff_remove(line)}"
            elsif line.starts_with?("@@")
              puts "#{Color.cyan("│")} #{Color.cyan(line)}"
            elsif line.starts_with?("diff --git") || line.starts_with?("index") || line.starts_with?("---") || line.starts_with?("+++")
              puts "#{Color.cyan("│")} #{Color.dim(line)}"
            else
              puts "#{Color.cyan("│")} #{line}"
            end
          end

          puts "#{Color.cyan("└")}"
        end
      end
    end
  end
end
