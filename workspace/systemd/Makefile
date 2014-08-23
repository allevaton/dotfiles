# Makefile
#

DEST=/etc/systemd

all:
	@echo Nothing to do

install:
	@# Copy everything but the makefile
	ls -I Makefile | xargs cp -rt $(DEST)
	systemctl daemon-reload
