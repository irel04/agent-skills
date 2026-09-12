---  
name: create-summary
description: Generates comprehensive summaries of repository changes by running tests, analyzing git diffs, and formatting output according to project templates or industry standards. Use when preparing pull requests, documenting work, or creating change logs.
---

# Change Summary Workflow

This skill automates the process of documenting code changes in a structured, team-friendly format.

## Execution Steps

### 1. **Pre-flight Check**
- Verify we're in a git repository
- Run `scripts/get-branch.sh` to identify current branch name
- **Ask user:** "Which branch would you like to compare against?"
  - If user doesn't specify, detect and suggest: `development`, `develop`, `main`, or `master`
  - Verify the selected branch exists with `git rev-parse --verify origin/<branch>`

### 2. **Test Execution**
- Check for common test commands in order of priority:
  1. `npm test` (if package.json exists)
  2. `pytest` or `python -m pytest` (if Python project)
  3. `cargo test` (if Rust project)
  4. `go test ./...` (if Go project)
  5. Custom test script from package.json or Makefile
- **If tests fail:**
  - Report which test(s) failed
  - Show error output
  - Ask user if they want to continue summarizing or fix tests first
  - Suggest: "Should I continue with the summary, or would you like to address failing tests first?"

### 3. **Git Diff Analysis**
Run `scripts/get-diff.sh <base-branch>` which executes:
- `git fetch origin`
- `git diff origin/<base-branch>...HEAD --stat`
- `git diff origin/<base-branch>...HEAD`
- `git diff --staged` (staged but uncommitted)
- `git diff` (unstaged changes)

Output: Combined diff for analysis

- If **no changes detected**:
  - Stop execution
  - Report: "No changes found between current branch and `<base-branch>`. The branches are in sync."
  - Suggest: "Did you mean to compare against a different branch?"

### 4. **Change Categorization**
Automatically categorize changes by analyzing the diff:
- **Files modified** (group by type: source code, tests, config, docs)
- **Lines added/removed** (summary statistics)
- **Key changes** (new functions/classes, deleted code, refactored sections)
- **Dependencies** (package.json, requirements.txt, Cargo.toml changes)
- **Configuration** (env files, config files, CI/CD changes)

### 5. **Template Detection & Formatting**

**Priority order (use first match found):**
1. `.github/PULL_REQUEST_TEMPLATE.md` (GitHub repo-specific)
2. `.gitlab/merge_request_templates/Default.md` (GitLab repo-specific)
3. `CONTRIBUTING.md` (check for PR format guidelines)
4. Skill fallback: `templates/default.md`

**If repo template found:**
- Parse the template structure
- Fill in sections based on git diff analysis
- Preserve all original sections and checkboxes

**If no repo template exists:**
- Use the fallback template at [`templates/default.md`](templates/default.md)
- Fill in sections based on git diff analysis
- Auto-populate change statistics, modified components, and test results

### 6. **Output**

- Display the formatted summary in the terminal
- Inform user: "Use `/copy` to copy this summary to your clipboard, or I can save it to a file if needed."

**Optional:** If user requests, save to:
- `CHANGES.md` - For general change documentation
- `PR_DESCRIPTION.md` - For pull request descriptions
- Extended git commit message format


## Error Handling

- **Not a git repo:** "This directory is not a git repository. Run `git init` first or navigate to your project root."
- **No commits:** "No commits found. Make your initial commit first."
- **Detached HEAD:** "Currently in detached HEAD state. Check out a branch first."
- **Uncommitted changes warning:** "You have uncommitted changes. Should I include them in the summary?"
- **Large diffs:** If diff > 1000 lines, warn: "Large changeset detected (XXX lines). This may take a moment to analyze..."

---

## Configuration Options

Allow user to set preferences (stored in `.claude/config.json` or similar):
```json
{
  "defaultBaseBranch": "development",
  "autoLinkIssues": true,
  "includeTestResults": true,
  "diffMaxLines": 5000,
  "templatePath": ".github/PULL_REQUEST_TEMPLATE.md",
  "excludePaths": ["node_modules/", "dist/", "build/"]
}
```

---

## Example Usage

```bash
# Basic usage - displays summary in terminal
"Create a summary of my changes"

# After summary is displayed, copy it
"/copy"

# Specify base branch
"Summarize changes compared to main branch"

# Skip tests (faster)
"Quick summary without running tests"

# Save summary to file
"Save the summary to PR_DESCRIPTION.md"

# Include only specific files
"Summarize changes to src/ directory"
```

---

## Tips for Best Results

1. Commit your changes before running (so git diff is clean)
2. Ensure tests are passing for accurate test results
3. Write meaningful commit messages (they help with auto-summarization)
4. Keep branches focused on single features/fixes
5. Update the template in your repo if the default doesn't fit