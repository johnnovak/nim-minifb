type
  FrameBuf* = object
    w*, h*: int
    buf*: seq[int32]

proc newFrameBuf*(w, h: int): FrameBuf =
  result.w = w
  result.h = h
  result.buf = newSeq[int32](w * h)

proc clear*(fb: var FrameBuf, col: int32) {.inline.} =
  for i in 0..<fb.w * fb.h:
    fb.buf[i] = col

proc `[]=`*(fb: var FrameBuf, x, y: int, col: int32) {.inline.} =
  fb.buf[x + fb.w * y] = col

proc `[]`*(fb: var FrameBuf, x, y: int): int32 {.inline.} =
  fb.buf[x + fb.w * y]

proc bufAddr*(fb: var FrameBuf): pointer =
  cast[pointer](fb.buf[0].addr)

