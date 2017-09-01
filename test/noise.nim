import minifb


proc main() =
  let
    width = 800
    height = 600

  var
    noise = 0
    carry = 0
    seed = 0xbeef
    buffer: seq[int32]

  if not mfbOpen("Noise Test", width, height):
    quit(1)

  buffer = newSeq[int32](width * height)

  while true:
    for i in 0..<(width * height):
      noise = seed
      noise = noise shr 3
      noise = noise xor seed
      carry = noise and 1
      noise = noise shr 1
      seed = seed shr 1
      seed = seed or (carry shl 30)
      noise = noise and 0xff
      buffer[i] = int32((noise shl 16) or (noise shl 8) or noise)

    if mfbUpdate(cast[pointer](buffer[0].addr)):
      break

  mfbClose()


main()
