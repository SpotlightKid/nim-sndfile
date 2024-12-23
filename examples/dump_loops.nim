## Read an audio sample file and print information about defined sample loops

import std/[os, strformat]

import sndfile


proc main() =
  if paramCount() != 1:
    echo "Usage: dump_loops <filename>"
    quit(QuitFailure)

  var filename = paramStr(1)

  # Open the file
  var info: SFInfo
  var sf = sndfile.open(filename.cstring, SFMode.READ, info.addr)

  if sf.isNil:
    echo $sf.strerror()
    quit(QuitFailure)

  echo &"File: {filename}"
  echo &"Sample frames: {info.frames}"

  var instr = SFInstrument()

  if SFBool(command(sf, GET_INSTRUMENT, instr.addr, sizeof(instr).cint)) == FALSE:
    echo "Loops: no instrument data found"
    quit(QuitSuccess)
  else:
    echo &"Root note: {instr.basenote}"
    echo &"Loops: {instr.loopCount}"

  for i in 0..<instr.loopCount:
    # endPos is the first sample position *after* the loop!
    stdOut.write &"* #{i}: start={instr.loops[i].startPos}, "
    stdOut.write &"end={instr.loops[i].endPos - 1}, "
    stdOut.write &"mode={instr.loops[i].mode}, "
    stdOut.write &"count={instr.loops[i].count}\n"

  sf.close()


main()
