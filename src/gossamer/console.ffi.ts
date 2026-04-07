import type * as $console from "$/gossamer/gossamer/console.mjs";

export const assert_: typeof $console.assert_ = (condition, data) => {
  console.assert(condition, data);
};

export const clear: typeof $console.clear = () => {
  console.clear();
};

export const count: typeof $console.count = (label) => {
  console.count(label);
};

export const count_reset: typeof $console.count_reset = (label) => {
  console.countReset(label);
};

export const debug: typeof $console.debug = (data) => {
  console.debug(data);
};

export const dir: typeof $console.dir = (item) => {
  console.dir(item);
};

export const error: typeof $console.error = (data) => {
  console.error(data);
};

export const group: typeof $console.group = (label) => {
  console.group(label);
};

export const group_collapsed: typeof $console.group_collapsed = (label) => {
  console.groupCollapsed(label);
};

export const group_end: typeof $console.group_end = () => {
  console.groupEnd();
};

export const info: typeof $console.info = (data) => {
  console.info(data);
};

export const log: typeof $console.log = (data) => {
  console.log(data);
};

export const table: typeof $console.table = (data) => {
  console.table(data);
};

export const time: typeof $console.time = (label) => {
  console.time(label);
};

export const time_end: typeof $console.time_end = (label) => {
  console.timeEnd(label);
};

export const time_log: typeof $console.time_log = (label) => {
  console.timeLog(label);
};

export const trace: typeof $console.trace = () => {
  console.trace();
};

export const warn: typeof $console.warn = (data) => {
  console.warn(data);
};
