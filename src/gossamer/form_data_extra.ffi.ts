import type * as $formDataExtra from "$/gossamer/gossamer/form_data_extra.mjs";

function cloneFormData(form: FormData): FormData {
  const cloned = new FormData();
  for (const [key, value] of form.entries()) cloned.append(key, value);
  return cloned;
}

export const append_file: typeof $formDataExtra.append_file = (
  form,
  key,
  value,
) => {
  const cloned = cloneFormData(form);
  cloned.append(key, value);
  return cloned;
};

export const set_file: typeof $formDataExtra.set_file = (form, key, value) => {
  const cloned = cloneFormData(form);
  cloned.set(key, value);
  return cloned;
};
