import checkStatus from './checkStatus';

export default function fetchJson(...args) {
  return fetch(...args)
    .then(checkStatus)
    .then(r => r.json());
};
