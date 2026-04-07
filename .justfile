set dotenv-load := true

bootstrap:
  lefthook install
  deno install
  gleam deps download
  just build

clean:
  gleam clean
  -deno task clean

build:
  deno task build
  gleam build
  cp -r patch/* build/

test:
  gleam test --runtime deno
  gleam test --runtime nodejs
  gleam test --runtime bun

check:
  deno check --all 'src/**/*.ts'

format:
  deno fmt -q
  gleam format

docs:
  gleam docs build

watch +recipes:
  watchexec --no-meta -c -e gleam,mjs,ts,md,json -- just {{recipes}}

publish *args:
  gleam publish {{args}}
