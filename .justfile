set dotenv-load

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

[group('release')]
docs:
    gleam docs build

[group('release')]
gate: clean build check test examples docs

[group('build')]
watch +recipes:
    watchexec --no-meta -c -e gleam,mjs,ts,md,json -- just {{ recipes }}

[group('release')]
publish *args:
    gleam publish {{ args }}
