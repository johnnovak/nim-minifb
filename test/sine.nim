import math, os, times
import framebuf, minifb


proc main() =
  let
    width = 640
    height = 480

  var fb = newFrameBuf(width, height)

  if not mfbOpen("Sine Test", width, height):
    quit(0)

  while true:
    let t = epochTime()
    fb.clear(0x303030)

    for x in 0..<width:
      fb[x, int((float(height)/2 + sin(float(x) / 60.0 + t)*50))] = 0xff0000

    if mfbUpdate(fb.bufAddr):
      break

    sleep(10)

  mfbClose()


main()

