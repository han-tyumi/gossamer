import * as $normalizationForm from "$/gossamer/gossamer/string/normalization_form.mjs";

export function toNormalizationForm(
  form: $normalizationForm.NormalizationForm$,
): string {
  if ($normalizationForm.NormalizationForm$isNfc(form)) return "NFC";
  if ($normalizationForm.NormalizationForm$isNfd(form)) return "NFD";
  if ($normalizationForm.NormalizationForm$isNfkc(form)) return "NFKC";
  return "NFKD";
}
