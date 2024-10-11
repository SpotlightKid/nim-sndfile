import std/strformat
import sndfile

var
  sfinfo: SFInfo
  fmtinfo: SFFormatInfo
  major_count, subtype_count: cint

echo &"Version: {versionString()}\n"

command(nil, GET_FORMAT_MAJOR_COUNT, major_count.addr, sizeof(cint).cint)
command(nil, GET_FORMAT_SUBTYPE_COUNT, subtype_count.addr, sizeof(cint).cint)

sfinfo.channels = 1

for major_format in  0..<major_count:
  fmtinfo.format = major_format.cint
  command(nil, GET_FORMAT_MAJOR, fmtinfo.addr, sizeof(fmtinfo).cint)
  echo &"{fmtinfo.name} (extension \".{fmtinfo.extension}\")"

  var format = fmtinfo.format

  for subtype in 0..<subtype_count:
    fmtinfo.format = subtype.cint
    command(nil, GET_FORMAT_SUBTYPE, fmtinfo.addr, sizeof(fmtinfo).cint) ;

    format = (format and SFFormatMask.TYPEMASK.cint) or fmtinfo.format
    sfinfo.format = format

    if formatCheck(sfinfo.addr) == TRUE:
      if not fmtinfo.extension.isNil:
        echo &"   {fmtinfo.name} (extension \".{fmtinfo.extension}\")"
      else:
        echo &"   {fmtinfo.name}"
