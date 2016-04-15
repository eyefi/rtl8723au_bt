#KVER	:= 3.4.90+
KVER	:= 3.4.104+
#KVER	:= 3.4.103-00033-g9a1cd03-dirty
KDIR	:= ../linux-sunxi
KOUT    := $(KDIR)/out
FW_DIR	:= $(KOUT)/lib/firmware/
#MDL_DIR	:= $(KOUT)/lib/modules/$(shell uname -r)
MDL_DIR	:= $(KOUT)/lib/modules/$(KVER)
DRV_DIR	:= $(MDL_DIR)/kernel/drivers/bluetooth

ifneq ($(KERNELRELEASE),)

	obj-m := btusb.o

else
	PWD := $(shell pwd)
	#KVER := $(shell uname -r)
	#KDIR := /lib/modules/$(KVER)/build

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	rm -rf *.o *.mod.c *.mod.o *.ko *.symvers *.order *.a
endif

install:
	@mkdir -p $(FW_DIR)
	@cp -f rtl8723a_fw $(FW_DIR)/.
	@cp -f rtl8723b_fw $(FW_DIR)/.
	@cp -f rtl8821a_fw $(FW_DIR)/.
	@cp -f rtl8761a_fw $(FW_DIR)/.
	@mkdir -p $(DRV_DIR)
	@cp -f btusb.ko $(DRV_DIR)/btusb.ko
	depmod -a $(KVER) -b $(KOUT) 
	@echo "installed revised btusb"

uninstall:
	rm -f $(DRV_DIR)/btusb.ko
	depmod -a -b $(KOUT)
	echo "uninstalled revised btusb"
