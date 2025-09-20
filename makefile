all: main

run: main
	cls
	main.exe

main: main.cpp
	g++ -Iinclude -Wall main.cpp -o $@.exe

clean_linux:
	rm -rf build/*

clean:
	del /Q build\*