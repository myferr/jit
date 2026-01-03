module Jit
  module Manual
    extend self

    def text : String
      <<-MANUAL
      jit - A better command line interface for git

      USAGE:
        jit <command> [options]

      COMMANDS:
        status    Show the current working tree status
        add       Stage files for commit
        commit    Create a commit with sane defaults
        log       Show readable commit history
        diff      Show changes clearly
        branch    List and manage branches
        switch    Switch branches interactively
        pull      Pull changes safely
        push      Push with context awareness
        stash     Temporarily store changes
        man       Show this manual

      STATUS:
        jit status

        Shows files grouped by state (staged, unstaged, untracked) with
        upstream divergence indicators.

      ADD:
        jit add <file|directory|...>
        jit add .

        Stage files for commit. Shows summary of staged files.

      COMMIT:
        jit commit
        jit commit -m "message"

        Creates commit. Opens editor if no message provided.
        Shows staged files before committing.

      LOG:
        jit log [options]

        Options:
          --graph       Show commit graph
          --since=TIME  Show commits since time (e.g., 3d, 1week)
          --files       Show changed files

      DIFF:
        jit diff
        jit diff --staged

        Show changes clearly with minimal coloring.

      BRANCH:
        jit branch
        jit branch <name>
        jit branch -d <name>

        List branches, create new branch, or delete branch.

      SWITCH:
        jit switch
        jit switch <branch>

        Switch branches interactively or by name.

      PULL:
        jit pull
        jit pull --force

        Pull changes safely. Shows preview before pulling.
        Refuses to pull with dirty working tree (unless forced).

      PUSH:
        jit push
        jit push --force
        jit push --explain

        Push with context awareness. Shows commit count.
        Warns on force pushes.

      STASH:
        jit stash
        jit stash pop
        jit stash list

        Temporarily store changes. Shows what's being stashed.

      PASSTHROUGH:
        Any command not implemented is forwarded to git:
          jit rebase -i HEAD~3
          jit bisect start

      FLAGS:
        -h, --help     Show help for commands
        -m MESSAGE     Commit message
        --staged       Show staged changes (diff)
        --force        Force operation
        --explain      Explain operation (push)

      MANUAL:
        jit man
        jit man --editor=nvim

        Show manual in terminal or open in editor.

      EDITORS:
        Supported editors for manual: nvim, hx, code, zed, nano

      For more information, visit: https://github.com/myferr/jit
      MANUAL
    end
  end
end
