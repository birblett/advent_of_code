.SILENT:
make:
	rustc -C opt-level=3 run.rs

run: make
	./run

clean:
	rm run

runc: make run clean
