# Package

version       = "1.1.2"
author        = "Jack Tang"
description   = "canonicaljson"
license       = "MIT"
backend       = "c"
srcDir        = "src"
binDir        = "bin"
bin           = @[]

# Dependencies

requires "nim >= 1.0.0"

proc updateNimbleVersion(ver: string) =
  let fname = "canonicaljson.nimble"
  let txt = readFile(fname)
  var lines = txt.split("\n")
  for i, line in lines:
    if line.startsWith("version"): 
      let s = line.find('"')
      let e = line.find('"', s+1)
      lines[i] = line[0..s] & ver & line[e..<line.len]
      break
  writeFile(fname, lines.join("\n"))

task version, "update version":
  # last params as version
  let ver = paramStr( paramCount() )
  if ver == "version": 
    # print current version
    echo version
  else:
    withDir thisDir(): 
      updateNimbleVersion(ver)

task docgen, "generate docs":
  exec "nim doc --out:docs --project src/canonicaljson.nim"

task release_patch, "release with patch increment":
  exec "release-it --ci -i patch"

task release_minor, "releaes with minor increment":
  exec "release-it --ci -i minor"

task release_major, "release with major increment":
  exec "release-it --ci -i major"