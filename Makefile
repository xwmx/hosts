BIN ?= hosts
PREFIX ?= /usr/local

install:
	install $(BIN) $(PREFIX)/bin
	./scripts/hosts-completion install

uninstall:
	rm -f $(PREFIX)/bin/$(BIN)
	./scripts/hosts-completion uninstall
