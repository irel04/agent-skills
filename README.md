# Claude Code Skills Collection

A comprehensive suite of automation skills for Claude Code CLI that streamline software development workflows including code review, documentation generation, pull request creation, and change summarization.

## Skills Overview

This repository contains four core skills designed to enhance your development workflow:

### 1. Create Summary (`create-summary`)
Generates comprehensive summaries of repository changes by running tests, analyzing git diffs, and formatting output according to project templates or industry standards.

**Use when:**
- Preparing pull requests
- Documenting work
- Creating change logs
- Summarizing branch changes

### 2. Code Review (`code-review`)
Provides structured, multi-dimensional code review following industry best practices with detailed feedback on correctness, security, performance, maintainability, test coverage, and style.

**Use when:**
- Reviewing pull requests
- Auditing code quality
- Ensuring security compliance
- Checking test coverage

### 3. Codebase Documentation (`codebase-docs`)
Generates structured, developer-friendly documentation for new features, architectural decisions, and bugs with consistent templates.

**Use when:**
- Documenting new features
- Creating architecture documents
- Logging bugs and fixes
- Writing technical documentation

### 4. Create Pull Request (`create-pr`)
End-to-end pull request automation that combines change summarization with GitHub PR creation.

**Use when:**
- Creating pull requests
- Submitting code for review
- Publishing branch changes to GitHub

## Installation

These skills are designed to work with [Claude Code CLI](https://claude.ai/code). To use them:

1. Clone this repository:
   ```bash
   git clone git@github.com:irel04/agent-skills.git
   ```

2. Ensure you have Claude Code CLI installed:
   ```bash
   # Install Claude Code CLI if you haven't already
   # Follow instructions at https://claude.ai/code
   ```

3. The skills will be automatically detected when you run Claude Code in any repository.

## Usage

### Create Summary
To generate a summary of your changes:
```
"Create a summary of my changes"
"Summarize changes compared to main branch"
"Quick summary without running tests"
```

### Code Review
To review a pull request:
```
"Review this pull request"
"Check PR #123"
"Analyze this PR for security issues"
```

### Codebase Documentation
To generate documentation:
```
"Document this feature"
"Create an architecture doc for the auth module"
"Write a bug report for the login issue"
```

### Create Pull Request
To create a pull request:
```
"Create a PR for my changes"
"Open a pull request to the develop branch"
"Create a draft PR so I can review it first"
```

## Skill Details

### Create Summary Workflow

1. **Pre-flight Check**
   - Verifies git repository
   - Identifies current branch
   - Detects base branch for comparison

2. **Test Execution**
   - Runs project tests automatically
   - Handles multiple test frameworks (npm, pytest, cargo, go)
   - Reports failures and asks whether to continue

3. **Git Diff Analysis**
   - Analyzes changes between branches
   - Categorizes modifications by file type
   - Generates change statistics

4. **Template Detection & Formatting**
   - Uses repository-specific PR templates when available
   - Falls back to comprehensive default template
   - Auto-populates sections based on diff analysis

5. **Output Options**
   - Terminal display
   - File saving (PR_DESCRIPTION.md, CHANGES.md)
   - Clipboard copying with `/copy`

### Code Review Standards

Reviews are conducted across six dimensions in priority order:

1. **Correctness** - Logic errors, edge cases, null handling
2. **Security** - Vulnerabilities, injection risks, credential exposure
3. **Performance** - N+1 queries, bottlenecks, resource usage
4. **Maintainability** - Code clarity, naming, complexity
5. **Test Coverage** - New behavior testing, test quality
6. **Conventions** - Style consistency, project patterns

### Codebase Documentation Templates

Documentation is generated using structured templates:

- **Feature Docs** - New functionality documentation
- **Architecture Docs** - System design and decisions
- **Bug Docs** - Issue reports and fixes
- **Docs Index** - Automatically maintained documentation index

### Create Pull Request Process

1. **Summary Generation** - Runs the create-summary workflow
2. **User Review** - Displays summary for confirmation
3. **GitHub Integration** - Creates PR via GitHub MCP
4. **Error Handling** - Manages common issues (auth, conflicts, etc.)

## Configuration

Each skill supports configuration options stored in `.claude/config.json`:

### Create Summary Configuration
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

### Create PR Configuration
```json
{
  "defaultBaseBranch": "main",
  "defaultDraft": false,
  "defaultReviewers": ["username1"],
  "defaultLabels": ["needs-review"],
  "skipTests": false,
  "autoConfirm": false
}
```

## Requirements

- [Claude Code CLI](https://claude.ai/code)
- Git repository
- Appropriate runtime environments for test execution (Node.js, Python, etc.)
- GitHub MCP connection for PR creation (optional)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, please open an issue in this repository or contact the maintainers.

## Acknowledgments

- Thanks to the Claude Code team for creating such a powerful development tool
- Inspired by best practices in software development and code review