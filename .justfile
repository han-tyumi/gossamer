[group('build')]
bootstrap:
    lefthook install
    deno install
    gleam deps download
    just build

[group('build')]
clean:
    gleam clean
    -deno task clean

[group('build')]
build:
    deno task build
    gleam build
    cp -r patch/* build/

[group('test')]
test runtime="deno nodejs bun":
    #!/usr/bin/env bash
    set -e
    for r in {{ runtime }}; do gleam test --runtime "$r"; done

[group('test')]
examples:
    #!/usr/bin/env bash
    set -e
    for dir in examples/*/; do
      echo "=== ${dir} ==="
      for runtime in deno nodejs bun; do
        (cd "${dir}" && gleam run --runtime "${runtime}")
      done
    done

[group('build')]
check:
    deno check --all 'src/**/*.ts' 'test/**/*.ts'

[group('build')]
format:
    deno fmt -q .claude .github .vscode docs examples patch src test *.md *.ts deno.json
    gleam format
    just --fmt

# --target sidesteps a compiler defect: the docs command resets the
# prod build cache for Erlang unless a target is given, so on this
# JavaScript-target package a second warm-cache run renders no module
# pages. Tracked at https://github.com/gleam-lang/gleam/issues/5941.
[group('release')]
docs:
    gleam docs build --target javascript

[group('release')]
gate: clean build check test examples docs

# Runs the knope release workflow with credentials sourced and validated
# up front: the GitHub token comes fresh from `gh auth token`, and the
# Hex key comes from the macOS Keychain when a `hexpm-gossamer-publish`
# entry exists (store one with
# `security add-generic-password -a "$USER" -s hexpm-gossamer-publish -w`).
# Without a Keychain entry, publishing uses the stored `gleam hex
# authenticate` login.
[group('release')]
release:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "${HEXPM_API_KEY:-}" ]; then
        echo "HEXPM_API_KEY is already set in the environment — it would shadow the Keychain key and the OAuth login. Unset it and re-run." >&2
        exit 1
    fi
    export GITHUB_TOKEN="$(gh auth token)"
    gh api repos/han-tyumi/gossamer --jq .id > /dev/null \
      || { echo "GitHub credentials failed — run gh auth login" >&2; exit 1; }
    hex_key="$(security find-generic-password -a "$USER" -s hexpm-gossamer-publish -w 2>/dev/null || true)"
    if [ -n "${hex_key}" ]; then
        status="$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: ${hex_key}" 'https://hex.pm/api/auth?domain=api&resource=write')"
        case "${status}" in
            204 | 403) export HEXPM_API_KEY="${hex_key}" ;;
            *)
                echo "Hex key in Keychain rejected (HTTP ${status}) — refresh it or delete the entry to use OAuth" >&2
                exit 1
                ;;
        esac
    else
        echo "No Keychain Hex key found; gleam publish will use the stored OAuth login"
    fi
    knope release

[group('build')]
watch +recipes:
    watchexec --no-meta -c -e gleam,mjs,ts,md,json -- just {{ recipes }}

[group('release')]
publish *args:
    gleam publish {{ args }}
