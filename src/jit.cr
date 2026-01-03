require "option_parser"

module Jit
  VERSION = "0.1.0"

  class Command
    property name : String
    property args : Array(String)
    property options : Hash(String, String | Bool)

    def initialize(@name, @args = [] of String, @options = Hash(String, String | Bool).new)
    end
  end

  class CLI
    def initialize
      @command = nil.as(Command?)
      @editor = nil.as(String?)
      @show_manual = false
    end

    def run(args = ARGV)
      parse_args(args)

      if @show_manual || @command.nil?
        show_manual
        return 0
      end

      cmd = @command.not_nil!
      execute_command(cmd)
    end

    private def parse_args(args)
      return if args.empty?

      command_name = args[0]?

      if command_name.nil? || command_name == "man"
        @show_manual = true
        parse_manual_flags(args[1..])
        return
      end

      remaining_args = args[1..] || [] of String
      options = Hash(String, String | Bool).new

      OptionParser.parse(remaining_args) do |parser|
        parser.on("--editor=EDITOR", "Open manual in specified editor") do |editor|
          @editor = editor
        end
        parser.on("-m MESSAGE", "Commit message") do |message|
          options["message"] = message
        end
        parser.on("--staged", "Show staged changes") do
          options["staged"] = true
        end
        parser.on("--graph", "Show graph") do
          options["graph"] = true
        end
        parser.on("--since=TIME", "Show commits since time") do |time|
          options["since"] = time
        end
        parser.on("--files", "Show files") do
          options["files"] = true
        end
        parser.on("-d", "Delete branch") do
          options["delete"] = true
        end
        parser.on("-D", "Force delete branch") do
          options["force_delete"] = true
        end
        parser.on("--force", "Force operation") do
          options["force"] = true
        end
        parser.on("--explain", "Explain operation") do
          options["explain"] = true
        end
        parser.on("-h", "--help", "Show help") do
          @show_manual = true
        end
        parser.unknown_args do |unknown_args|
          @command = Command.new(command_name, unknown_args, options)
        end
      end

      @command ||= Command.new(command_name, remaining_args, options)
    end

    private def parse_manual_flags(args)
      return if args.empty?

      OptionParser.parse(args) do |parser|
        parser.on("--editor=EDITOR", "Open manual in specified editor") do |editor|
          @editor = editor
        end
      end
    end

    private def execute_command(command : Command)
      case command.name
      when "status"
        Commands::Status.run
      when "add"
        Commands::Add.run(command.args)
      when "commit"
        Commands::Commit.run(command.options["message"]?.as(String?))
      when "log"
        Commands::Log.run(command.options)
      when "diff"
        Commands::Diff.run(command.options["staged"]?.as(Bool?) || false)
      when "branch"
        Commands::Branch.run(command.args, command.options)
      when "switch"
        Commands::Switch.run(command.args)
      when "pull"
        Commands::Pull.run(command.options["force"]?.as(Bool?) || false)
      when "push"
        Commands::Push.run(command.options)
      when "stash"
        Commands::Stash.run(command.args)
      else
        Commands::Passthrough.run(command.name, command.args, command.options)
      end
    rescue e : Exception
      STDERR.puts Color.error("Error: #{e.message}")
      return 1
    end

    private def show_manual
      manual = Manual.text
      editor = @editor

      if editor
        temp_file = File.tempfile("jit-manual", ".txt") do |file|
          file.puts manual
        end
        system("#{editor} #{temp_file.path}")
        File.delete(temp_file.path)
      else
        puts manual
      end
    end
  end
end

require "./commands/**"
require "./git"
require "./manual"
require "./color"

module Jit
  extend self

  def run
    CLI.new.run
  end
end

Jit.run if PROGRAM_NAME.includes?("jit")
