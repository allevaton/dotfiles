# Testing makefile
#

dir = src
vimrc =
xinitrc =

# Check OS
ifeq ($(shell uname -s), Linux)
	echo "Linux"
else
	echo "Windows"
endif

all:

