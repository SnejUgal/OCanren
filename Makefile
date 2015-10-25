OCAML_OPTS=-rectypes -g #-verbose
TRACE1_LOG=-VIEW trace1
PP=camlp5o pa_log.cmo pa_gt.cmo #$(TRACE1_LOG)
OCAMLC=ocamlfind c $(OCAML_OPTS) -package typeutil,camlp5,GT,logger.syntax,GT.syntax -pp "$(PP)"
TEST_OUT=test.byte
PLUGINS=minikanren.cmo   # camlp5 plugin -- not user at the moment
CMOS+=Stream.cmo MiniKanren.cmo test.cmo
BINDIR=$(shell opam config var bin)
# camlp5o pr_o.cmo pa_gt.cmo -L /home/kakadu/.opam/4.01.0/lib/camlp5 -L . test.ml

.SUFFIXES: .cmo .cmx .ml

all: $(PLUGINS) $(CMOS) $(TEST_OUT)


.ml.cmo:
	$(OCAMLC) -c $<


$(TEST_OUT): $(CMOS)
	$(OCAMLC) -linkpkg $^ -o $@

clean:
	$(RM) *.cm[ioxa] *.o $(TEST_OUT)

install: $(TEST_OUT)
	install -m 755 $(TEST_OUT) $(BINDIR)/minikanren_test

uninstall:
	$(RM) $(BINDIR)/minikanren_test

# depends
test.cmo: MiniKanren.cmo Stream.cmo
MiniKanren.cmo: Stream.cmo
