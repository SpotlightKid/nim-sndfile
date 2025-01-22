## Read an audio file (e.g. WAV or Ogg Vorbis) with libsndfile and play it via JACK

import std/[logging, os, strformat]

import jacket
import libsamplerate
import signal
import sndfile

const
  MaxChannels = 2
  Gain = 0.8

var
  jclient: Client
  outPortL, outPortR: Port
  status: cint
  exitSignalled: bool = false
  log = newConsoleLogger(when defined(release): lvlInfo else: lvlDebug)

type
  Sample = DefaultAudioSample
  SampleBuffer = ptr UncheckedArray[Sample]
  AudioFile = object
    channels: int
    samplerate: int
    samples: SampleBuffer
    frames: int
    pos: int


proc cleanup() =
  debug "Cleaning up..."
  if jclient != nil:
    jclient.deactivate()
    jclient.clientClose()
    jclient = nil

proc errorCb(msg: cstring) {.cdecl.} =
  # Suppress verbose JACK error messages when server is not available by
  # default. Pass ``lvlAll`` when creating the logger to enable them.
  debug "JACK error: " & $msg

proc signalCb(sig: cint) {.noconv.} =
  debug "Received signal: " & $sig
  exitSignalled = true

proc shutdownCb(arg: pointer = nil) {.cdecl.} =
  warn "JACK server has shut down."
  exitSignalled = true

proc readAudio(filename: string): AudioFile =
  var info: SFInfo
  var sf = sndfile.open(filename.cstring, SFMode.READ, info.addr)

  if sf.isNil:
    echo $sf.strError()
    quit QuitFailure

  defer: sf.close()

  if info.channels > MaxChannels:
    raise newException(ValueError, "Only mono or stereo files are suported.")

  let samples = createSharedU(Sample, info.frames * info.channels)

  if samples.isNil:
    raise newException(ResourceExhaustedError, "Error allocating memory for sample buffer")

  var samplesRead = sf.readFFloat(samples, info.frames)

  if samplesRead != info.frames:
    warn "Mismatch between # samples read (as returned by sf_readf_float) and info.frames:"
    warn &"{samplesRead} != {info.frames}"

  result.frames = if samplesRead != 0: samplesRead else: info.frames
  result.samples = cast[SampleBuffer](samples)
  result.channels = info.channels
  result.samplerate = info.samplerate
  result.pos = 0

proc convertSampleRate(input: SampleBuffer, inputSamples, inputRate, outputRate, channels: int): tuple[samples: SampleBuffer, frames: int] =
  var
    data: SrcData
    # Calculate the number of output frames
    outputFrames = int(inputSamples * outputRate / inputRate)

  var output = createSharedU(Sample, outputFrames * channels)

  if output.isNil:
    raise newException(ResourceExhaustedError, "Error allocating memory for resample buffer")

  # Set up the SRC_DATA structure
  data.dataIn = cast[ptr UncheckedArray[cfloat]](input)
  data.inputFrames = inputSamples.clong
  data.dataOut = cast[ptr UncheckedArray[cfloat]](output)
  data.outputFrames = outputFrames.clong
  data.srcRatio = float64(outputRate / inputRate)
  data.endOfInput = 0

  # Perform the sample rate conversion
  var error = srcSimple(addr data, SINC_FASTEST, channels.cint)
  if error != 0:
    freeShared(output)
    raise newException(IOError, &"Error during sample rate conversion: {srcStrError(error)}")
  else:
    # Set output values
    result.samples = cast[SampleBuffer](output)
    result.frames = data.outputFramesGen.int

proc processCb(nFrames: NFrames, arg: pointer): cint {.cdecl.} =
  var outL = cast[SampleBuffer](portGetBuffer(outPortL, nFrames))
  var outR = cast[SampleBuffer](portGetBuffer(outPortR, nFrames))
  let audio = cast[ptr AudioFile](arg)

  for i in 0 ..< nFrames:
    outL[i] = audio.samples[audio.pos] * Gain
    if audio.channels == 1:
      outR[i] = audio.samples[audio.pos] * Gain
    else:
      outR[i] = audio.samples[audio.pos + 1] * Gain

    audio.pos += audio.channels

    if audio.pos >= audio.frames * audio.channels:
      audio.pos = 0

  return 0


proc main() =
  addHandler(log)

  if paramCount() != 1:
    echo "Usage: playfile_jacket <filename>"
    quit(QuitFailure)

  # Print libsndfile version
  echo &"libsdnfile version: {versionString()}"
  # Print JACK version
  echo &"JACK version: {getVersionString()}"

  # Create JACK client
  setErrorFunction(errorCb)
  jclient = clientOpen("playfile_jack", NullOption, status.addr)
  debug &"JACK server status: {status}"

  if jclient == nil:
    error getJackStatusErrorString(status)
    quit QuitFailure

  var audio: AudioFile

  try:
    audio = readAudio(paramStr(1))
  except CatchableError:
    error getCurrentExceptionMsg()
    cleanup()
    quit QuitFailure

  defer:
    cleanup()
    freeShared(audio.samples)

  echo &"Channels: {audio.channels}"
  echo &"Samplerate: {audio.samplerate}"
  echo &"Frames: {audio.frames}"

  var jackSampleRate = int(jclient.getSamplerate())

  if audio.samplerate != jackSampleRate:
    echo &"Resampling audio to {jackSampleRate} Hz ..."
    try:
      var resampled = convertSampleRate(audio.samples, audio.frames, audio.samplerate, jackSampleRate, audio.channels)
      freeShared(audio.samples)
      audio.samples = resampled.samples
      audio.frames = resampled.frames
    except CatchableError:
      error getCurrentExceptionMsg()
      quit QuitFailure
    echo "Ready."

  # Set up signal handlers to clean up on exit
  when defined(windows):
    setSignalProc(signalCb, SIGABRT, SIGINT, SIGTERM)
  else:
    setSignalProc(signalCb, SIGABRT, SIGHUP, SIGINT, SIGQUIT, SIGTERM)

  # Register JACK callbacks
  if jclient.setProcessCallback(processCb, audio.addr) != 0:
    error "Could not set JACK process callback function."
    quit QuitFailure

  jclient.onShutdown(shutdownCb)

  # Create output ports
  outPortL = jclient.portRegister("out_1", JackDefaultAudioType, PortIsOutput, 0)
  outPortR = jclient.portRegister("out_2", JackDefaultAudioType, PortIsOutput, 0)

  # Activate JACK client ...
  if jclient.activate() == 0:
    # Connect our output ports to system playback ports
    jclient.connect(outPortL.portName(), "system:playback_1")
    jclient.connect(outPortR.portName(), "system:playback_2")

    # ... and keep running until a signal is received
    while not exitSignalled:
        sleep(50)


main()
