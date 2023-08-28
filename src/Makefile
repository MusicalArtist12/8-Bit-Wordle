default: build

build:
	avra main.asm
	# https://github.com/Ro5bert/avra

burn: build
	avrdude -c arduino -p atmega328p -P /dev/ttyUSB0 -e -U flash:w:main.hex

erase:
	avrdude -c arduino -p atmega328p -P /dev/ttyUSB0 -e