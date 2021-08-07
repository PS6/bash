#!/bin/bash

tmux new -s ssh-agent -d
tmux send-keys -t ssh-agent 'eval $(ssh-agent)' C-m
tmux send-keys -t ssh-agent 'echo "remember Ctrl-b is hotkey"' C-m
tmux send-keys -t ssh-agent 'ssh-add ~/.ssh/ssh4ansible' C-m
tmux a -t ssh-agent
