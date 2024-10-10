# Read a audio file (e.g. WAV or Ogg Vorbis) with libsndfile and play it with sdl2

import std/[math, os, strformat]

import sndfile
import sdl2, sdl2/audio

if paramCount() != 1:
  echo("Usage: playfile <filename>")
  quit(-1)
var
  filename = paramStr(1)

# Get libsndfile version
echo(&"libsdnfile version: {version_string()}")

# Get SDL version
var version: SDL_Version
sdl2.getVersion(version)
echo(&"SDL version: {version.major}.{version.minor}.{version.patch}")

# Open the file
var info: SFInfo
var file = sndfile.open(filename.cstring, SFMode.READ, info.addr)

if file == nil:
  echo $file.strerror()
  quit(QuitFailure)

echo &"Channels: {info.channels}"
echo &"Frames: {info.frames}"
echo &"Samplerate: {info.samplerate}"
echo &"Format: {info.format}"

# Callback procedure for audio playback

const bufferSizeInSamples = 4096

proc audioCallback(userdata: pointer; stream: ptr uint8; len: cint) {.cdecl.} =
  var buffer: array[bufferSizeInSamples, cfloat]
  let count = file.readFloat(addr buffer[0], bufferSizeInSamples)

  if count == 0:
    echo("End of file reached")
    quit(0)

  for i in 0..count - 1:
    cast[ptr int16](cast[int](stream) + i * 2)[] = int16(round(buffer[i] * 0.8 * 32760))
    # Without the factor of 0.8, the sound gets distorted for my ogg example file

# Init audio playback

if sdl2.init(INIT_AUDIO) != SdlSuccess:
  echo("Couldn't initialize SDL")
  quit(QuitFailure)

var aspec: AudioSpec
aspec.freq = info.samplerate
aspec.format = AUDIO_S16
aspec.channels = info.channels.uint8
aspec.samples = bufferSizeInSamples
aspec.padding = 0
aspec.callback = audioCallback
aspec.userdata = nil

if openAudio(addr aspec, nil) != 0:
  echo(&"Couldn't open audio device: {getError()}")
  quit(QuitFailure)

# Start playback and wait in a loop
pauseAudio(0)
echo("Playing...")

while true:
  delay(100)
