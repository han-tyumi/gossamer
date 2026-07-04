#!/usr/bin/env bash
# Verify or update recorded runtime floors in runtime.toml.
#
# Workflow:
#   - Reads the recorded floor for each runtime from runtime.toml.
#   - Verifies the floor: the recorded version should still PASS and the
#     version immediately below it should still FAIL.
#   - If the floor regressed (now fails), walks forward through versions
#     until tests pass and reports the new (higher) floor.
#   - If a fix lowered the floor (the version below now passes), walks
#     backward until tests fail and reports the new (lower) floor.
#
# Usage:
#   ./scripts/find-runtime-floor.sh                  # verify all three
#   ./scripts/find-runtime-floor.sh deno             # one runtime
#   ./scripts/find-runtime-floor.sh deno bun         # subset
#
# Caveat: accuracy is bounded by test coverage. Behavioral bugs only
# surface if the test suite exercises that behavior.

set -uo pipefail

FLOORS_FILE="$(cd "$(dirname "$0")/.." && pwd)/runtime.toml"

# Read recorded floor for a runtime from runtime.toml's [floors] table.
recorded_floor() {
    grep "^$1 *= *\"" "$FLOORS_FILE" | sed 's/.*"\(.*\)".*/\1/'
}

# Map runtime name → MISE env-var name.
mise_var_for() {
    case "$1" in
    nodejs) echo MISE_NODE_VERSION ;;
    deno) echo MISE_DENO_VERSION ;;
    bun) echo MISE_BUN_VERSION ;;
    esac
}

# Versions available via mise, sorted ascending (oldest first).
# We restrict Node to majors >= 18 to skip very old EOL versions.
available_versions() {
    case "$1" in
    nodejs) mise list-all nodejs 2>&1 | awk -F. '$1 >= 18' ;;
    deno) mise list-all deno 2>&1 | grep -E "^(1\.4[0-9]|2)" ;;
    bun) mise list-all bun 2>&1 | grep -E "^1\." ;;
    esac
}

# Test a specific runtime version. Echoes PASS or FAIL.
# Side effect: installs the version via mise if not already present.
test_version() {
    runtime=$1
    version=$2
    var=$(mise_var_for "$runtime")

    if ! mise install "${runtime}@${version}" >/dev/null 2>&1; then
        echo "INSTALL_FAIL"
        return
    fi
    if env "$var=$version" gleam test --runtime "$runtime" >/dev/null 2>&1; then
        echo "PASS"
    else
        echo "FAIL"
    fi
}

# Walk a range of versions in one direction, return the first version with the desired result.
# Args: runtime, direction (+1 or -1), start_idx, end_idx, expected (PASS or FAIL)
walk() {
    runtime=$1
    direction=$2
    start=$3
    end=$4
    expected=$5
    shift 5
    versions=("$@")

    idx=$start
    while [ "$idx" -ge 1 ] && [ "$idx" -le "$end" ]; do
        ver="${versions[$((idx - 1))]}"
        printf "    try %-10s ... " "$ver" >&2
        result=$(test_version "$runtime" "$ver")
        echo "$result" >&2
        if [ "$result" = "$expected" ]; then
            echo "$ver"
            return
        fi
        idx=$((idx + direction))
    done
    echo ""
}

verify_runtime() {
    runtime=$1
    floor=$(recorded_floor "$runtime")

    if [ -z "$floor" ]; then
        echo "$runtime: no recorded floor in $FLOORS_FILE"
        return
    fi

    echo ""
    echo "=== $runtime (recorded floor: $floor) ==="

    # Load available versions into an array.
    IFS=$'\n' read -d '' -ra versions < <(available_versions "$runtime" && printf '\0')
    n=${#versions[@]}

    # Locate the recorded floor in the version list.
    floor_idx=0
    for i in "${!versions[@]}"; do
        if [ "${versions[$i]}" = "$floor" ]; then
            floor_idx=$((i + 1))
            break
        fi
    done

    if [ "$floor_idx" -eq 0 ]; then
        echo "  recorded floor $floor not found in mise's available versions; skipping"
        return
    fi

    # Test the recorded floor.
    printf "  floor       %-10s ... " "$floor"
    floor_result=$(test_version "$runtime" "$floor")
    echo "$floor_result"

    if [ "$floor_result" = "FAIL" ]; then
        # Floor regressed: walk forward to find new (higher) floor.
        echo "  → floor regressed; walking forward to find new floor"
        new_floor=$(walk "$runtime" 1 $((floor_idx + 1)) "$n" PASS "${versions[@]}")
        if [ -n "$new_floor" ]; then
            echo "  → new floor: $new_floor"
            update_floor "$runtime" "$new_floor"
        else
            echo "  → no passing version found through ${versions[$((n - 1))]}"
        fi
        return
    fi

    # Floor passes. Check if a fix lowered the floor — try the version below.
    if [ "$floor_idx" -le 1 ]; then
        echo "  → floor is at the oldest available version; no room to go lower"
        return
    fi
    below_idx=$((floor_idx - 1))
    below_ver="${versions[$((below_idx - 1))]}"
    printf "  below floor %-10s ... " "$below_ver"
    below_result=$(test_version "$runtime" "$below_ver")
    echo "$below_result"

    if [ "$below_result" = "FAIL" ]; then
        echo "  → floor unchanged: $floor"
        return
    fi

    # Below the floor passes — walk further back to find the true new floor.
    echo "  → fix lowered the floor; walking backward to find new floor"
    new_floor=$(walk "$runtime" -1 $((below_idx - 1)) "$n" FAIL "${versions[@]}")
    # `walk` returns the first FAIL — the floor is one above that.
    if [ -z "$new_floor" ]; then
        # All the way down passed — the oldest version is the new floor.
        actual_new=${versions[0]}
    else
        # Find index of new_floor (the first FAIL), the floor is at index+1.
        for i in "${!versions[@]}"; do
            if [ "${versions[$i]}" = "$new_floor" ]; then
                actual_new=${versions[$((i + 1))]}
                break
            fi
        done
    fi
    echo "  → new floor: $actual_new"
    update_floor "$runtime" "$actual_new"
}

update_floor() {
    runtime=$1
    new_floor=$2
    tmp=$(mktemp)
    sed "s|^${runtime} *= *\".*\"|${runtime} = \"${new_floor}\"|" "$FLOORS_FILE" >"$tmp"
    mv "$tmp" "$FLOORS_FILE"
    echo "  → updated $FLOORS_FILE: ${runtime} = \"${new_floor}\""
}

if [ $# -eq 0 ]; then
    targets="nodejs deno bun"
else
    targets="$*"
fi

for r in $targets; do
    case "$r" in
    nodejs | deno | bun) verify_runtime "$r" ;;
    *) echo "Unknown runtime: $r" >&2 ;;
    esac
done
