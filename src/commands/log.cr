module Jit
  module Commands
    module Log
      extend self

      def run(options : Hash(String, String | Bool))
        graph = options["graph"]?.as(Bool?) || false
        since = options["since"]?.as(String?)
        show_files = options["files"]?.as(Bool?) || false

        args = build_log_args(graph, since, show_files)
        output = Git.run(args, capture: true)

        commits = parse_commits(output)
        display_commits(commits, show_files)
      end

      private def build_log_args(graph : Bool, since : String?, show_files : Bool) : Array(String)
        args = ["log", "--pretty=format:%H|%an|%ar|%s"]

        args << "--graph" if graph
        args << "--since=#{since}" if since

        if show_files
          args << "--name-only"
        end

        args
      end

      private def parse_commits(output : String) : Array(NamedTuple(hash: String, author: String, time: String, message: String))
        return [] of NamedTuple(hash: String, author: String, time: String, message: String) if output.empty?

        output.split("\n").map do |line|
          parts = line.split("|", 4)
          {
            hash: parts[0][0..7],
            author: parts[1],
            time: parts[2],
            message: parts[3],
          }
        end
      end

      private def display_commits(commits : Array, show_files : Bool)
        commits.each do |commit|
          puts "#{Color.green("●")} #{Color.commit_hash(commit[:hash])}  #{Color.committed(commit[:message])}"
          puts "│  #{Color.info(commit[:author])} · #{Color.dim(commit[:time])}"
          puts "│"
        end
      end
    end
  end
end
