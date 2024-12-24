import std/[os, unittest]

import sndfile


proc check_smpl_chunk(
    sf: ptr SndFile,
    manufacturer: array[4, byte],
    samplePeriod: int32,
    midiUnityNote: int32,
    samplerDataLen: int32,
    loopCount: int32,
    loopType: int32,
    startPos: int32,
    endPos: int32
  ): bool =
  var found = 0

  for chunk in sf.chunks("smpl"):
    found += 1
    check(typeof(chunk) is seq[byte])

    if found == 1:
      # Only check the first 'smpl' chunk - there should be only one.
      var smpl = cast[ptr SmplChunk](chunk[0].addr)

      check(smpl.manufacturer == manufacturer)
      check(smpl.samplePeriod == samplePeriod)
      check(smpl.midiUnityNote == midiUnityNote)
      check(smpl.samplerDataLen == samplerDataLen)

      check(smpl.loopCount == loopCount)
      check(smpl.loops[0].loopType == loopType)
      check(smpl.loops[0].startPos == startPos)
      check(smpl.loops[0].endPos == endPos)

      let expectedSize = sizeof(SmplChunk) + smpl.samplerDataLen + smpl.loopCount * sizeof(SmplLoop)
      check(chunk.len == expectedSize)

  return found == 1


suite "Tests for reading chunks from a WAV file":
  test "test read smpl chunk":
    var info: SFInfo
    var sf: ptr SndFile
    info.format = 0

    sf = open(cstring(getAppDir() / "test_chunks.wav"), READ, info.addr)
    check(not sf.isNil)
    defer: close(sf)

    check(
      check_smpl_chunk(
        sf,
        manufacturer = [0x47.byte, 0, 0, 1],
        samplePeriod = 22675,
        midiUnityNote = 1,
        samplerDataLen = 18,
        loopCount = 1,
        loopType = 0,
        startPos = 56252,
        endPos = 240748
      )
    )

  test "test write and read back smpl chunk":
    var infoIn, infoOut: SFInfo
    var sfIn, sfOut: ptr SndFile
    infoIn.format = 0

    sfIn = open(cstring(getAppDir() / "sine.wav"), READ, infoIn.addr)
    check(not sfIn.isNil)

    infoOut = infoIn
    sfOut = open(cstring(getAppDir() / "sineloop.wav"), WRITE, infoOut.addr)
    check(not sfOut.isNil)

    var ci = SFChunkInfo()
    ci.id[0..3] = "smpl"
    ci.idSize = 4
    ci.dataLen = sizeof(SmplChunk) + sizeof(SmplLoop)
    ci.data = cast[ptr UncheckedArray[byte]](alloc0(ci.dataLen))

    var smpl = cast[ptr SmplChunk](ci.data)
    smpl.manufacturer = [1.byte, 0, 0, 1]
    smpl.samplePeriod = int32(1_000_000_000 / infoIn.samplerate)
    smpl.midiUnityNote = 67
    smpl.loopCount = 1

    var loop = cast[ptr SmplLoop](smpl.loops[0].addr)
    loop.startPos = 0
    loop.endPos = infoIn.frames.int32

    check(sfOut.setChunk(ci.addr) == NO_ERROR)

    var
      frames, readcount: cint
      buf: array[1024, cfloat]

    frames = cint(1024 / infoOut.channels)
    readcount = frames

    while readcount > 0:
      readcount = sfIn.readFFloat(buf[0].addr, frames).cint
      discard sfOut.writeFFLoat(buf[0].addr, readcount)

    sfIn.close()
    sfOut.close()
    dealloc(ci.data)

    infoIn.format = 0
    sfIn = open(cstring(getAppDir() / "sineloop.wav"), READ, infoIn.addr)
    check(not sfIn.isNil)

    check(
      check_smpl_chunk(
        sfIn,
        manufacturer = [1.byte, 0, 0, 1],
        samplePeriod = 20833,
        midiUnityNote = 67,
        samplerDataLen = 0,
        loopCount = 1,
        loopType = 0,
        startPos = 0,
        endPos = 48_000
      )
    )

    sfIn.close()
