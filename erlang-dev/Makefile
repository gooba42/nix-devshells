# Makefile for Erlang template
.PHONY: build run clean

build:
	erlc src/hello.erl

run:
	erl -noshell -s hello start -s init stop

clean:
	rm -f src/*.beam
