MAIN = Nim.hs
EXE = nim

all: $(EXE)

clean:
	rm -f *.o *.hi $(EXE)

$(EXE): $(wildcard *.hs)
	ghc -O2 -o $(EXE) --make $(MAIN)
