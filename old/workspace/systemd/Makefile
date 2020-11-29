# Makefile
#

all:
	@#
	$(MAKE) -C user
	sudo $(MAKE) -C system

help:
	@echo "Run 'make' to install user systemd scripts"
	@echo "Run 'sudo make install' to run root systemd scripts"

install:
	# Copy everything but the makefile
