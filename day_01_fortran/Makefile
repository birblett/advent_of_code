.SILENT:
make:
	gfortran run.f90 -L/usr/local/include -I/usr/local/lib -lfortran_stdlib -O3 -fno-range-check

run: make
	./a.out

clean:
	rm a.out

runc: make run clean
