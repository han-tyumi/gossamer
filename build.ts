import * as fs from "@std/fs";
import * as path from "@std/path";
import { build, type Plugin } from "esbuild";

import denoConfig from "./deno.json" with { type: "json" };

const srcDir = path.resolve("src");
const buildRoot = path.resolve(denoConfig.imports["$/"]);
const packageBuildDir = path.resolve(buildRoot, "gossamer");
const buildImportRegex = /^\$\//;

const entryPointFiles = fs.expandGlob(path.joinGlobs([srcDir, "**/*.ffi.ts"]), {
  extended: false,
  includeDirs: false,
});

const entryPoints = await Array.fromAsync(entryPointFiles, (entry) => {
  const { dir, name } = path.parse(path.relative(srcDir, entry.path));
  return {
    in: entry.path,
    out: path.resolve(srcDir, path.join(dir, name)),
  };
});

function createBuildImportMapper(entryPointPath: string): Plugin {
  const entryDir = path.dirname(entryPointPath);
  const outputDir = path.resolve(
    packageBuildDir,
    path.relative(srcDir, entryDir),
  );

  return {
    name: "build-import-mapper",
    setup: (pluginBuild) => {
      pluginBuild.onResolve({ filter: buildImportRegex }, (args) => {
        const targetPath = path.resolve(
          buildRoot,
          args.path.replace(buildImportRegex, ""),
        );
        const relativePath = path.relative(outputDir, targetPath);

        return {
          path: relativePath.startsWith(".")
            ? relativePath
            : `./${relativePath}`,
          external: true,
        };
      });
    },
  };
}

await Promise.all(entryPoints.map((entryPoint) =>
  build({
    entryPoints: [entryPoint],
    platform: "neutral",
    outdir: srcDir,
    outExtension: { ".js": ".mjs" },
    target: "esnext",
    bundle: true,
    alias: { "~": denoConfig.imports["~/"] },
    plugins: [createBuildImportMapper(entryPoint.in)],
  })
));
