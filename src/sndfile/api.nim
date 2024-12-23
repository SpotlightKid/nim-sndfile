when defined(windows):
  const soname = "(|lib)sndfile(|-1|-2).dll"
elif defined(macosx):
  const soname = "libsndfile.dylib"
else:
  const soname = "libsndfile.so(|.1)"

{.pragma: libsnd, cdecl, dynlib: soname.}


const codingHistSize {.strdefine: "sfCodingHistSize".}: uint32 = 256
const maxTagTextSize {.strdefine: "sfMaxTagTextSize".}: uint32 = 256


type
  # The following three enums are one enum in soundfile.h
  # Separated here into three enums for clarity
  SFBool* {.pure, size: sizeof(cint).} = enum
    FALSE
    TRUE

  SFMode* {.pure, size: sizeof(cint).} = enum
    READ = 0x10
    WRITE = 0x20
    RDWR = 0x30

  SFAmbisonic* {.pure, size: sizeof(cint).} = enum
    NONE = 0x40
    B_FORMAT = 0x41

  SFSeek* {.pure, size: sizeof(cint).} = enum
    SET
    CUR
    END

  SFErr* {.pure, size: sizeof(cint).} = enum
    NO_ERROR
    UNRECOGNISED_FORMAT
    SYSTEM
    MALFORMED_FILE
    UNSUPPORTED_ENCODING

  SFCommand* {.pure, size: sizeof(cint).} = enum
    GET_LIB_VERSION = 0x1000
    GET_LOG_INFO = 0x1001
    GET_CURRENT_SF_INFO = 0x1002
    GET_NORM_DOUBLE = 0x1010
    GET_NORM_FLOAT = 0x1011
    SET_NORM_DOUBLE = 0x1012
    SET_NORM_FLOAT = 0x1013
    SET_SCALE_FLOAT_INT_READ = 0x1014
    SET_SCALE_INT_FLOAT_WRITE = 0x1015
    GET_SIMPLE_FORMAT_COUNT = 0x1020
    GET_SIMPLE_FORMAT = 0x1021
    GET_FORMAT_INFO = 0x1028
    GET_FORMAT_MAJOR_COUNT = 0x1030
    GET_FORMAT_MAJOR = 0x1031
    GET_FORMAT_SUBTYPE_COUNT = 0x1032
    GET_FORMAT_SUBTYPE = 0x1033
    CALC_SIGNAL_MAX = 0x1040
    CALC_NORM_SIGNAL_MAX = 0x1041
    CALC_MAX_ALL_CHANNELS = 0x1042
    CALC_NORM_MAX_ALL_CHANNELS = 0x1043
    GET_SIGNAL_MAX = 0x1044
    GET_MAX_ALL_CHANNELS = 0x1045
    SET_ADD_PEAK_CHUNK = 0x1050
    SET_ADD_HEADER_PAD_CHUNK = 0x1051
    UPDATE_HEADER_NOW = 0x1060
    SET_UPDATE_HEADER_AUTO = 0x1061
    FILE_TRUNCATE = 0x1080
    SET_RAW_START_OFFSET = 0x1090

    SET_DITHER_ON_WRITE = 0x10A0
    SET_DITHER_ON_READ = 0x10A1

    GET_DITHER_INFO_COUNT = 0x10A2
    GET_DITHER_INFO = 0x10A3
    GET_EMBED_FILE_INFO = 0x10B0
    SET_CLIPPING = 0x10C0
    GET_CLIPPING = 0x10C1
    GET_INSTRUMENT = 0x10D0
    SET_INSTRUMENT = 0x10D1
    GET_LOOP_INFO = 0x10E0
    GET_BROADCAST_INFO = 0x10F0
    SET_BROADCAST_INFO = 0x10F1
    GET_CHANNEL_MAP_INFO = 0x1100
    SET_CHANNEL_MAP_INFO = 0x1101
    RAW_DATA_NEEDS_ENDSWAP = 0x1110
    WAVEX_SET_AMBISONIC = 0x1200
    WAVEX_GET_AMBISONIC = 0x1201

    RF64_AUTO_DOWNGRADE = 0x1210

    SET_VBR_ENCODING_QUALITY = 0x1300
    SET_COMPRESSION_LEVEL = 0x1301

    SET_OGG_PAGE_LATENCY_MS = 0x1302
    SET_OGG_PAGE_LATENCY = 0x1303
    GET_OGG_STREAM_SERIALNO = 0x1306

    GET_BITRATE_MODE = 0x1304
    SET_BITRATE_MODE = 0x1305

    SET_CART_INFO = 0x1400
    GET_CART_INFO = 0x1401

    SET_ORIGINAL_SAMPLERATE = 0x1500
    GET_ORIGINAL_SAMPLERATE = 0x1501

    TEST_IEEE_FLOAT_REPLACE = 0x6001

  SFFormat* {.pure, size: sizeof(cint).} = enum
    # Subtypes
    PCM_S8 = 0x0001
    PCM_16 = 0x0002
    PCM_24 = 0x0003
    PCM_32 = 0x0004
    PCM_U8 = 0x0005
    FLOAT = 0x0006
    DOUBLE = 0x0007

    ULAW = 0x0010
    ALAW = 0x0011
    IMA_ADPCM = 0x0012
    MS_ADPCM = 0x0013

    GSM610 = 0x0020
    VOX_ADPCM = 0x0021
    NMS_ADPCM_16 = 0x0022
    NMS_ADPCM_24 = 0x0023
    NMS_ADPCM_32 = 0x0024

    G721_32 = 0x0030
    G723_24 = 0x0031
    G723_40 = 0x0032

    DWVW_12 = 0x0040
    DWVW_16 = 0x0041
    DWVW_24 = 0x0042
    DWVW_N = 0x0043

    DPCM_8 = 0x0050
    DPCM_16 = 0x0051

    VORBIS = 0x0060
    OPUS = 0x0064

    ALAC_16 = 0x0070
    ALAC_20 = 0x0071
    ALAC_24 = 0x0072
    ALAC_32 = 0x0073

    MPEG_LAYER_I = 0x0080
    MPEG_LAYER_II = 0x0081
    MPEG_LAYER_III = 0x0082

    # Main types
    WAV = 0x010000
    AIFF = 0x020000
    AU = 0x030000
    RAW = 0x040000
    PAF = 0x050000
    SVX = 0x060000
    NIST = 0x070000
    VOC = 0x080000

    IRCAM = 0x0A0000
    W64 = 0x0B0000
    MAT4 = 0x0C0000
    MAT5 = 0x0D0000
    PVF = 0x0E0000
    XI = 0x0F0000
    HTK = 0x100000
    SDS = 0x110000
    AVR = 0x120000
    WAVEX = 0x130000

    SD2 = 0x160000
    FLAC = 0x170000
    CAF = 0x180000
    WVE = 0x190000
    OGG = 0x200000
    MPC2K = 0x210000
    RF64 = 0x220000

  SFFormatMask* {.pure, size: sizeof(cint).} = enum
    SUBMASK = 0x0000FFFF
    TYPEMASK = 0x0FFF0000
    ENDMASK = 0x30000000

  # We put the endian-ness options in a a separate enum, because Nim enums
  # don't allow duplicate values and values must be increasing
  SFEndian* {.pure, size: sizeof(cint).} = enum
    FILE = 0x00000000
    LITTLE = 0x10000000
    BIG = 0x20000000
    CPU = 0x30000000

  SFStrType* {.pure, size: sizeof(cint).} = enum
    TITLE = 0x01
    COPYRIGHT = 0x02
    SOFTWARE = 0x03
    ARTIST = 0x04
    COMMENT = 0x05
    DATE = 0x06
    ALBUM = 0x07
    LICENSE = 0x08
    TRACKNUMBER = 0x09
    GENRE = 0x10

  SFChannelMode* {.pure, size: sizeof(cint).} = enum
    INVALID
    MONO
    LEFT
    RIGHT
    CENTER
    FRONT_LEFT
    FRONT_RIGHT
    FRONT_CENTER
    REAR_CENTER
    REAR_LEFT
    REAR_RIGHT
    LFE
    FRONT_LEFT_OF_CENTER
    FRONT_RIGHT_OF_CENTER
    SIDE_LEFT
    SIDE_RIGHT
    TOP_CENTER
    TOP_FRONT_LEFT
    TOP_FRONT_RIGHT
    TOP_FRONT_CENTER
    TOP_REAR_LEFT
    TOP_REAR_RIGHT
    TOP_REAR_CENTER
    AMBISONIC_B_W
    AMBISONIC_B_X
    AMBISONIC_B_Y
    AMBISONIC_B_Z
    MAX

  SFBitrateMode* {.pure, size: sizeof(cint).} = enum
    CONSTANT
    AVERAGE
    VARIABLE

  SFLoopMode* {.pure, size: sizeof(cint).} = enum
    NONE = 800
    FORWARD
    BACKWARD
    ALTERNATING

type
  SndFile* = distinct object

  SFCount* = int64

  SFInfo* = object
    frames*: SFCount
    samplerate*: cint
    channels*: cint
    format*: cint
    sections*: cint
    seekable*: cint

  SFFormatInfo* = object
    format*: cint
    name*: cstring
    extension*: cstring

  SFEmbedFileInfo* = object
    offset*: SFCount
    length*: SFCount

  SFCuePoint* = object
    indx*: int32
    position*: uint32
    fccChunk*: int32
    chunkStart*:int32
    blockStart*: int32
    sampleOffset*: uint32
    name*: array[256, char]

  SFLoop* = object
    mode*: SFLoopMode
    startPos*: uint32
    endPos*: uint32  # 'end' is a keyword in Nim
    count*: uint32

  SFInstrument* = object
    gain*: cint
    basenote*: byte
    detune*: byte
    velocityLo*: byte
    velocityHi*: byte
    keyLo*: byte
    keyHi*: byte
    loopCount*: cint
    loops*: array[16, SFLoop]

  SFLoopInfo* = object
    timeSigNum*: cshort
    timeSigDen*: cshort
    loopMode*: SFLoopMode
    numBeats*: cint
    bpm*: cfloat
    rootKey*: cint
    future*: array[6, cint]

  SFBroadcastInfo* = object
    description*: array[256, char]
    originator*: array[32, char]
    originatorReference*: array[32, char]
    originationDate*: array[10, char]
    originationTime*: array[8, char]
    timeReferenceLow*: uint32
    timeReferenceHigh*: uint32
    version*: cshort
    umid*: array[64, char]
    loudnessValue*: int16
    loudnessRange*: int16
    maxTruePeakLevel*: int16
    maxMomentaryLoudness*: int16
    maxShorttermLoudness*: int16
    reserved*: array[180, byte]
    codingHistorySize*: uint32
    codingHistory*: array[codingHistSize, char]

  SFCartTimer* = object
    usage*: array[4, char]
    value*: int32

  SFCartInfo* = object
    version*: array[4, char]
    title*: array[64, char]
    artist*: array[64, char]
    cutId*: array[64, char]
    clientId*: array[64, char]
    category*: array[64, char]
    classification*: array[64, char]
    outCue*: array[64, char]
    startDate*: array[10, char]
    startTime*: array[8, char]
    endDate*: array[10, char]
    endTime*: array[8, char]
    producerAppId*: array[64, char]
    producerAppVersion*: array[64, char]
    userDef*: array[64, char]
    levelReference*: int32
    postTimers*: array[8, SFCartTimer]
    reserved*: array[276, char]
    url*: array[1024, char]
    tagTextSize*: uint32
    tagText*: array[maxTagTextSize, char]


proc versionString*(): cstring {.libsnd, importc: "sf_version_string".}

proc open*(path: cstring, mode: SFMode, sfinfo: ptr SFInfo): ptr SndFile {.libsnd, importc: "sf_open".}
proc close*(sndfile: ptr SndFile): cint {.libsnd, importc: "sf_close", discardable.}

proc formatCheck*(info: ptr SFInfo): SFBool {.libsnd, importc: "sf_format_check".}

proc seek*(sndfile: ptr SndFile, frames: SFCount, whence: SFSeek): SFCount {.libsnd, importc: "sf_seek".}

proc command*(sndfile: ptr SndFile, cmd: SFCommand, data: pointer, datasize: cint): cint {.libsnd, importc: "sf_command", discardable.}

proc error*(sndfile: ptr SndFile): cint {.libsnd, importc: "sf_error".}
proc errorNumber*(errnum: int): cstring {.libsnd, importc: "sf_error_number".}
proc strError*(sndfile: ptr SndFile): cstring {.libsnd, importc: "sf_strerror".}

proc setString*(sndfile: ptr SndFile, str_type: SFStrType, str: cstring): cint {.libsnd, importc: "sf_set_string".}
proc getString*(sndfile: ptr SndFile, str_type: SFStrType): cstring {.libsnd, importc: "sf_get_string".}

proc currentByterate*(sndfile: ptr SndFile): cint {.libsnd, importc: "sf_current_byterate".}

proc readShort*(sndfile: ptr SndFile, buffer_ptr: ptr cshort, items: SFCount): SFCount {.libsnd, importc: "sf_read_short".}
proc readInt*(sndfile: ptr SndFile, buffer_ptr: ptr cint, items: SFCount): SFCount {.libsnd, importc: "sf_read_int".}
proc readFloat*(sndfile: ptr SndFile, buffer_ptr: ptr cfloat, items: SFCount): SFCount {.libsnd, importc: "sf_read_float".}
proc readDouble*(sndfile: ptr SndFile, buffer_ptr: ptr cdouble, items: SFCount): SFCount {.libsnd, importc: "sf_read_double".}

proc readFShort*(sndfile: ptr SndFile, buffer_ptr: ptr cshort, frames: SFCount): SFCount {.libsnd, importc: "sf_readf_short".}
proc readFInt*(sndfile: ptr SndFile, buffer_ptr: ptr cint, frames: SFCount): SFCount {.libsnd, importc: "sf_readf_int".}
proc readFFloat*(sndfile: ptr SndFile, buffer_ptr: ptr cfloat, frames: SFCount): SFCount {.libsnd, importc: "sf_readf_float".}
proc readFDouble*(sndfile: ptr SndFile, buffer_ptr: ptr cdouble, frames: SFCount): SFCount {.libsnd, importc: "sf_readf_double".}

proc writeShort*(sndfile: ptr SndFile, buffer_ptr: ptr cshort; items: SFCount): SFCount {.libsnd, importc: "sf_write_short".}
proc writeInt*(sndfile: ptr SndFile, buffer_ptr: ptr cint; items: SFCount): SFCount {.libsnd, importc: "sf_write_int".}
proc writeFloat*(sndfile: ptr SndFile, buffer_ptr: ptr cfloat; items: SFCount): SFCount {.libsnd, importc: "sf_write_float".}
proc writeDouble*(sndfile: ptr SndFile, buffer_ptr: ptr cdouble; items: SFCount): SFCount {.libsnd, importc: "sf_write_double".}

proc writeFShort*(sndfile: ptr SndFile, buffer_ptr: ptr cshort; frames: SFCount): SFCount {.libsnd, importc: "sf_writef_short".}
proc writeFInt*(sndfile: ptr SndFile, buffer_ptr: ptr cint; frames: SFCount): SFCount {.libsnd, importc: "sf_writef_int".}
proc writeFFloat*(sndfile: ptr SndFile, buffer_ptr: ptr cfloat; frames: SFCount): SFCount {.libsnd, importc: "sf_writef_float".}
proc writeFDouble*(sndfile: ptr SndFile, buffer_ptr: ptr cdouble; frames: SFCount): SFCount {.libsnd, importc: "sf_writef_double".}

proc writeSync*(sndfile: ptr SndFile) {.libsnd, importc: "sf_write_sync".}
