.SILENT:
ifndef NTHREADS
NTHREADS=16
endif
make:
	ocamlc run.ml -I +str

run: make
	./a.out

clean:
	rm a.out run.cmi run.cmo

runc: make run clean
