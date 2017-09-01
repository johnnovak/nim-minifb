when defined(windows):
  import windows/winminifb

elif defined(macosx):
  {.passL: "-framework Cocoa",
    passC: "-Isrc/include",
    compile: "src/macosx/OSXWindowFrameView.m",
    compile: "src/macosx/MacMiniFB.m",
    compile: "src/macosx/OSXWindow.m".}

else:
  {.passL: "-lX11",
    passC: "-Isrc/include",
    compile: "src/x11/X11MiniFB.c".}


when defined(windows):
  export mfbOpen, mfbUpdate, mfbClose

else:
  proc native_mfbOpen(title: string, width, height: int): int
    {.cdecl, importc: "mfb_open".}

  proc mfbOpen*(title: string, width, height: int): bool =
    native_mfbOpen(title, width, height) == 1

  proc native_mfbUpdate(buffer: pointer): int {.cdecl, importc: "mfb_update".}

  proc mfbUpdate*(buffer: pointer): bool =
    native_mfbUpdate(buffer) != 0

  proc mfbClose*() {.cdecl, importc: "mfb_close".}

