import json
import algorithm

# https://tools.ietf.org/html/rfc8785

proc addJString(result: var string, s: string) = 
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
      let b = n - a
      result.add hex[a]
      result.add hex[b]
    of '\\': result.add "\\\\"
    of '"': result.add "\\\""
    else: result.add(c)
  result.add('"')

proc canonicalizeJson*(result: var string, node: JsonNode) =  
  var comma = false
  case node.kind:
  of JArray:
    result.add "["
    for child in node.elems:
      if comma: result.add ","
      else: comma = true
      result.toUgly child
    result.add "]"
  of JObject:
    result.add "{"
    var keys: seq[string]
    for key in node.keys:
      keys.add key
    keys.sort()
    for key in keys:
      if comma: result.add ","
      else: comma = true
      result.addJString key
      result.add ":"
      canonicalizeJson(result, node[key])
    result.add "}"
  of JString:
    result.addJString(node.str)
  of JInt:
    when defined(js): result.add($node.num)
    else: result.addInt(node.num)
  of JFloat:
    when defined(js): result.add($node.fnum)
    else: result.addFloat(node.fnum)
  of JBool:
    result.add(if node.bval: "true" else: "false")
  of JNull:
    result.add "null"

proc canonicalizeJson*(json: JsonNode): string = 
  ## Convert JsonNode to string according to RFC8785
  canonicalizeJson(result, json)
  

