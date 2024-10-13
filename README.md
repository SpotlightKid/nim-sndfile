nim-sndfile
===========

A wrapper of [libsndfile] for the [Nim] programming language.


# API

The libsndfile [API] only has a relatively small number of functions, but it
defines quite a few types and enum values. The `sndfile` Nim module provides
definitions for all types and enums (except those for deprecated and not-yet
implemented functions) and wraps all functions, *except* the following:

* `sf_open_fd`
* `sf_open_virtual`
* `sf_wchar_open`
* `sf_read_raw`
* `sf_write_raw`
* `sf_set_chunk`
* `sf_get_chunk_iterator`
* `sf_next_chunk_iterator`
* `sf_get_chunk_size`
* `sf_get_chunk_data`

These missing functions may be added in future versions, if it makes sense to
use them in Nim.


# Naming conventions

* The `sf_` prefix has been removed from function names, i.e. instead of
  `sf_read_double`, use just `read_double` (or `readDouble`, Nim's
  identifier naming rules make no distinction).
  The wrapper code generally uses lower `camelCase`.
* All values within each enum have been stripped of their unique prefix and
  all enums are marked `{.pure.}`. This means you should prefix each enum
  symbol with its enum type name. For example `SF_FORMAT_WAV` becomes
  `SFFormat.WAV` (or `SF_Format.Wav` etc.). If the value symbol is
  non-ambiguous, the enum name can be omitted, e.g. `GET_LOG_INFO` instead
  of `SFCommand.GET_LOG_INFO`.
* typedefs and structs start with a capital letter and retain their `SF`
  prefix, but Nim's identifier naming rules allow to omit underscores and use
  whatever case after the first letter. For example, instead of `SF_INFO`, you
  can use `SFInfo`, `SF_info` etc. The wrapper code generally uses
  `PascalCase`.

## Special cases

| C prefix / name                | Nim enum / symbol      |
| ------------------------------ | ---------------------- |
| `SFM_`                         | `SFMode`               |
| `SF_STR_`                      | `SFStrType`            |
| `SF_LOOP_`                     | `SFLoopMode`           |
| `SFC_`                         | `SFCommand`            |
| `SNDFILE`                      | `SndFile`              |
| `sf_count_t`                   | `SFCount`              |
| `SF_TRUE`                      | `SFBool.TRUE`          |
| `SF_FALSE`                     | `SFBool.FALSE`         |
| `SF_STR_FIRST`	               | `SFStrType.low`        |
| `SF_STR_LAST`	                 | `SFStrType.high`       |
| `SF_AMBISONIC_NONE`            | `SFAmbisonic.NONE`     |
| `SF_AMBISONIC_B_FORMAT`        | `SFAmbisonic.B_FORMAT` |
| `SF_INSTRUMENT.loops`          | `SFLoop`               |
| `SF_INSTRUMENT.loops[n].end`   | `SFLoops.endPos`       |
| `SF_INSTRUMENT.loops[n].start` | `SFLoops.startPos`     |

## Structs with customizable-sized array fields

* `SF_CUES`: Define / allocate `array[<n>, SFCuePoint]` as needed
* `SF_BROADCAST_INFO`:  Set number of entries in the `codingHistory` array
  member of `SFBroadcastInfo` with `-d:sfCodingHistSize=<n>` at compile time.
  The default size is 256.
* `SF_CART_INFO`:  Set number of entries in the `tagText` array member of
  `SFCartInfo` with `-d:sfMaxTagTextSize=<n>` at compile time. The default
  size is 256.


## Authors

*nim-sndfile* was written by [Julien Aubert](https://github.com/julienaubert)
and this fork was updated, re-factored and extended by
[Christopher Arndt](https://github.com/SpotlightKid), while also applying
some patches by [James Bradbury](https://github.com/jamesb93).


## License

This software is released under the *MIT License*. See the file
[LICENSE.md](./LICENSE.md) for more information.


[API]: https://libsndfile.github.io/libsndfile/api.html
[libsndfile]: https://libsndfile.github.io/libsndfile/
[Nim]: https://nim-lang.org/s
