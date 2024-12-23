import std/[os, unittest]

import sndfile

suite "Tests for reading a simple WAV file":
  test "test reading info":
    var info: SFInfo
    var sndFile: ptr SndFile
    info.format = 0

    sndFile = open(cstring(getAppDir() / "sine.wav"), READ, info.addr)
    check(not sndFile.isNil)

    # expect info read from sound file header to be valid
    check(formatCheck(info.addr) == TRUE)

    check($info == "(frames: 48000, samplerate: 48000, channels: 1, format: 65538, sections: 1, seekable: 1)")

    check(seek(sndFile, 5, SFSeek.SET) == 5)
    discard seek(sndFile, 0, SFSeek.SET)

    let num_items = info.channels * info.frames
    check(num_items == 48_000)

    var buffer = newSeq[cint](num_items)
    let items_read = read_int(sndFile, buffer[0].addr, num_items)
    check(items_read == 48_000)

    close(sndFile)
