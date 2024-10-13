version = "0.2.0"
author = "Julien Aubert, Christopher Arndt"
description = "Wrapper for libsndfile"
license = "MIT"

srcDir = "src"
skipDirs = @["examples"]

requires "nim >= 2.0"

taskrequires "examples", "sdl2"
taskrequires "examples_debug", "sdl2"

let examples = @[
    "list_formats",
    "playfile_sdl",
]

task examples, "Build examples (release)":
    for example in examples:
        echo "Building example '" & example & "'..."
        selfExec("compile -d:release -d:strip examples/" & example & ".nim")

task examples_debug, "Build examples (debug)":
    for example in examples:
        echo "Building example '" & example & "' (debug)..."
        selfExec("compile examples/" & example & ".nim")
