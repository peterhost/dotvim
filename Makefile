# Makefile — raccourcis vers bin/install, bin/update-plugins et test/run.sh
#
#   make             installeur guidé (menus)
#   make install     installation sans question (branche courante)
#   make try         essai à côté de la config actuelle, sans rien activer
#   make update      git pull + mise à jour des plugins
#   make uninstall   retirer la config, restaurer la sauvegarde
#   make check       batterie de tests : config et installeur
#                    (VIMS="vim /autre/vim" pour tester plusieurs vim)
#   make quick       tests rapides
#   make themes      ouvrir le fichier d'essai des thèmes (:Theme <Tab>, <F5>)

SHELL = /bin/sh
VIMS ?= vim

.PHONY: all install try update uninstall check quick themes

all:
	@sh bin/install

install:
	@sh bin/install --install --yes

try:
	@sh bin/install --try

update:
	-git pull --ff-only
	@sh bin/update-plugins
	@echo "Journal : local/update.log"

uninstall:
	@sh bin/install --uninstall

check:
	@sh test/run.sh $(VIMS)
	@sh test/install.sh

quick:
	@QUICK=1 sh test/run.sh $(VIMS)

themes:
	@vim -N -u "$(CURDIR)/vimrc" -c "setlocal spell" -c "Theme" test/fixtures/sample.md
