#!/bin/sh
# Fake vizb binary for testing - simulates vizb behavior without network access

SUBCOMMAND=""
OUTPUT=""
DATA_URL=""
SKIP_NEXT=0

# First pass: detect subcommand
case "$1" in
  ui|merge) SUBCOMMAND="$1" ;;
esac

# Parse all arguments for -o and -U flags
for arg in "$@"; do
  if [ "$SKIP_NEXT" = "1" ]; then
    if [ "$PREV_FLAG" = "-o" ] || [ "$PREV_FLAG" = "--output" ]; then
      OUTPUT="$arg"
    elif [ "$PREV_FLAG" = "-U" ]; then
      DATA_URL="$arg"
    fi
    SKIP_NEXT=0
    PREV_FLAG=""
    continue
  fi
  case "$arg" in
    -o|--output|-U)
      SKIP_NEXT=1
      PREV_FLAG="$arg"
      ;;
  esac
done

if [ -z "$OUTPUT" ]; then
  echo "fake-vizb: no -o output specified" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"

if [ "$SUBCOMMAND" = "ui" ]; then
  if [ -n "$DATA_URL" ]; then
    printf '<!DOCTYPE html>\n<html>\n<head><title>Vizb Chart</title></head>\n<body>\n<div id="vizb-root" data-url="%s"></div>\n<script>/* vizb ui bundle */</script>\n</body>\n</html>\n' "$DATA_URL" > "$OUTPUT"
  else
    printf '<!DOCTYPE html>\n<html>\n<head><title>Vizb Chart</title></head>\n<body>\n<div id="vizb-root"></div>\n<script>/* vizb ui bundle */</script>\n</body>\n</html>\n' > "$OUTPUT"
  fi
elif [ "$SUBCOMMAND" = "merge" ]; then
  printf '{"name":"Merged","datasets":[{"tag":"merged","groups":[{"name":"group1","values":[{"label":"x","value":1}]}]}]}\n' > "$OUTPUT"
else
  printf '{"name":"Comparisons","datasets":[{"tag":"default","groups":[{"name":"BenchmarkFoo","values":[{"label":"ns/op","value":1234},{"label":"B/op","value":128}]},{"name":"BenchmarkBar","values":[{"label":"ns/op","value":2345},{"label":"B/op","value":256}]}]}]}\n' > "$OUTPUT"
fi

exit 0
