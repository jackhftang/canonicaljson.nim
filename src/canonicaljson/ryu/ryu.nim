
{.compile: "d2s.c".}

proc d2s_buffered(f: cdouble, buf: ptr cchar) {.importc.}

proc d2s*(f: float): string =
  let buf = alloc(25)
  d2s_buffered(f, cast[ptr cchar](buf))
  result = $cast[cstring](buf)
  dealloc(buf)