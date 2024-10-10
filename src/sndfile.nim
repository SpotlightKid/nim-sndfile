when defined(windows):
  const soname = "libsndfile(|-1|-2).dll"
elif defined(macosx):
  const soname = "libsndfile.dylib"
else:
  const soname = "libsndfile.so(|.1)"

{.pragma: libsnd, cdecl, dynlib: soname.}

type
  TSNDFILE* = cint

  TFILE_MODE* = enum
    READ = cint(0x10),
    WRITE = cint(0x20),
    RDWR = cint(0x30)

  TCOUNT* = int64

  TINFO* {.pure final.} = object
    frames*: TCOUNT
    samplerate*: cint
    channels*: cint
    format*: cint
    sections*: cint
    seekable*: cint

  TBOOL* = enum
    SF_FALSE = 0
    SF_TRUE = 1

  TWHENCE* = enum
    SEEK_SET = 0  # The offset is set to the start of the audio data plus offset (multichannel) frames.
    SEEK_CUR = 1  # The offset is set to its current location plus offset (multichannel) frames.
    SEEK_END = 2  # The offset is set to the end of the data plus offset (multichannel) frames.

  TCOMMAND* = enum
    SFC_GET_LIB_VERSION = 0x1000
    SFC_GET_LOG_INFO = 0x1001
    SFC_GET_CURRENT_SF_INFO = 0x1002
    SFC_GET_NORM_DOUBLE = 0x1010
    SFC_GET_NORM_FLOAT = 0x1011
    SFC_SET_NORM_DOUBLE = 0x1012
    SFC_SET_NORM_FLOAT = 0x1013
    SFC_SET_SCALE_FLOAT_INT_READ = 0x1014
    SFC_SET_SCALE_INT_FLOAT_WRITE = 0x1015
    SFC_GET_SIMPLE_FORMAT_COUNT = 0x1020
    SFC_GET_SIMPLE_FORMAT = 0x1021
    SFC_GET_FORMAT_INFO = 0x1028
    SFC_GET_FORMAT_MAJOR_COUNT = 0x1030
    SFC_GET_FORMAT_MAJOR = 0x1031
    SFC_GET_FORMAT_SUBTYPE_COUNT = 0x1032
    SFC_GET_FORMAT_SUBTYPE = 0x1033
    SFC_CALC_SIGNAL_MAX = 0x1040
    SFC_CALC_NORM_SIGNAL_MAX = 0x1041
    SFC_CALC_MAX_ALL_CHANNELS = 0x1042
    SFC_CALC_NORM_MAX_ALL_CHANNELS = 0x1043
    SFC_GET_SIGNAL_MAX = 0x1044
    SFC_GET_MAX_ALL_CHANNELS = 0x1045
    SFC_SET_ADD_PEAK_CHUNK = 0x1050
    SFC_SET_ADD_HEADER_PAD_CHUNK = 0x1051
    SFC_UPDATE_HEADER_NOW = 0x1060
    SFC_SET_UPDATE_HEADER_AUTO = 0x1061
    SFC_FILE_TRUNCATE = 0x1080
    SFC_SET_RAW_START_OFFSET = 0x1090
    SFC_SET_DITHER_ON_WRITE = 0x10A0
    SFC_SET_DITHER_ON_READ = 0x10A1
    SFC_GET_DITHER_INFO_COUNT = 0x10A2
    SFC_GET_DITHER_INFO = 0x10A3
    SFC_GET_EMBED_FILE_INFO = 0x10B0
    SFC_SET_CLIPPING = 0x10C0
    SFC_GET_CLIPPING = 0x10C1
    SFC_GET_INSTRUMENT = 0x10D0
    SFC_SET_INSTRUMENT = 0x10D1
    SFC_GET_LOOP_INFO = 0x10E0
    SFC_GET_BROADCAST_INFO = 0x10F0
    SFC_SET_BROADCAST_INFO = 0x10F1
    SFC_GET_CHANNEL_MAP_INFO = 0x1100
    SFC_SET_CHANNEL_MAP_INFO = 0x1101
    SFC_RAW_DATA_NEEDS_ENDSWAP = 0x1110
    SFC_WAVEX_SET_AMBISONIC = 0x1200
    SFC_WAVEX_GET_AMBISONIC = 0x1201
    SFC_SET_VBR_ENCODING_QUALITY = 0x1300

  TFORMAT* = enum
    # Ordering is enforced in the num so it looks different to source
    SF_ENDIAN_FILE = 0x00000000   # Default file endian-ness. */

    # Subtypes from here on. */
    SF_FORMAT_PCM_S8 = 0x0001     # Signed 8 bit data */
    SF_FORMAT_PCM_16 = 0x0002     # Signed 16 bit data */
    SF_FORMAT_PCM_24 = 0x0003     # Signed 24 bit data */
    SF_FORMAT_PCM_32 = 0x0004     # Signed 32 bit data */

    SF_FORMAT_PCM_U8 = 0x0005     # Unsigned 8 bit data (WAV and RAW only) */

    SF_FORMAT_FLOAT = 0x0006      # 32 bit float data */
    SF_FORMAT_DOUBLE = 0x0007     # 64 bit float data */

    SF_FORMAT_ULAW = 0x0010       # U-Law encoded. */
    SF_FORMAT_ALAW = 0x0011       # A-Law encoded. */
    SF_FORMAT_IMA_ADPCM = 0x0012  # IMA ADPCM. */
    SF_FORMAT_MS_ADPCM = 0x0013   # Microsoft ADPCM. */

    SF_FORMAT_GSM610 = 0x0020     # GSM 6.10 encoding. */
    SF_FORMAT_VOX_ADPCM = 0x0021  # Oki Dialogic ADPCM encoding. */

    SF_FORMAT_G721_32 = 0x0030    # 32kbs G721 ADPCM encoding. */
    SF_FORMAT_G723_24 = 0x0031    # 24kbs G723 ADPCM encoding. */
    SF_FORMAT_G723_40 = 0x0032    # 40kbs G723 ADPCM encoding. */

    SF_FORMAT_DWVW_12 = 0x0040    # 12 bit Delta Width Variable Word encoding. */
    SF_FORMAT_DWVW_16 = 0x0041    # 16 bit Delta Width Variable Word encoding. */
    SF_FORMAT_DWVW_24 = 0x0042    # 24 bit Delta Width Variable Word encoding. */
    SF_FORMAT_DWVW_N = 0x0043     # N bit Delta Width Variable Word encoding. */

    SF_FORMAT_DPCM_8 = 0x0050     # 8 bit differential PCM (XI only) */
    SF_FORMAT_DPCM_16 = 0x0051    # 16 bit differential PCM (XI only) */

    SF_FORMAT_VORBIS = 0x0060     # Xiph Vorbis encoding. */

    SF_FORMAT_SUBMASK = 0x0000FFFF
    # Main types
    SF_FORMAT_WAV = 0x010000      # Microsoft WAV format (little endian). */
    SF_FORMAT_AIFF = 0x020000     # Apple/SGI AIFF format (big endian). */
    SF_FORMAT_AU = 0x030000       # Sun/NeXT AU format (big endian). */
    SF_FORMAT_RAW = 0x040000      # RAW PCM data. */
    SF_FORMAT_PAF = 0x050000      # Ensoniq PARIS file format. */
    SF_FORMAT_SVX = 0x060000      # Amiga IFF / SVX8 / SV16 format. */
    SF_FORMAT_NIST = 0x070000     # Sphere NIST format. */
    SF_FORMAT_VOC = 0x080000      # VOC files. */
    SF_FORMAT_IRCAM = 0x0A0000    # Berkeley/IRCAM/CARL */
    SF_FORMAT_W64 = 0x0B0000      # Sonic Foundry's 64 bit RIFF/WAV */
    SF_FORMAT_MAT4 = 0x0C0000     # Matlab (tm) V4.2 / GNU Octave 2.0 */
    SF_FORMAT_MAT5 = 0x0D0000     # Matlab (tm) V5.0 / GNU Octave 2.1 */
    SF_FORMAT_PVF = 0x0E0000      # Portable Voice Format */
    SF_FORMAT_XI = 0x0F0000       # Fasttracker 2 Extended Instrument */
    SF_FORMAT_HTK = 0x100000      # HMM Tool Kit format */
    SF_FORMAT_SDS = 0x110000      # Midi Sample Dump Standard */
    SF_FORMAT_AVR = 0x120000      # Audio Visual Research */
    SF_FORMAT_WAVEX = 0x130000    # MS WAVE with WAVEFORMATEX */
    SF_FORMAT_SD2 = 0x160000      # Sound Designer 2 */
    SF_FORMAT_FLAC = 0x170000     # FLAC lossless file format */
    SF_FORMAT_CAF = 0x180000      # Core Audio File format */
    SF_FORMAT_WVE = 0x190000      # Psion WVE format */
    SF_FORMAT_OGG = 0x200000      # Xiph OGG container */
    SF_FORMAT_MPC2K = 0x210000    # Akai MPC 2000 sampler */
    SF_FORMAT_RF64 = 0x220000     # RF64 WAV file */
    SF_FORMAT_TYPEMASK = 0x0FFF0000

    # Endian-ness options. */
    SF_ENDIAN_LITTLE = 0x10000000  # Force little endian-ness. */
    SF_ENDIAN_BIG = 0x20000000     # Force big endian-ness. */
    SF_ENDIAN_CPU = 0x30000000     # Force CPU endian-ness. */

  TENDIAN* = enum
    # because nim enums don't allow duplicate values
    SF_FORMAT_ENDMASK = 0x30000000

proc version_string*(): cstring {.libsnd, importc: "sf_version_string".}

proc open*(path: cstring, mode: TFILE_MODE, sfinfo: ptr TINFO): ptr TSNDFILE {.libsnd, importc: "sf_open".}

proc close*(sndfile: ptr TSNDFILE): ptr TSNDFILE {.libsnd, importc: "sf_close".}

proc format_check*(info: ptr TINFO): TBOOL {.libsnd, importc: "sf_format_check".}

proc seek*(sndfile: ptr TSNDFILE, frames: TCOUNT, whence: TWHENCE): TCOUNT {.libsnd, importc: "sf_seek".}

proc command*(sndfile: ptr TSNDFILE, cmd: TCOMMAND, data: pointer, datasize: cint): cint {.libsnd, importc: "sf_command".}

proc error*(sndfile: ptr TSNDFILE): cint {.libsnd, importc: "sf_error".}

proc strerror*(sndfile: ptr TSNDFILE): cstring {.libsnd, importc: "sf_strerror".}

proc read_short*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cshort, items: TCOUNT): TCOUNT {.libsnd, importc: "sf_read_short".}
proc read_int*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cint, items: TCOUNT): TCOUNT {.libsnd, importc: "sf_read_int".}
proc read_float*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cfloat, items: TCOUNT): TCOUNT {.libsnd, importc: "sf_read_float".}
proc read_double*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cdouble, items: TCOUNT): TCOUNT {.libsnd, importc: "sf_read_double".}

proc readf_short*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cshort, items: TCOUNT): TCOUNT {.libsnd, importc: "sf_readf_short".}
proc readf_int*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cint, items: TCOUNT): TCOUNT {.libsnd, importc: "sf_readf_int".}
proc readf_float*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cfloat, items: TCOUNT): TCOUNT {.libsnd, importc: "sf_readf_float".}
proc readf_double*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cdouble, items: TCOUNT): TCOUNT {.libsnd, importc: "sf_readf_double".}

proc write_short*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cshort; items: TCOUNT): TCOUNT {.libsnd, importc: "sf_write_short".}
proc write_int*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cint; items: TCOUNT): TCOUNT {.libsnd, importc: "sf_write_int".}
proc write_float*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cfloat; items: TCOUNT): TCOUNT {.libsnd, importc: "sf_write_float".}
proc write_double*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cdouble; items: TCOUNT): TCOUNT {.libsnd, importc: "sf_write_double".}

proc writef_short*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cshort; items: TCOUNT): TCOUNT {.libsnd, importc: "sf_writef_short".}
proc writef_int*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cint; items: TCOUNT): TCOUNT {.libsnd, importc: "sf_writef_int".}
proc writef_float*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cfloat; items: TCOUNT): TCOUNT {.libsnd, importc: "sf_writef_float".}
proc writef_double*(sndfile: ptr TSNDFILE, buffer_ptr: ptr cdouble; items: TCOUNT): TCOUNT {.libsnd, importc: "sf_writef_double".}

when isMainModule:
  var info: TINFO
  var sndfile: ptr TSNDFILE
  info.format = 0

  snd_file = open("test.wav", READ, cast[ptr TINFO](info.addr))

  echo info
  # expect info to match snd file header
  echo format_check(cast[ptr TINFO](info.addr))

  # expect 5
  echo seek(snd_file, 5, SEEK_SET)
  discard seek(snd_File, 0, SEEK_SET)

  let num_items = cast[cint](info.channels * info.frames)
  echo num_items
  var buffer = newSeq[cint](num_items)
  let items_read = read_int(snd_file, buffer[0].addr, num_items)
  echo items_read
