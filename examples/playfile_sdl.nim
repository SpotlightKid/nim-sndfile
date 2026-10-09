## Read an audio file (e.g. WAV or Ogg Vorbis) with libsndfile and play it with sdl2

import std/[math, os, strformat]

import sndfile
import sdl2, sdl2/audio

if paramCount() != 1:
  echo "Usage: playfile <filename>"
  quit(QuitFailure)

var filename = paramStr(1)

# Print libsndfile version
echo &"libsndfile version: {versionString()}"

# Print SDL version
var version: SDL_Version
sdl2.getVersion(version)
echo &"SDL version: {version.major}.{version.minor}.{version.patch}"

# Open the file
var info: SFInfo
var file = sndfile.open(filename.cstring, SFMode.READ, info.addr)

if file.isNil:
  echo $file.strerror()
  quit(QuitFailure)

echo &"Channels: {info.channels}"
echo &"Frames: {info.frames}"
echo &"Samplerate: {info.samplerate}"
echo &"Format: {info.format}"

# Callback procedure for audio playback
# Renamed constant to bufferSizeInFrames to accurately reflect SDL's audio spec terminology.
# SDL requests audio in "frames" (where 1 frame = number of channels * samples per channel).
const bufferSizeInFrames = 4096

proc audioCallback(userdata: pointer; stream: ptr uint8; len: cint) {.cdecl.} =
  # Increased buffer size to safely handle stereo files. 
  # For a stereo file, SDL requests 4096 frames * 2 channels = 8192 samples.
  var buffer: array[bufferSizeInFrames * 2, cfloat]
  
  # Calculate the exact number of int16 samples requested by SDL in this callback.
  # The 'len' parameter is the buffer size in bytes.
  let requestedSamples = len div sizeof(int16)
  let count = file.readFloat(addr buffer[0], requestedSamples)

  if count == 0:
    echo "End of file reached"
    quit(0)

  # Replaced invalid C-style pointer arithmetic (`stream + i * 2`) 
  # with modern Nim `UncheckedArray` cast. This is the safe and idiomatic way 
  # to index into a raw pointer buffer in modern Nim, preventing compilation errors.
  let outStream = cast[ptr UncheckedArray[int16]](stream)
  
  for i in 0..<count:
    outStream[i] = int16(round(buffer[i] * 0.8 * 32760.0))
    # Without the factor of 0.8, the sound gets distorted for my ogg example file

# Init audio playback
if sdl2.init(INIT_AUDIO) != SdlSuccess:
  echo "Couldn't initialize SDL"
  quit(QuitFailure)

var aspec: AudioSpec
aspec.freq = info.samplerate
aspec.format = AUDIO_S16
aspec.channels = info.channels.uint8
aspec.samples = bufferSizeInFrames
aspec.padding = 0
aspec.callback = audioCallback
aspec.userdata = nil

if openAudio(addr aspec, nil) != 0:
  echo &"Couldn't open audio device: {getError()}"
  quit(QuitFailure)

# Start playback and wait in a loop
pauseAudio(0)
echo "Playing..."

while true:
  delay(100)
