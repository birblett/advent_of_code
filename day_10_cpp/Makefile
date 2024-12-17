.SILENT:
ifndef NTHREADS
NTHREADS=16
endif
make:
	g++ run.cpp -fopenmp -O3 $(CFLAGS) -DNTHREADS=$(NTHREADS)

run: make
	./a.out

clean:
	rm a.out

runc: make run clean
