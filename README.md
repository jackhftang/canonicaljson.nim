# canonicaljson 

Stringify JSON according to [RFC8785](https://tools.ietf.org/html/rfc8785). Canonical JSON is useful for ryptographic operations.

## Usage 

```nim
let s = canonicalizeJson(%*{
  "numbers": [333333333.33333329, 1E30, 4.50,
              2e-3, 0.000000000000000000000000001],
  "string": "\u20ac$\u000f\u000aA'\u0042\u0022\u005c\\\"/",
  "literals": [newJNull(), true, false]
})

assert s == """{"literals":[null,true,false],"numbers":[333333333.3333333,1e+30,4.5,0.002,1e-27],"string":"€$\u000f\nA'B\"\\\\\"/"}"""
```



