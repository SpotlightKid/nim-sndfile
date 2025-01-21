when defined(windows):
  const soname = "(|lib)samplerate(|-0).dll"
elif defined(macosx):
  const soname = "libsamplerate.dylib"
else:
  const soname = "libsamplerate.so(|.0)"

{.pragma: libsrc, cdecl, dynlib: soname.}

type
  SrcData* = object
    dataIn*: ptr UncheckedArray[cfloat]
    dataOut*: ptr UncheckedArray[cfloat]
    inputFrames*: clong
    outputFrames*: clong
    inputFramesUsed*: clong
    outputFramesGen*: clong
    endOfInput*: cint
    srcRatio*: float64

  Converter* {.pure, size: sizeof(cint).} = enum
    SINC_BEST_QUALITY = 0
    SINC_MEDIUM_QUALITY = 1
    SINC_FASTEST = 2
    ZERO_ORDER_HOLD = 3
    LINEAR = 4

proc srcSimple*(data: ptr SrcData, converter_type: Converter, channels: cint): cint {.libsrc, importc: "src_simple".}
proc srcStrError*(error: cint): cstring {.libsrc, importc: "src_strerror".}
