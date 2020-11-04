import math
import strutils
import ./ryu/ryu

type
  CanonicalJsonError* = object of CatchableError
  InvalidFloatError* = object of CanonicalJsonError
    value: float

proc addRepeated(result: var string, c: char, n: int) {.inline.} =
  for i in 1..n:
    result.add c

proc addString(result: var string, str: string, s, e: int) {.inline.} =
  for i in s ..< e: result.add str[i]

proc canonify*(result: var string, f: float) = 
  case classify(f):
  of fcZero, fcNegZero: 
    result.add "0"
  of fcNan, fcInf, fcNegInf: 
    #[
      https://tools.ietf.org/html/rfc8785#section-3.2.2.3
      Note: Since Not a Number (NaN) and Infinity are not permitted in
      JSON, occurrences of NaN or Infinity MUST cause a compliant JCS
      implementation to terminate with an appropriate error.
    ]#
    let err = newException(InvalidFloatError, "Cannot canonify " & $f)
    err.value = f
    raise err
  of fcNormal, fcSubnormal:
    if f <= 0:
      result.add "-"
      result.canonify(-f)
    else:
      let s = d2s(f)
      #[
        s is of form 
        dExx
        d.dExx
        d.ddddE-xx
      ]# 
      let ix = s.find('E')
      let n = parseInt(s[ix+1 .. s.len-1]) + 1
      let k = if ix > 2: ix - 1 else: ix

      if k <= n and n <= 21:
        # xxxx00000
        result.add s[0]
        result.addString(s, 2, ix)
        result.addRepeated('0', n-k)
      elif 0 < n and n <= 21:
        # xxx.xxx
        result.add s[0]
        result.addString(s, 2, n+1)
        result.add '.'
        result.addString(s, n+1, ix)
      elif -6 < n and n <= 0:
        # 0.00...0xxxx
        result.add "0."
        result.addRepeated('0', -n)
        result.add s[0]
        result.addString(s, 2, ix)
      elif k == 1:
        # 1e+XX
        result.add s[0]
        result.add 'e'
        if n >= 0: result.add '+'
        result.addInt(n-1)
      else:
        # x.xxxe+xxx
        result.addString(s, 0, ix)
        result.add 'e'
        if n >= 0: result.add '+'
        result.addInt(n-1)

proc canonify*(f: float): string = 
  canonify(result, f)

when isMainModule:
  import unittest
  check: canonify(333333333.33333329) == "333333333.3333333"
  check: canonify(10000000000000000000000f64) == "1e+22"
  check: canonify(1000000000000000000000f64) == "1e+21"
  check: canonify(100000000000000000000f64) == "100000000000000000000"
  check: canonify(10000000000000000000f64) == "10000000000000000000"
  check: canonify(1000000000000000000f64) == "1000000000000000000"
  check: canonify(100000000000000000f64) == "100000000000000000"
  check: canonify(10000000000000000f64) == "10000000000000000"
  check: canonify(1000000000000000f64) == "1000000000000000"
  check: canonify(100000000000000f64) == "100000000000000"
  check: canonify(10000000000000f64) == "10000000000000"
  check: canonify(1000000000000f64) == "1000000000000"
  check: canonify(100000000000f64) == "100000000000"
  check: canonify(10000000000f64) == "10000000000"
  check: canonify(1000000000f64) == "1000000000"
  check: canonify(100000000f64) == "100000000"
  check: canonify(10000000f64) == "10000000"
  check: canonify(1000000f64) == "1000000"
  check: canonify(100000f64) == "100000"
  check: canonify(10000f64) == "10000"
  check: canonify(1000f64) == "1000"
  check: canonify(100f64) == "100"
  check: canonify(10f64) == "10"
  check: canonify(1f64) == "1"
  check: canonify(0.1) == "0.1"
  check: canonify(0.01) == "0.01"
  check: canonify(0.001) == "0.001"
  check: canonify(0.0001) == "0.0001"
  check: canonify(0.00001) == "0.00001"
  check: canonify(0.000001) == "0.000001"
  check: canonify(0.0000001) == "1e-7"
  check: canonify(0.00000001) == "1e-8"
  check: canonify(0.000000001) == "1e-9"
  check: canonify(0.0000000001) == "1e-10"
  check: canonify(0.0)   == "0"
  check: canonify(1/3)   == "0.3333333333333333"
  check: canonify(1/4)   == "0.25"
  check: canonify(1/5)   == "0.2"
  check: canonify(1/6)   == "0.16666666666666666"
  check: canonify(1/7)   == "0.14285714285714285"
  check: canonify(1/9)   == "0.1111111111111111"
  check: canonify(1/11)  == "0.09090909090909091"
  check: canonify(1/13)  == "0.07692307692307693"
  check: canonify(2/3)   == "0.6666666666666666"
  check: canonify(100/7) == "14.285714285714286"
  check: canonify(-1/3) == "-0.3333333333333333"
  check: canonify(-2/3) == "-0.6666666666666666"
  