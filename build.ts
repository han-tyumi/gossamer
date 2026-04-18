import * as fs from "@std/fs";
import * as path from "@std/path";
import { build, type Plugin } from "esbuild";

import denoConfig from "./deno.json" with { type: "json" };

const srcDir = path.resolve("src");
const buildRoot = path.resolve(denoConfig.imports["$/"]);
const packageBuildDir = path.resolve(buildRoot, "gossamer");
const externalImportRegex = /^[$~]\//;

const entryPointFiles = fs.expandGlob(path.joinGlobs([srcDir, "**/*.ffi.ts"]), {
  extended: false,
  includeDirs: false,
});

const entryPoints = await Array.fromAsync(
  entryPointFiles,
  (entry) => entry.path,
);

const buildImportMapper: Plugin = {
  name: "build-import-mapper",
  setup: (pluginBuild) => {
    pluginBuild.onResolve({ filter: externalImportRegex }, (args) => {
      const importerRuntimeDir = path.resolve(
        packageBuildDir,
        path.relative(srcDir, path.dirname(args.importer)),
      );

      const targetPath = args.path.startsWith("~/")
        ? path.resolve(
          packageBuildDir,
          args.path.replace(/^~\//, "").replace(/\.ts$/, ".mjs"),
        )
        : path.resolve(buildRoot, args.path.replace(/^\$\//, ""));

      const relativePath = path.relative(importerRuntimeDir, targetPath);

      return {
        path: relativePath.startsWith(".") ? relativePath : `./${relativePath}`,
        external: true,
      };
    });
  },
};

await build({
  entryPoints,
  outdir: srcDir,
  outbase: srcDir,
  outExtension: { ".js": ".mjs" },
  platform: "neutral",
  target: "esnext",
  bundle: true,
  plugins: [buildImportMapper],
});
