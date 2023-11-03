# modify the following line to match your needs
BINDIR=$(HOME)/bin

.PHONY: install

install:
	chmod 0755 src/sync-repo.sh
	cp src/sync-repo.sh $(BINDIR)
