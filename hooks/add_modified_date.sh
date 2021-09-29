#!/bin/zsh
# Contents of .git/hooks/pre-commit

git diff --cached --name-status | grep "^M" | while read a b; do
  cat $b | sed "/---.*/,/---.*/s/^last_modified_at:.*$/last_modified_at: $(date +"%d-%m-%Y %I:%M %p %z")/" > tmp_f
  mv tmp_f $b
  git add $b
done