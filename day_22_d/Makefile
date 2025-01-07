.SILENT:
make:
	ldc2 -O3 -mcpu=native run.d

run: make
	./run

clean:
	rm run run.o

runc: make run clean
