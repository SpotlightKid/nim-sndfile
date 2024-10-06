version = "0.1.0"
author = "Julien Aubert"
description = "Wrapper for libsndfile"
license = "MIT"

srcDir = "src"
skipDirs = @["examples"]

requires "nim >= 2.0"

taskrequires "examples", "sdl2"

task examples, "Build examples":
    setCommand("compile", "examples/playfile.nim")
