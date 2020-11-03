import math, strutils

proc succ*(f: float): float =
  let t = cast[uint64](f)
  
  # support positive float only
  let sgn = t shr 63
  assert sgn == 0

  let exp = t shr 52
  let fra = t and 0xFFFFFFFFFFFFFu64
  
  if fra != 0xFFFFFFFFFFFFFu64:
    result = cast[float]((exp shl 52) or (fra+1))
  elif exp != 0x7FF:
    result = cast[float]((exp+1) shl 52)
  else:
    # enough for your usage
    result = f

proc pred*(f: float): float =
  let t = cast[uint64](f)
  
  # support positive float only
  let sgn = t shr 63
  assert sgn == 0

  let exp = t shr 52
  let fra = t and 0xFFFFFFFFFFFFFu64
  
  if fra != 0:
    result = cast[float]((exp shl 52) or (fra-1))
  elif exp != 0:
    result = cast[float](((exp-1) shl 52) or 0xFFFFFFFFFFFFFu64)
  else:
    result = f



proc printFloat(f: float): tuple[exponent: int, digits: string] =
  let k = ceil(log10(f))
  let B = 10.0

  var q = f / pow(B, k)
  let up = q.succ   # upper bound in binary 
  let lo = q.pred   # lower bound in binary

  var mx = 1.0      # upper bound in decimal
  var mi = 0.0      # lower bound in decimal

  var g = 1.0
  var digits = newSeqOfCap[byte](18)
  while mi < lo and up < mx:
    q *= B
    let d = floor(q)
    q -= d

    g /= B
    mx = mi + (d+1)*g
    mi = mi + d*g

    digits.add byte(d)

  if mx - f < f - mi:
    # add carry if f is closer to mx
    let l = digits.len - 1
    for i in 0..l:
      digits[l-i] += 1
      if digits[l-i] == 10:
        digits.setLen(digits.len-1)
      else:
        break
      
  if digits.len == 0:
    # carry to 1
    digits.add 1

  return (k.int, digits.join(""))

proc addJFloat(result: var string, f: float) = 