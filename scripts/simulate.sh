#!/bin/bash

set -e

REPO_DIR="raphaelmatori"
BRANCH="main"

if [ ! -d "$REPO_DIR" ]; then
  git clone git@github.com:raphaelmatori/raphaelmatori.git "$REPO_DIR"
fi

cd "$REPO_DIR"
git checkout $BRANCH

for i in {1..10}; do
  echo "Linha $i - $(date)" >> "src/file$i.txt"
  git add .
  git commit -m "feat: simulation $i"
done

git push origin $BRANCH

for i in {1..3}; do
  BR="feature-$i"
  git checkout -b "$BR"
  echo "// feature $i" >> "src/feature$i.txt"
  git add .
  git commit -m "add feature $i"
  git push origin "$BR"

  # Aqui você teria que abrir o PR manualmente ou usar GitHub CLI:
  gh pr create --base main --head "$BR" --title "Add feature $i" --body "PR simulation - $i"
  sleep 5
  gh pr merge "$BR" --squash --delete-branch
done