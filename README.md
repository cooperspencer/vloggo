# Vloggo
Logging module for V.

# How to get?
```bash
v get https://github.com/cooperspencer/floggo
```

# Usage
```v
module main

import vloggo

fn main() {
	l := vloggo.new()
	l.info("hello")
	mut test := map[string]string
	test["hell"] = "yes"
	l.info_map("hello", test)

	// if you don't need all log levels
	ln := vloggo.new_min_level(vloggo.Level.error)
	ln.info("I am not here")
	ln.error("But I am")
}
```

# Levels
```v
pub enum Level {
	debug
	info
	warning
	error
	panic
}
```