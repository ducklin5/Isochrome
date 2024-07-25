all:
	cd gdproject/gdnative && cargo build
	cp gdproject/gdnative/target/debug/native.dll gdproject/libs/bin/windows/
	cd gdproject && ../engine/godot -d


copylibs:
	cp gdnative/target/debug/native.dll gdproject/libs/bin/windows/
