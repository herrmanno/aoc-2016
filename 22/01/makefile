.PHONY: all build run clean

all: build run

build:
	mcs -debug main.cs

run:
	mono --debug main.exe

clean:
	@rm main.exe main.exe.mdb