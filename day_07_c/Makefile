.SILENT:
ifndef NTHREADS
NTHREADS=1
endif
make:
	cc run.c -O3 -fopenmp $(CFLAGS) -DNTHREADS=$(NTHREADS)

run: make
	./a.out

clean:
	rm a.out

runc: make run clean
