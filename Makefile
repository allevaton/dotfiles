# Testing makefile
#

dir = src

# Check OS
ifeq ($(shell uname -s), Linux)
	file_name = "Linux"
else
	file_name = "Windows"
endif

all:
	@echo $(file_name)
