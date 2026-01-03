# jit

**jit** is a better command line interface for **git**. It provides prettier outputs, clearer messages, and improved ergonomics for common Git workflows.

Built with Crystal for fast, compiled CLI performance. jit covers the most common Git workflows with **clear output, safe defaults, and better ergonomics**. Any unsupported command is transparently forwarded to `git`.

## Features

- **Beautiful output** - Clean, readable, and color-coded command outputs
- **Improved transparency** - Shows commit details, diff summaries, and staging context
- **Better TUI** - Enhanced diff and stage commands with visual structure
- **Safe defaults** - Prevents common mistakes with built-in safety checks
- **Fast execution** - Compiled Crystal binary for instant startup
- **Git-compatible** - Seamlessly forwards unknown commands to git
- **Rich information** - Shows context like upstream divergence, commit counts, and more
- **Interactive workflows** - Smart branch switching and commit flows
- **Built-in manual** - Comprehensive documentation available via `jit man`

## Installation

### Prerequisites

- **Crystal** >= 1.18.2
- **Git** (any recent version)

## Guide

```bash
# Clone the repository
git clone https://github.com/myferr/jit.git
cd jit

# Build the binary
shards build

# Move to your PATH
sudo mv bin/jit /usr/local/bin/

# Verify installation
jit man
```

## Usage

### Overview

jit provides enhanced versions of common Git commands while maintaining full Git compatibility. Use `jit man` to see all available commands and options.

### Commands

#### `jit status`

Show the current working tree in a human-readable format.

```bash
jit status
```

**Output**

```
On branch main ↑1 ↓0

Staged (2)
  + src/parser.cr
  + README.md

Unstaged (1)
  ~ src/lexer.cr

Untracked (1)
  ? jit.lock
```

**Features:**

- Groups files by state (staged, unstaged, untracked)
- Shows upstream divergence (commits ahead/behind)
- No flags required for full information
- Clear visual indicators (`+`, `~`, `?`)

**Use cases:**

- Quick overview of repository state
- Understanding what changed since last commit
- Checking sync status with remote

---

#### `jit add`

Stage files with clear intent.

```bash
# Stage a single file
jit add file.txt

# Stage a directory
jit add src/

# Stage all tracked and untracked files
jit add .
```

**Behavior:**

- `.` stages both tracked + untracked files
- Shows a summary of what was staged
- Refuses ambiguous patterns unless explicit
- Warns when files don't exist

**Examples:**

```bash
jit add src/
Staged 3 file(s)

jit status
Staged (3)
  + src/parser.cr
  + src/lexer.cr
  + src/ast.cr
```

**Tips:**

- Use `jit add .` for quick staging of all changes
- Use `jit add <file>` for selective staging
- Always review staged files before committing

---

#### `jit commit`

Create a commit with sane defaults.

```bash
# Interactive commit (opens editor)
jit commit

# Commit with message
jit commit -m "feat: add fallback execution"

# Commit with multi-line message
jit commit -m "feat: add new feature

- Implemented X
- Added Y
- Fixed Z"
```

**Behavior:**

- Opens editor **only if no message is provided**
- Enforces non-empty commit messages
- Shows staged files before finalizing
- Uses your configured `$EDITOR` or `$GIT_EDITOR`

**Interactive Mode:**

```bash
jit commit
Files to be committed:
  + src/parser.cr
  + README.md

[editor opens with empty commit message]
```

**Best Practices:**

- Use conventional commits (`feat:`, `fix:`, `docs:`, etc.)
- Keep messages concise but descriptive
- Write in the imperative mood ("Add feature" not "Added feature")

---

#### `jit log`

Readable commit history with beautiful formatting.

```bash
# Basic log
jit log

# With graph
jit log --graph

# Since a specific time
jit log --since 3d
jit log --since 1week
jit log --since "2024-01-01"

# Show changed files
jit log --files
```

**Output**

```
● 8f2a1c3  feat: add fallback execution
│  user · 2 hours ago
│
● 91dbe42  fix: branch detection
│  user · yesterday
│
● a1b2c3d  docs: update README
│  user · 3 days ago
│
```

**Options:**

- `--graph` - Show commit graph visualization
- `--since=TIME` - Show commits since time (e.g., `3d`, `1week`, `2024-01-01`)
- `--files` - Show files changed in each commit

**Use cases:**

- Understanding project history
- Finding when changes were introduced
- Reviewing commit patterns

---

#### `jit diff`

Show changes with enhanced TUI and better UX than vanilla git.

```bash
# Show unstaged changes
jit diff

# Show staged changes
jit diff --staged

# Show specific file
jit diff src/parser.cr
```

**Output**

```
┌ Unstaged changes
│ 1 file(s) changed
│ +1 addition
│ -1 deletion
└

┌─ src/parser.cr
│
│ index 163eb75..07ca540 100644
│ --- a/src/parser.cr
│ +++ b/src/parser.cr
│ @@ -10,7 +10,7 @@ class Parser
│    def initialize
│      @tokens = [] of Token
│  -    @index = 0
│  +    @index = 1
│      @current_token = nil
│    end
└
```

**Features:**

- Box-drawing characters for visual structure
- Summary showing total files, additions, and deletions
- Each diff wrapped in its own box for clear separation
- Color-coded lines: green additions, red deletions, cyan hunk headers
- Support for file paths (e.g., `jit diff src/parser.cr`)
- Summary accurately reflects only requested files
- Better than vanilla git diff experience

---

#### `jit branch`

List and manage branches with context.

```bash
# List branches
jit branch

# Create new branch
jit branch new-feature

# Delete branch
jit branch -d old-feature

# Force delete branch
jit branch -D old-feature
```

**Output**

```
* main      8f2a1c3  feat: add fallback execution
  dev       91dbe42  fix: branch detection
  feature/  a1b2c3d  docs: update README
```

**Features:**

- Shows last commit per branch
- Indicates current branch with `*`
- Safety checks before deletion
- Cannot delete current branch

**Safety:**

- Destructive actions require confirmation
- Prevents deleting current branch
- Shows commit context before operations

---

#### `jit switch`

Switch branches without mental overhead.

```bash
# Interactive branch picker
jit switch

# Switch to specific branch
jit switch dev

# Create and switch to new branch
jit switch -c new-feature
```

**Interactive Mode:**

```bash
jit switch
Select a branch to switch to:
  1. * main
  2.   dev
  3.   feature/x

Enter branch number or name: 2
Switched to branch 'dev'
```

**Behavior:**

- No arguments → interactive branch picker
- Recently used branches shown first
- Shows current branch indicator
- Quick number-based selection

---

#### `jit pull`

Pull changes safely with preview.

```bash
# Safe pull (checks working tree)
jit pull

# Force pull (skip safety checks)
jit pull --force
```

**Behavior:**

- Infers remote and branch automatically
- Refuses to pull if working tree is dirty (unless forced)
- Shows what will change before applying
- Displays commit count being pulled

**Example:**

```bash
jit pull
Fetching changes...
Will pull 3 commit(s) from remote
Pull completed
```

**Safety:**

- Prevents accidental merges with dirty working tree
- Shows preview before applying changes
- Force flag available for advanced users

---

#### `jit push`

Push with context awareness and commit details.

```bash
# Normal push
jit push

# Force push (with warning)
jit push --force

# Explain what will be pushed
jit push --explain
```

**Explain Mode**

```bash
jit push --explain
This will push:
  branch: main
  remote: origin
  commits: 2
  force: false
```

**Push Output**

```bash
jit push
Commits to be pushed:

● 8f2a1c3  feat: add fallback execution
│  user · 2 hours ago
│

● 91dbe42  fix: branch detection
│  user · yesterday
│

Pushing 2 commit(s)

Push completed
```

**Behavior:**

- Infers upstream if missing
- Shows commit details (hash, author, time, message) before pushing
- Displays commit count before pushing
- Warns on force pushes
- Requires confirmation for force pushes
- Provides full transparency about what will be pushed

**Safety:**

- Force push requires explicit confirmation
- Shows what will happen before execution
- Prevents accidental history rewrites
- Shows all commit details before pushing

---

#### `jit stash`

Temporarily store changes with context.

```bash
# Create stash
jit stash

# Pop and apply stash
jit stash pop

# List stashes
jit stash list
```

**Output**

```
jit stash
Stashing changes:
 M src/parser.cr
 M README.md
Changes stashed

jit stash list
stash@{0}: WIP: 2024-01-15 14:30
stash@{1}: WIP: 2024-01-14 09:15
```

**Features:**

- Shows what's being stashed
- Names stashes automatically with context
- Lists all stashes with timestamps
- Simple pop to restore changes

---

#### `jit stage`

Display staging status with TUI similar to log.

```bash
jit stage
```

**Output**

```
Stage Status

Modified files (unstaged):
  ~ src/parser.cr
  ~ src/lexer.cr

Staged files:
  + src/ast.cr
  + README.md

Untracked files:
  ? jit.lock
```

**Features:**

- Shows modified (unstaged) files
- Shows staged files ready to commit
- Shows untracked files
- Clean, organized display with proper color coding
- Similar UX to log command

**Use cases:**

- Quick overview of what's staged vs unstaged
- Understanding repository state before committing
- Checking which files are tracked vs untracked

#### `jit man`

Display the built-in manual.

```bash
# Show manual in terminal
jit man

# Open manual in editor
jit man --editor=nvim
jit man --editor=code
jit man --editor=hx
```

**Supported editors:**

- `nvim` / `vim` - Vim-based editors
- `hx` - Helix
- `code` - VS Code
- `zed` - Zed
- `nano` - Nano
- Any editor in your `$PATH`

---

### Passthrough Commands

Any command not implemented by `jit` is forwarded directly to `git`.

```bash
# Rebase interactively
jit rebase -i HEAD~3

# Start bisect
jit bisect start

# Cherry-pick
jit cherry-pick abc123

# Tag
jit tag v1.0.0
```

**Guarantees:**

- All arguments preserved
- Exit codes preserved
- stdout/stderr preserved
- No modifications to git behavior

---

## Design Philosophy

### Design Guarantees

1. **No hidden state** - jit doesn't modify or hide git state
2. **No Git feature removal** - All git features remain accessible
3. **No command blocking** - Any git command works through passthrough
4. **No output surprises** - Clear, predictable output always

### Key Principles

- **Safety first** - Destructive operations require confirmation
- **Clarity over brevity** - Show context, not just results
- **Git compatibility** - Never break existing workflows
- **Performance** - Instant startup and execution
- **User-friendly** - Clear error messages and helpful output

---

## Development

### Setting up the Development Environment

```bash
# Clone the repository
git clone https://github.com/myferr/jit.git
cd jit

# Install dependencies (if any)
shards install

# Run tests
crystal spec

# Build for development
crystal build src/jit.cr -o jit

# Build for production (optimized)
crystal build --release src/jit.cr -o jit
```

### Project Structure

```
jit/
├── src/
│   ├── jit.cr              # Main entry point and CLI parser
│   ├── git.cr              # Git command execution utilities
│   ├── manual.cr           # Manual/help text
│   └── commands/           # Command implementations
├── spec/
│   ├── jit_spec.cr         # Main test file
│   └── spec_helper.cr      # Test configuration
├── shard.yml               # Dependencies and metadata
└── README.md               # This file
```

### Testing

```bash
# Run all tests
crystal spec

# Run specific test file
crystal spec spec/jit_spec.cr

# Run with coverage
crystal spec --error-trace
```

### Building

```bash
# Development build (fast compilation)
crystal build src/jit.cr -o jit

# Production build (optimized)
crystal build --release src/jit.cr -o jit

# Static binary (Linux)
crystal build --static --release src/jit.cr -o jit
```

### Adding New Commands

1. Create a new file in `src/commands/` (e.g., `new_command.cr`)
2. Implement the command module following the existing pattern:

   ```crystal
   module Jit
     module Commands
       module NewCommand
         extend self

         def run(args : Array(String))
           # Implementation
         end
       end
     end
   end
   ```

3. Add the command to the dispatcher in `src/jit.cr`
4. Add tests to `spec/jit_spec.cr`
5. Update the manual in `src/manual.cr`

### Code Style

- Use Crystal's standard style guide
- Follow existing code patterns
- Keep methods focused and small
- Add type annotations for clarity
- Document public methods

---

## Contributing

Contributions are welcome! Here's how to get started:

1. **Fork the repository**

   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/myferr/jit.git
   cd jit
   ```

2. **Create a feature branch**

   ```bash
   git checkout -b my-new-feature
   ```

3. **Make your changes**
   - Add functionality
   - Write/update tests
   - Update documentation
   - Follow code style guidelines

4. **Test your changes**

   ```bash
   # Run tests
   crystal spec

   # Build and test manually
   crystal build src/jit.cr -o jit
   ./jit <your-command>
   ```

5. **Commit your changes**

   ```bash
   git commit -m "feat: add new feature"
   ```

6. **Push to your branch**

   ```bash
   git push origin my-new-feature
   ```

7. **Create a Pull Request**
   - Go to the original repository on GitHub
   - Click "Pull Requests"
   - Click "New Pull Request"
   - Provide a clear description of your changes

### Contribution Guidelines

- **Conventional commits** - Use clear commit messages (`feat:`, `fix:`, `docs:`, etc.)
- **Tests** - Add tests for new functionality
- **Documentation** - Update the manual and README for new features
- **Backwards compatibility** - Don't break existing workflows
- **Crystal style** - Follow Crystal community coding standards

---

## License

MIT License - see [LICENSE](LICENSE) file for details.

---

## Support

- **Documentation**: Use `jit man` for built-in help
- **Issues**: Report bugs at https://github.com/myferr/jit/issues

---

## Acknowledgments

Built with:

- [Crystal](https://crystal-lang.org/) - The Crystal Programming Language
- [Git](https://git-scm.com/) - Version control system
- The open source community
