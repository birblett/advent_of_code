.SILENT:
make:
	nim -d:release --opt:speed c run.nim

run: make
	./run

clean:
	rm run

runc: make run clean
