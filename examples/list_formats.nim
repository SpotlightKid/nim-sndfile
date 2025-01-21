## List all file and sample formats supported by the used libsndfile

import std/strformat
import sndfile

var
  sfinfo: SFInfo
  fmtinfo: SFFormatInfo
  simpleCount, majorCount, subtypeCount: cint

echo &"Version: {versionString()}\n"

command(nil, GET_SIMPLE_FORMAT_COUNT, simpleCount.addr, sizeof(cint).cint)
command(nil, GET_FORMAT_MAJOR_COUNT, majorCount.addr, sizeof(cint).cint)
command(nil, GET_FORMAT_SUBTYPE_COUNT, subtypeCount.addr, sizeof(cint).cint)


for format in  0..<simpleCount:
  fmtinfo.format = format.cint
  command(nil, GET_SIMPLE_FORMAT, fmtinfo.addr, sizeof(fmtinfo).cint)
  echo &"{fmtinfo.name} (extension: '.{fmtinfo.extension}')"

sfinfo.samplerate = 48000

for major_format in  0..<major_count:
  fmtinfo.format = major_format.cint
  command(nil, GET_FORMAT_MAJOR, fmtinfo.addr, sizeof(fmtinfo).cint)
  echo &"{fmtinfo.name} (extension '.{fmtinfo.extension}')"

  var format = fmtinfo.format

  for subtype in 0..<subtype_count:
    fmtinfo.format = subtype.cint
    command(nil, GET_FORMAT_SUBTYPE, fmtinfo.addr, sizeof(fmtinfo).cint) ;

    format = (format and SFFormatMask.TYPEMASK.cint) or fmtinfo.format
    sfinfo.format = format
    var valid = false
    sfinfo.channels = 1

    if formatCheck(sfinfo.addr) == TRUE:
      valid = true

    sfinfo.channels = 2

    if formatCheck(sfinfo.addr) == TRUE:
      valid = true

    if valid:
      if fmtinfo.extension.isNil:
        echo &"   {fmtinfo.name}"
      else:
        echo &"   {fmtinfo.name} (extension '.{fmtinfo.extension}')"
