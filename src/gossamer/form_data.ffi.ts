import * as $formData from "$/gossamer/gossamer/form_data.mjs";
import { fromArray } from "~/utils/list.ts";
import { toResult } from "~/utils/result.ts";

function toFormDataValue(
  value: FormDataEntryValue,
): $formData.FormDataValue$ {
  if (typeof value === "string") {
    return $formData.FormDataValue$Text(value);
  }
  return $formData.FormDataValue$FileValue(value);
}

export type FormData$ = FormData;

export const new_: typeof $formData.new$ = () => {
  return new FormData();
};

export const append: typeof $formData.append = (formData, name, value) => {
  formData.append(name, value);
  return formData;
};

export const append_blob: typeof $formData.append_blob = (
  formData,
  name,
  value,
) => {
  formData.append(name, value);
  return formData;
};

export const append_blob_with_filename:
  typeof $formData.append_blob_with_filename = (
    formData,
    name,
    value,
    filename,
  ) => {
    formData.append(name, value, filename);
    return formData;
  };

export const delete_: typeof $formData.delete$ = (formData, name) => {
  formData.delete(name);
  return formData;
};

export const get: typeof $formData.get = (formData, name) => {
  const value = formData.get(name);
  return toResult(typeof value === "string" ? value : null);
};

export const get_file: typeof $formData.get_file = (formData, name) => {
  const value = formData.get(name);
  return toResult(value instanceof File ? value : null);
};

export const get_all: typeof $formData.get_all = (formData, name) => {
  const values = formData.getAll(name);
  return fromArray(
    values.filter((value): value is string => typeof value === "string"),
  );
};

export const get_all_files: typeof $formData.get_all_files = (
  formData,
  name,
) => {
  const values = formData.getAll(name);
  return fromArray(
    values.filter((value): value is File => value instanceof File),
  );
};

export const has: typeof $formData.has = (formData, name) => {
  return formData.has(name);
};

export const set: typeof $formData.set = (formData, name, value) => {
  formData.set(name, value);
  return formData;
};

export const set_blob: typeof $formData.set_blob = (formData, name, value) => {
  formData.set(name, value);
  return formData;
};

export const set_blob_with_filename: typeof $formData.set_blob_with_filename = (
  formData,
  name,
  value,
  filename,
) => {
  formData.set(name, value, filename);
  return formData;
};

export const keys: typeof $formData.keys = (formData) => {
  return formData.keys();
};

export const values: typeof $formData.values = (formData) => {
  return Array.from(formData.values(), toFormDataValue).values();
};

export const entries: typeof $formData.entries = (formData) => {
  return Array.from(
    formData.entries(),
    ([name, value]): [string, $formData.FormDataValue$] => [
      name,
      toFormDataValue(value),
    ],
  ).values();
};

export const for_each: typeof $formData.for_each = (formData, callback) => {
  formData.forEach((value, name) => {
    callback(name, toFormDataValue(value));
  });
};
