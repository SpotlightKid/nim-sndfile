version = "0.1.0"
author = "Julien Aubert"
description = "Wrapper for libsndfile"
license = "MIT"

srcDir = "src"
skipDirs = @["examples"]

requires "nim >= 2.0"

taskrequires "examples", "sdl2"

task examples, "Build examples":
    selfExec("compile examples/playfile_sdl.nim")
    selfExec("compile examples/list_formats.nim")
