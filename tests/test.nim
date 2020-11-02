import unittest
import json, strutils, sequtils
import ../src/canonicaljson

suite "canonicaljson":

  test "canonicalizeJson":

    # https://tools.ietf.org/html/rfc8785#section-3.2.4
    let ans = [
      0x7b, 0x22, 0x6c, 0x69, 0x74, 0x65, 0x72, 0x61, 0x6c, 0x73, 0x22, 0x3a, 0x5b, 0x6e, 0x75, 0x6c, 0x6c, 0x2c, 0x74, 0x72,
      0x75, 0x65, 0x2c, 0x66, 0x61, 0x6c, 0x73, 0x65, 0x5d, 0x2c, 0x22, 0x6e, 0x75, 0x6d, 0x62, 0x65, 0x72, 0x73, 0x22, 0x3a,
      0x5b, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x2e, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x2c, 0x31,
      0x65, 0x2b, 0x33, 0x30, 0x2c, 0x34, 0x2e, 0x35, 0x2c, 0x30, 0x2e, 0x30, 0x30, 0x32, 0x2c, 0x31, 0x65, 0x2d, 0x32, 0x37,
      0x5d, 0x2c, 0x22, 0x73, 0x74, 0x72, 0x69, 0x6e, 0x67, 0x22, 0x3a, 0x22, 0xe2, 0x82, 0xac, 0x24, 0x5c, 0x75, 0x30, 0x30,
      0x30, 0x66, 0x5c, 0x6e, 0x41, 0x27, 0x42, 0x5c, 0x22, 0x5c, 0x5c, 0x5c, 0x5c, 0x5c, 0x22, 0x2f, 0x22, 0x7d,
    ]
    var input = %*{
      "numbers": [333333333.33333329, 1E30, 4.50,
                  2e-3, 0.000000000000000000000000001],
      "string": "\u20ac$\u000f\u000aA'\u0042\u0022\u005c\\\"/",
      "literals": [newJNull(), true, false]
    }

    let s = canonicalizeJson(input)
    # echo s
    # echo ans.mapIt(char(it)).join("")
    # echo $input
    assert s.len == ans.len
    for i in 0 ..< ans.len:
      assert s[i].ord == ans[i], "mismatch at position " & $i