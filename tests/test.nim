import unittest
import json, strutils, sequtils
import ../src/canonicaljson

suite "canonicaljson":

  test "canonicalizeJson":

    # https://tools.ietf.org/html/rfc8785#section-3.2.4
    let ans = [
      0x7b, 0x22, 0x6c, 0x69, 0x74, 0x65, 0x72, 0x61, 0x6c, 0x73, 0x22, 0x3a,
      0x5b, 0x6e, 0x75, 0x6c, 0x6c, 0x2c, 0x74, 0x72, 0x75, 0x65, 0x2c, 0x66,
      0x61, 0x6c, 0x73, 0x65, 0x5d, 0x2c, 0x22, 0x6e, 0x75, 0x6d, 0x62, 0x65,
      0x72, 0x73, 0x22, 0x3a, 0x5b, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33,
      0x33, 0x33, 0x2e, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x2c, 0x31,
      0x65, 0x2b, 0x33, 0x30, 0x2c, 0x34, 0x2e, 0x35, 0x2c, 0x30, 0x2e, 0x30,
      0x30, 0x32, 0x2c, 0x31, 0x65, 0x2d, 0x32, 0x37, 0x5d, 0x2c, 0x22, 0x73,
      0x74, 0x72, 0x69, 0x6e, 0x67, 0x22, 0x3a, 0x22, 0xe2, 0x82, 0xac, 0x24,
      0x5c, 0x75, 0x30, 0x30, 0x30, 0x66, 0x5c, 0x6e, 0x41, 0x27, 0x42, 0x5c,
      0x22, 0x5c, 0x5c, 0x5c, 0x5c, 0x5c, 0x22, 0x2f, 0x22, 0x7d,
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
    assert s == ans.mapIt(char(it)).join("")
    for i in 0 ..< ans.len:
      assert s[i].ord == ans[i], "mismatch at position " & $i

    assert s == """{"literals":[null,true,false],"numbers":[333333333.3333333,1e+30,4.5,0.002,1e-27],"string":"€$\u000f\nA'B\"\\\\\"/"}"""

  test "string - low ASCII":
    #[
      s = JSON.stringify(Array(32).fill(0).map((x,i) => String.fromCharCode(i)).join(""))
      s.split('').map(c => "0x" + c.charCodeAt(0).toString(16)).join(", ")

      result from firefox 82.0.2 
      result from chrome 85.0.4183.121 seems to have bug
    ]#
    let ans = [
      0x22, 0x5c, 0x75, 0x30, 0x30, 0x30, 0x30, 0x5c, 0x75, 0x30, 0x30, 0x30,
      0x31, 0x5c, 0x75, 0x30, 0x30, 0x30, 0x32, 0x5c, 0x75, 0x30, 0x30, 0x30,
      0x33, 0x5c, 0x75, 0x30, 0x30, 0x30, 0x34, 0x5c, 0x75, 0x30, 0x30, 0x30,
      0x35, 0x5c, 0x75, 0x30, 0x30, 0x30, 0x36, 0x5c, 0x75, 0x30, 0x30, 0x30,
      0x37, 0x5c, 0x62, 0x5c, 0x74, 0x5c, 0x6e, 0x5c, 0x75, 0x30, 0x30, 0x30,
      0x62, 0x5c, 0x66, 0x5c, 0x72, 0x5c, 0x75, 0x30, 0x30, 0x30, 0x65, 0x5c,
      0x75, 0x30, 0x30, 0x30, 0x66, 0x5c, 0x75, 0x30, 0x30, 0x31, 0x30, 0x5c,
      0x75, 0x30, 0x30, 0x31, 0x31, 0x5c, 0x75, 0x30, 0x30, 0x31, 0x32, 0x5c,
      0x75, 0x30, 0x30, 0x31, 0x33, 0x5c, 0x75, 0x30, 0x30, 0x31, 0x34, 0x5c,
      0x75, 0x30, 0x30, 0x31, 0x35, 0x5c, 0x75, 0x30, 0x30, 0x31, 0x36, 0x5c,
      0x75, 0x30, 0x30, 0x31, 0x37, 0x5c, 0x75, 0x30, 0x30, 0x31, 0x38, 0x5c,
      0x75, 0x30, 0x30, 0x31, 0x39, 0x5c, 0x75, 0x30, 0x30, 0x31, 0x61, 0x5c,
      0x75, 0x30, 0x30, 0x31, 0x62, 0x5c, 0x75, 0x30, 0x30, 0x31, 0x63, 0x5c,
      0x75, 0x30, 0x30, 0x31, 0x64, 0x5c, 0x75, 0x30, 0x30, 0x31, 0x65, 0x5c,
      0x75, 0x30, 0x30, 0x31, 0x66, 0x22
    ]
    let s = canonicalizeJson(newJString(
        "\0\1\2\3\4\5\6\7\8\9\10\11\12\13\14\15\16\17\18\19\20\21\22\23\24\25\26\27\28\29\30\31"));

    assert s.len == ans.len
    assert s == ans.mapIt(char(it)).join("")
    for i in 0 ..< ans.len:
      assert s[i].ord == ans[i], "mismatch at position " & $i

  test "object key sorting 1":
    let json = %*{
      "aa": 3,
      "": 0,
      "a": 2,
      "A": 1,
    }
    let s = canonicalizeJson(json)
    assert s == """{"":0,"A":1,"a":2,"aa":3}"""

  # test "object key sorting 2":
  #   let json = %*{
  #     "\u20ac": "Euro Sign",
  #     "\r": "Carriage Return",
  #     "\ufb33": "Hebrew Letter Dalet With Dagesh",
  #     "1": "One",
  #     "\ud83d\ude00": "Emoji: Grinning Face",
  #     "\u0080": "Control",
  #     "\u00f6": "Latin Small Letter O With Diaeresis"
  #   }
  #   let ans = """{"\r":"Carriage Return","1":"One","":"Control","ö":"Latin Small Letter O With Diaeresis","€":"Euro Sign","😀":"Emoji: Grinning Face","דּ":"Hebrew Letter Dalet With Dagesh"}"""
  #   let s = canonicalizeJson(json)
  #   echo s
  #   echo ans
  #   echo s.len
  #   echo ans.len
  #   assert ans == s

  test "sample 1":
    # https://github.com/erdtman/canonicalize
    let json = %*{
      "from_account": "543 232 625-3",
      "to_account": "321 567 636-4",
      "amount": 500,
      "curency": "USD"
    }
    let ans = """{"amount":500,"curency":"USD","from_account":"543 232 625-3","to_account":"321 567 636-4"}"""
    assert  canonicalizeJson(json) == ans

  test "sample 2":
    # https://github.com/erdtman/canonicalize
    let json = %*{
        "1": {"f": {"f":  "hi","F":  5} ,"\n":  56.0},
        "10": { },
        "":  "empty",
        "a": { },
        "111": [ {"e":  "yes","E":  "no" } ],
        "A": { }
    }
    let ans = """{"":"empty","1":{"\n":56,"f":{"F":5,"f":"hi"}},"10":{},"111":[{"E":"no","e":"yes"}],"A":{},"a":{}}"""
    let s =  canonicalizeJson(json)
    assert s == ans
