Self-hosting Whitespace
====

It is a self-hosted Whitespace interpreter.


Usage
---

Install a Whitespace interpreter. I recommend https://github.com/pocke/gows

```console
$ go get github.com/pocke/gows
```

Compile Ruby code to Whitespace

```console
$ bundle install
$ bunlde exec compile:all
```

Execute it.


```console
$ cat build/fizzbuzz.ws sep | gows build/whitespace.ws

# More nest
$ cat build/whitespace.ws sep build/fizzbuzz.ws sep | gows build/whitespace.ws
```




Links
===

* https://github.com/pocke/akaza
  * A tool chain for Whitespace
* https://github.com/pocke/gows
  * Whitespace interpreter written in Go
