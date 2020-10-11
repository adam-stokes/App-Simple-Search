SEARCHTERM ?= life

build:
	docker build . -t simple-search-pl

check:
	docker run simple-search-pl perl t/matches.t

run:
	docker run -e SEARCHTERM=$(SEARCHTERM) simple-search-pl perl eg/main.pl


.phony: check run build
all: check
