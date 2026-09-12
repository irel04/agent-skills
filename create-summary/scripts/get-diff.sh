#!/bin/bash
# Get diff against specified base branch
# Usage: ./get-diff.sh <base-branch>

BASE_BRANCH="${1:-main}"

echo "Fetching latest from origin..."
git fetch origin

echo ""
echo "=== Diff Statistics ==="
git diff origin/"$BASE_BRANCH"...HEAD --stat

echo ""
echo "=== Full Diff ==="
git diff origin/"$BASE_BRANCH"...HEAD

echo ""
echo "=== Staged Changes ==="
git diff --staged

echo ""
echo "=== Unstaged Changes ==="
git diff
