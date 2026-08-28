#!/usr/bin/env bash
# Fake vizb binary for testing — simulates vizb convert/ui/merge behavior
# Parses -o <output> flag and writes a minimal valid output file

set -euo pipefail

SUBCOMMAND=""
OUTPUT=""
args=("$@")

# Detect subcommand (first arg that doesn't start with -)
for arg in "${args[@]}"; do
  case "$arg" in
    ui|merge)
      SUBCOMMAND="$arg"
      break
      ;;
    -*)
      ;;
    *)
      # positional arg (input file) — not a subcommand
      ;;
  esac
done

# Parse -o flag
prev=""
for arg in "${args[@]}"; do
  if [ "$prev" = "-o" ]; then
    OUTPUT="$arg"
  fi
  prev="$arg"
done

if [ -z "$OUTPUT" ]; then
  echo "fake-vizb: no -o flag provided" >&2
  exit 1
fi

case "$SUBCOMMAND" in
  ui)
    # Write a minimal HTML file
    cat > "$OUTPUT" <<'HTML'
<!DOCTYPE html>
<html><head><title>vizb chart</title></head>
<body><div id="app">fake vizb chart</div></body>
</html>
HTML
    echo "fake-vizb: wrote HTML to $OUTPUT"
    ;;
  merge)
    # Write a minimal merged JSON file
    cat > "$OUTPUT" <<'JSON'
[{"name":"merged","datasets":[]}]
JSON
    echo "fake-vizb: wrote merged JSON to $OUTPUT"
    ;;
  *)
    # Default: convert — write a minimal JSON file
    cat > "$OUTPUT" <<'JSON'
[{"name":"test","groups":[{"name":"Alpha","values":[100]},{"name":"Beta","values":[200]}]}]
JSON
    echo "fake-vizb: wrote JSON to $OUTPUT"
    ;;
esac
