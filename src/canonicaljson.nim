import json
import algorithm
import canonicaljson/canonify_float

# https://tools.ietf.org/html/rfc8785

proc cmpJString*(a,b: string): int =
  let l = min(a.len, b.len)
  for i in 0..<l:
    let t = a[i].ord - b[i].ord
    if t < 0: return -1
    if t > 0: return 1
  if a.len > b.len: return 1
  if a.len < b.len: return -1
  return 0

proc canonify(result: var string, s: string) = 
  ## Append canonical JSON to string

  let hex = "0123456789abcdefg"
  result.add('"')
  # https://tools.ietf.org/html/rfc8785#section-3.2.2.2
  for c in s:
    case c
    of '\0'..'\7': 
      result.add "\\u000"
      result.addInt ord(c)
    of '\8': result.add "\\b"
    of '\9': result.add "\\t"
    of '\10': result.add "\\n"
    of '\11': result.add "\\u000b"
    of '\12': result.add "\\f"
    of '\13': result.add "\\r"
    of '\14'..'\31': 
      result.add "\\u00"
      let n = ord(c)
      let a = n shr 4
      let b = n and 0xF
      result.add hex[a]
      result.add hex[b]
    of '\\': result.add "\\\\"
    of '"': result.add "\\\""
    else: result.add(c)
  result.add('"')

proc canonify*(result: var string, node: JsonNode) =  
  ## Append canonical JSON to string.
  
  var comma = false
  case node.kind:
  of JArray:
    result.add "["
    for child in node.elems:
      if comma: result.add ","
      else: comma = true
      result.canonify child
    result.add "]"
  of JObject:
    result.add "{"
    var keys: seq[string]
    for key in node.keys:
      keys.add key
    keys = keys.sorted(cmpJString)
    for key in keys:
      if comma: result.add ","
      else: comma = true
      result.canonify key
      result.add ":"
      canonify(result, node[key])
    result.add "}"
  of JString:
    result.canonify(node.str)
  of JInt:
    result.canonify(node.num.float)
  of JFloat:
    result.canonify(node.fnum)
  of JBool:
    result.add(if node.bval: "true" else: "false")
  of JNull:
    result.add "null"

proc canonify*(json: JsonNode): string = 
  ## Convert JsonNode to string according to RFC8785.
  canonify(result, json)
  

