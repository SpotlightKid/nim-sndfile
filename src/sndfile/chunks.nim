import api

# Data types for WAV file 'smpl' chunks
type
  ## A single sample loop
  SmplLoop* = object
    id*: int32
    loopType*: int32
    startPos*: int32
    endPos*: int32
    fraction*: int32
    playCount*: int32

  ## A 'smpl' chunk, containing information for sample player instruments,
  ## such as manufacturer and product ID of the instrument that is meant
  ## to use this sample, the MIDI root note, zero or more sample loop
  ## definitions and, optionally, extra sample player specific data.
  SmplChunk* = object
    manufacturer*: array[4, byte]
    product*: int32
    samplePeriod*: int32
    midiUnityNote*: int32
    midiPitchFraction*: int32
    smpteFormat*: int32
    smpteOffset*: int32
    loopCount*: int32
    samplerDataLen*: int32
    loops*: UncheckedArray[SmplLoop]


##
## Iterate over all chunks in the audio file, whose chunk ID starts with
## `chunk_id`. The loop variable is assigned a `seq[byte]` with the data of
## each matching chunk.
##
iterator chunks*(sndfile: ptr SndFile, chunk_id: string): seq[byte] =
  var chunkInfo = SFChunkInfo()

  if chunk_id.len - 1 > chunkInfo.id.high:
    raise newException(ValueError, "Length of chunk_id must be <= 64.")

  chunkInfo.idSize = chunk_id.len.cuint
  chunkInfo.id[0..<chunk_id.len] = chunk_id

  var it = getChunkIterator(sndfile, chunkInfo.addr)

  while not it.isNil:
    var data = newSeq[byte]()

    if getChunkSize(it, chunkInfo.addr) == NO_ERROR and chunkInfo.dataLen > 0:
      data.setLen(chunkInfo.dataLen)
      chunkInfo.data = cast[ptr UncheckedArray[byte]](data[0].addr)

      if getChunkData(it, chunkInfo.addr) != NO_ERROR:
        # XXX Better exception type and error message
        raise newException(IOError, "Could not read next chunk.")
    else:
      raise newException(IOError, "Could not get chunk size.")

    yield data
    it = nextChunkIterator(it)
