module vloggo

import time
import etienne_napoleone.chalk
import os
import term

pub enum Level {
	debug
	info
	warning
	error
	panic
}

pub struct LVL {
	level_string string
	color string
}

const ranking = [Level.panic, .error, .warning, .info, .debug]
const color = term.can_show_color_on_stdout() && term.can_show_color_on_stderr()

pub struct Logger {
	minimum_logging_level Level
	levels map[Level]LVL
}

fn printable(lvl Level, minlvl Level) bool {
	for level in ranking {
		match level {
			lvl { return true }
			minlvl { return false }
			else {}
		}
	}
	return false
}

fn (l Logger) p(msg string, lvl Level, keys map[string]string, mut out os.File) {
	if printable(lvl, l.minimum_logging_level) {
		mut logbuilder := []string{}
		now := time.now()
		logbuilder << "${chalk.fg(now.str(), 'dark_gray')} "
		logbuilder << "${chalk.fg(l.levels[lvl].level_string, l.levels[lvl].color)} "
		logbuilder << "${msg} "
		for key, val in keys {
			k := "$key="
			logbuilder << "${chalk.fg(k, l.levels[lvl].color)}$val "
		}
		out.writeln(logbuilder.join("")) or { panic(err) }
	}
}

pub fn (l Logger) info(msg string) {
	mut out := os.stdout()
	l.p(msg, .info, map[string]string{}, mut out)
}

pub fn (l Logger) info_map(msg string, keys map[string]string) {
	mut out := os.stdout()
	l.p(msg, .info, keys, mut out)
}

pub fn (l Logger) debug(msg string) {
	mut out := os.stdout()
	l.p(msg, .debug, map[string]string{}, mut out)
}

pub fn (l Logger) debug_map(msg string, keys map[string]string) {
	mut out := os.stdout()
	l.p(msg, .debug, keys, mut out)
}

pub fn (l Logger) error(msg string) {
	mut out := os.stderr()
	l.p(msg, .error, map[string]string{}, mut out)
}

pub fn (l Logger) error_map(msg string, keys map[string]string) {
	mut out := os.stderr()
	l.p(msg, .error, keys, mut out)
}

pub fn (l Logger) warn(msg string) {
	mut out := os.stderr()
	l.p(msg, .error, map[string]string{}, mut out)
}

pub fn (l Logger) warn_map(msg string, keys map[string]string) {
	mut out := os.stderr()
	l.p(msg, .error, keys, mut out)
}

pub fn (l Logger) panic(msg string) {
	mut out := os.stderr()
	l.p(msg, .error, map[string]string{}, mut out)
	exit(1)
}

pub fn (l Logger) panic_map(msg string, keys map[string]string) {
	mut out := os.stderr()
	l.p(msg, .error, keys, mut out)
	exit(1)
}

pub fn new() Logger {
	return return_new(.info)
}

pub fn new_min_level(minlvl Level) Logger {
	return return_new(minlvl)
}

fn return_new(minlvl Level) Logger {
	mut lvls := map[Level]LVL
	lvls[.debug] = LVL{level_string: "DBG", color: "light_yellow"}
	lvls[.info] = LVL{level_string: "INFO", color: "light_green"}
	lvls[.warning] = LVL{level_string: "WARN", color: "light_red"}
	lvls[.error] = LVL{level_string: "ERR", color: "red"}
	lvls[.panic] = LVL{level_string: "PAN", color: "red"}

	mut logger := Logger{minimum_logging_level: minlvl, levels: lvls}

	return logger
}