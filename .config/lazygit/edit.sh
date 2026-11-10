#!/usr/bin/env bash
# Editor wrapper for Lazygit: choose an editor based on context.

file="$1"
line="${2:-}"

if [ -n "${VISUAL:-}" ]; then
	editor="$VISUAL"
elif [ -n "${EDITOR:-}" ]; then
	editor="$EDITOR"
elif [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]; then
	editor="zed"
else
	editor="hx"
fi

if [ -n "$line" ]; then
	case "$editor" in
	hx | helix)
		exec hx "$file:$line"
		;;
	zed | code | codium | vscode)
		exec "$editor" "$file:$line"
		;;
	*)
		exec "$editor" "$file"
		;;
	esac
else
	exec "$editor" "$file"
fi
