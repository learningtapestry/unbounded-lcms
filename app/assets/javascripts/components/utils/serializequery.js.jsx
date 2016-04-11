function serializeQuery(params) {
  let res = '';
  _.forEach(params, (value, key) => {
    res += `&${key}=${value.join(',')}`;
  });
  return res ? `?${res.slice(1)}` : res;
}
