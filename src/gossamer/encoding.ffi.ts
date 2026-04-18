import * as $enc from "$/gossamer/gossamer/encoding.mjs";

export function fromEncoding(value: string): $enc.Encoding$ {
  switch (value) {
    case "utf-8":
      return $enc.Encoding$Utf8();
    default:
      return $enc.Encoding$Other(value);
  }
}
