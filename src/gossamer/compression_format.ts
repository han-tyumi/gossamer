import * as $compressionFormat from "$/gossamer/gossamer/compression_format.mjs";

export function toCompressionFormat(
  format: $compressionFormat.CompressionFormat$,
): CompressionFormat {
  if ($compressionFormat.CompressionFormat$isDeflate(format)) return "deflate";
  if ($compressionFormat.CompressionFormat$isDeflateRaw(format)) {
    return "deflate-raw";
  }
  if ($compressionFormat.CompressionFormat$isGzip(format)) return "gzip";
  return "brotli";
}
