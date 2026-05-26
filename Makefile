
SOURCES_BIN=$(wildcard bin/*)
MISE ?= mise
MISE_EXEC=$(MISE) exec --
USER?=$(shell whoami)
HOME?=/home/$(USER)

test:
	@$(MISE_EXEC) bash tests/harness.sh

lint:
	@$(MISE_EXEC) shellcheck -x $(SOURCES_BIN)

fmt:
	@$(MISE_EXEC) shfmt -w $(SOURCES_BIN)

ci: test lint

install:
	@mkdir -p "$(HOME)/.local/bin"
	for FILE in $(SOURCES_BIN); do \
		echo "Installing $$FILE to $(HOME)/.local/$$FILE"
		install -m 0755 "$$FILE" "$(HOME)/.local/$$FILE"
	done

install-link:
	@mkdir -p "$(HOME)/.local/bin"
	for FILE in $(SOURCES_BIN); do \
		TARGET="$(HOME)/.local/$$FILE"
		echo "Linking $$FILE to $$TARGET"
		if [ -e "$$TARGET" ]; then
			unlink "$$TARGET"
		fi
		ln -sfr $$FILE "$$TARGET"
	done

print-%:
	@$(info $*=$($*))

.ONESHELL:
# EOF
