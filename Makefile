BIN ?= hosts
PREFIX ?= /usr/local

install:
	install $(BIN) $(PREFIX)/bin
	./$(BIN) completions install

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
	./$(BIN) completions uninstall
