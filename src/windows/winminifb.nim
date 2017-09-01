import windows


var
  g_shouldClose = false
  g_hwnd: HWND = 0
  g_width: int32 = 0
  g_height: int32 = 0
  g_hdc: HDC = 0
  g_buffer: pointer = nil
  g_bitmapInfo: PBITMAPINFO = nil


proc wndProc(hwnd: HWND, msg: WINUINT,
             wParam: WPARAM, lParam: LPARAM): LRESULT {.stdcall.} =

  case (msg)
  of WM_PAINT:
    if g_buffer != nil:
      discard StretchDIBits(g_hdc,
                            0, 0, g_width, g_height,
                            0, 0, g_width, g_height,
                            g_buffer,
                            g_bitmapInfo[], DIB_RGB_COLORS, SRCCOPY)

      discard ValidateRect(hwnd, nil)

  of WM_KEYDOWN:
    case wParam and 0xff
    of VK_ESCAPE:
      g_shouldClose = true
    else: discard

  of WM_CLOSE:
    g_shouldClose = true

  else:
    result = DefWindowProc(hwnd, msg, wParam, lParam)

  return result


proc mfbOpen*(title: string, width, height: int): bool =
  var wc: WNDCLASS

  wc.style         = CS_OWNDC or CS_VREDRAW or CS_HREDRAW
  wc.lpfnWndProc   = wndProc
  wc.hCursor       = LoadCursor(0, IDC_ARROW)
  wc.lpszClassName = title
  wc.hIcon         = LoadIcon(0, IDI_APPLICATION)

  discard RegisterClass(wc.addr)

  var rect: RECT
  rect.BottomRight.x = int32(width)
  rect.BottomRight.y = int32(height)

  discard AdjustWindowRect(rect.addr, WS_POPUP or WS_SYSMENU or WS_CAPTION, 0)

  rect.BottomRight.x -= rect.TopLeft.x
  rect.BottomRight.y -= rect.TopLeft.y

  g_width  = int32(width)
  g_height = int32(height)

  g_hwnd = CreateWindow(
    lpClassName = title, lpWindowName = title,
    WS_OVERLAPPEDWINDOW and (not WS_MAXIMIZEBOX) and (not WS_THICKFRAME),
    X = CW_USEDEFAULT, Y = CW_USEDEFAULT,
    nWidth = rect.BottomRight.x, nHeight = rect.BottomRight.y,
    hWndParent = 0, menu = 0, hInstance = 0, lpParam = nil)

  if g_hwnd == 0:
    return false

  discard ShowWindow(g_hwnd, SW_NORMAL)

  g_bitmapInfo = cast[PBITMAPINFO](alloc0(sizeof(BITMAPINFOHEADER) +
                                          sizeof(RGBQUAD) * 3))

  g_bitmapInfo[].bmiHeader.biSize        = DWORD(sizeof(BITMAPINFOHEADER))
  g_bitmapInfo[].bmiHeader.biPlanes      = 1
  g_bitmapInfo[].bmiHeader.biBitCount    = 32
  g_bitmapInfo[].bmiHeader.biCompression = BI_BITFIELDS
  g_bitmapInfo[].bmiHeader.biWidth       = int32(width)
  g_bitmapInfo[].bmiHeader.biHeight      = -int32(height)
  g_bitmapInfo[].bmiColors[0].rgbRed     = 0xff
  g_bitmapInfo[].bmiColors[1].rgbGreen   = 0xff
  g_bitmapInfo[].bmiColors[2].rgbBlue    = 0xff

  g_hdc = GetDc(g_hwnd)

  return true


proc mfbUpdate*(buffer: pointer): bool =
  var msg: MSG

  g_buffer = buffer

  discard InvalidateRect(g_hwnd, nil, 1)
  discard SendMessage(g_hwnd, WM_PAINT, 0, 0)

  while PeekMessage(msg.addr, g_hwnd, 0, 0, PM_REMOVE) != 0:
    discard TranslateMessage(msg.addr)
    discard DispatchMessage(msg.addr)

  if g_shouldClose:
    return true

  return false


proc mfbClose*() =
  g_buffer = nil
  discard ReleaseDC(g_hwnd, g_hdc)
  discard DestroyWindow(g_hwnd)

