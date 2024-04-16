#!/bin/bash
echo '1500' > '/proc/sys/vm/dirty_writeback_centisecs'
echo '0' > '/proc/sys/kernel/nmi_watchdog'
ls -1 /sys/bus/usb/devices/*/power/control | sudo xargs -I{} /bin/bash -c 'echo auto > {}'
ls -1 /sys/bus/pci/devices/*/power/control | sudo xargs -I{} /bin/bash -c 'echo auto > {}'
