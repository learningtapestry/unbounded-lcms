function scaleNumber(src, minSrc, maxSrc, minTgt, maxTgt) {
  src = parseFloat(src);
  return (((maxTgt - minTgt) * (src - minSrc)) / (maxSrc - minSrc)) + minTgt;
}
