import * as fs from "@std/fs";
import * as path from "@std/path";
import { build, type Plugin } from "esbuild";

import denoConfig from "./deno.json" with { type: "json" };

const srcDir = path.resolve("src");
const testDir = path.resolve("test");
const buildRoot = path.resolve(denoConfig.imports["$/"]);
const packageBuildDir = path.resolve(buildRoot, "gossamer");
const externalImportRegex = /^[$~]\//;

function importerRuntimeDir(importer: string): string {
  const dir = path.dirname(importer);
  const root = dir.startsWith(srcDir) ? srcDir : testDir;
  return path.resolve(packageBuildDir, path.relative(root, dir));
}

const buildImportMapper: Plugin = {
  name: "build-import-mapper",
  setup: (pluginBuild) => {
    pluginBuild.onResolve({ filter: externalImportRegex }, (args) => {
      const targetPath = args.path.startsWith("~/")
        ? path.resolve(
          packageBuildDir,
          args.path.replace(/^~\//, "").replace(/\.ts$/, ".mjs"),
        )
        : path.resolve(buildRoot, args.path.replace(/^\$\//, ""));

      const relativePath = path.relative(
        importerRuntimeDir(args.importer),
        targetPath,
      );

      return {
        path: relativePath.startsWith(".") ? relativePath : `./${relativePath}`,
        external: true,
      };
    });
  },
};

async function collectFfiFiles(dir: string): Promise<string[]> {
  return await Array.fromAsync(
    fs.expandGlob(path.joinGlobs([dir, "**/*.ffi.ts"]), {
      extended: false,
      includeDirs: false,
    }),
    (entry) => entry.path,
  );
}

const entryPoints = [
  ...await collectFfiFiles(srcDir),
  ...await collectFfiFiles(testDir),
];

await build({
  entryPoints,
  outdir: ".",
  outbase: ".",
  outExtension: { ".js": ".mjs" },
  platform: "neutral",
  target: "esnext",
  bundle: true,
  plugins: [buildImportMapper],
});
