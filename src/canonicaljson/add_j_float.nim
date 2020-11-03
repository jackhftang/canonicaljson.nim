import math

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
      var digits = newSeqOfCap[byte](18)
      var w = ceil(log10(f))
      let v = f / pow(B, w)
      
      var lo = 0.0      # lower bound in decimal
      var g = 1.0
      while true:
        let up = lo + g
        g /= B

        let mx = up/g
        let mi = lo/g
        if round(mx - mi) != B:
          # base B is no more valid
          if up - v <= v - lo:
            # up is close to v, round up
            digits[^1] += 1
          break

        let d = floor(v/g - mi)        
        let lo2 = lo + d*g
        if v < lo2:
          # arithmetics is no more valid
          if up - v <= v - lo:
            # up is close to v, round up
            digits[^1] += 1
          break
        
        # valid bound
        lo = lo2
        digits.add byte(d)

      # remove trailing 0
      while digits.len > 0 and digits[^1] == 0:
        digits.setLen(digits.len-1)

      # normalize digits
      while digits.len > 0 and digits[^1] == 10:
        digits.setLen(digits.len-1)
        if digits.len > 0: 
          digits[^1] += 1

      # if no digits, has an implicit 1
      if digits.len == 0:
        digits.add 1
        w += 1
      
      let k = digits.len
      let n = w.int       # f = 0.ddd * 10^n
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
        # 1e+XX
        result.addInt(digits[0])
        result.add 'e'
        if n >= 0: result.add '+'
        result.addInt(n-1)
      else:
        # x.xxxe+xxx
        result.addInt digits[0]
        result.add '.'
        result.addInt(digits, 1, k)
        result.add 'e'
        if n >= 0: result.add '+'
        result.addInt(n-1)

proc addJFloat*(f: float): string =
  result.addJFloat(f)