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

proc addInt*(result: var string, b: byte) {.inline.} =
  result.add char(b + 48)

proc addInt*(result: var string, b: seq[byte], s, e: int) {.inline.} =
  for i in s ..< e:
    result.addInt b[i]

proc addRepeated*(result: var string, c: char, n: int) {.inline.} =
  for i in 1..n:
    result.add c

proc addJFloat*(result: var string, f: float) =
  # https://tools.ietf.org/html/rfc8785#section-3.2.2.3
  # https://www.ecma-international.org/ecma-262/10.0/index.html#sec-tostring-applied-to-the-number-type
  # http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.67.4438&rep=rep1&type=pdf
  case classify(f):
  of fcNan: result.add "NaN"
  of fcZero, fcNegZero: result.add "0"
  of fcInf: result.add "Infinity"
  of fcNegInf: result.add "-Infinity"
  of fcNormal, fcSubnormal:
    if f <= 0:
      result.add "-"
      result.addJFloat(-f)
    else:
      # precondition: f > 0
      const B = 10.0
      var w = ceil(log10(f))
      var digits = newSeqOfCap[byte](18)
      let v = f / pow(B, w)
      let up = v.succ   # upper bound in binary 
      let lo = v.pred   # lower bound in binary

      var mx = 1.0      # upper bound in decimal
      var mi = 0.0      # lower bound in decimal

      # loop while mi <= lo < up <= mx
      var q = v
      var g = 1.0
      while mi < lo and up < mx:
        q *= B
        let d = floor(q)
        q -= d

        g /= B
        mx = mi + (d+1)*g
        mi = mi + d*g

        digits.add byte(d)

      # add carry if q is closer to mx
      if mx - v < v - mi:
        let l = digits.len - 1
        for i in 0..l:
          digits[l-i] += 1
          if digits[l-i] == 10:
            digits.setLen(digits.len-1)
          else:
            break
          
      # remove trailing 0
      while digits.len > 0 and digits[digits.len-1] == 0:
        digits.setLen(digits.len-1)

      # always has an implicit 1
      if digits.len == 0:
        digits.add 1
        w += 1
      
      let k = digits.len
      let n = w.int       # f = 0.ddd * 10^n
      # echo "n=", n, " k=", k, " d=", digits 
      if k <= n and n <= 21:
        # whole number
        result.addInt(digits, 0, k)
        result.addRepeated('0', n-k)
      elif 0 < n and n <= 21:
        # xxx.xxx        
        result.addInt(digits, 0, n)
        result.add '.'
        result.addInt(digits, n, k)
      elif -6 < n and n <= 0:
        # 0.00...0xxxx
        result.add "0."
        result.addRepeated('0', -n)
        result.addInt(digits, 0, k)
      elif k == 1:
        # 1eXX
        result.addInt(digits[0])
        result.add 'e'
        if n >= 0: result.add '+'
        result.addInt(n-1)
      else:
        result.addInt digits[0]
        result.add '.'
        result.addInt(digits, 1, k)
        result.add 'e'
        if n >= 0: result.add '+'
        result.addInt(n-1)

proc addJFloat*(f: float): string =
  result.addJFloat(f)