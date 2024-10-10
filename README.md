nim-sndfile
===========

A wrapper of [libsndfile] for the [Nim] programming language.

The libsndfile [API] is quite small, however the following functions are
currently still missing from this wrapper:

* `sf_read_raw`
* `sf_write_raw`
* `sf_get_string`
* `sf_set_string`
* `sf_current_byterate`
* `sf_set_chunk`
* `sf_get_chunk_iterator`
* `sf_next_chunk_iterator`
* `sf_get_chunk_size`
* `sf_get_chunk_data`


[API]: https://libsndfile.github.io/libsndfile/api.html
[libsndfile]: https://libsndfile.github.io/libsndfile/
[Nim]: https://nim-lang.org/s
