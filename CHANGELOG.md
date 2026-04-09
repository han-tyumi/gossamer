## 5.0.0 (2026-04-09)

### Breaking Changes

- import_key_jwk now takes JsonWebKey instead of Dynamic, and export_key_jwk
  returns JsonWebKey instead of Dynamic.
- request property getters (cache, credentials, destination, mode, redirect,
  referrer_policy), response.type_, and RequestInit Redirect now use variant
  types instead of String.
- DigestAlgorithm replaced by HashAlgorithm. All crypto algorithm String fields
  now use variant types. KeyAlgorithm.Hmac loses its name field.
- request.method returns HttpMethod instead of String. RequestInit.Method takes
  HttpMethod instead of String. Encoding functions return Encoding instead of
  String. response.json renamed to response.from_json, response.json_body
  renamed to response.json. Algorithm type Name(String) variants renamed to
  Other(String).

### Features

- add JsonWebKey type for typed JWK import/export
- add types for request and response properties
- add Other(String) fallback to existing variant types
- add shared crypto variant types for algorithm strings
- add forward compatibility variants to existing types
- add HttpMethod and Encoding types, rename response JSON methods
- add missing RequestInit options

## 4.1.0 (2026-04-09)

### Features

- add labels to function arguments
- widen side-effect callback return types
- use generic types for Dynamic input parameters

## 4.0.1 (2026-04-08)

### Fixes

- widen Uint8Array type to accept ArrayBufferLike

## 4.0.0 (2026-04-08)

### Breaking Changes

- correct types and error handling from audit
- Removes alert, close, confirm, prompt, report_error. Changes return types on
  console, response.json, crypto_key.algorithm, subtle_crypto.digest,
  user_agent, async_iterator return/throw, and reader.read.

### Features

- add URLPattern, DOMException, and Error types modules

### Fixes

- improve type safety, add tests, and remove non-cross-runtime APIs

## 3.4.0 (2026-04-07)

### Features

- add MessageChannel, MessagePort, and queuing strategy modules

## 3.3.0 (2026-04-07)

### Features

- add console, performance, and navigator.userAgent modules

## 3.2.0 (2026-04-07)

### Features

- complete File, add ArrayBuffer/Uint8Array/AbortSignal members

## 3.1.0 (2026-04-07)

### Features

- add formData(), structuredClone, atob, btoa, TextEncoder.encoding

## 3.0.0 (2026-04-07)

### Breaking Changes

- add missing API members, ready state type, abort variants

## 2.0.0 (2026-04-07)

### Breaking Changes

- use Result for unsafe APIs, rename boolean getters, remove non-standard
  properties

## 1.0.1 (2026-04-07)

### Fixes

- use .type.ts files for external type annotations
