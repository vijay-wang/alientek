arch := arm
cross_compile := arm-linux-gnueabihf-
jobnums := -j4
visable := 1

mk_flags := ARCH=$(arch) CROSS_COMPILE=$(cross_compile) $(jobnums) V=$(visable)

uboot_dir := uboot-alientek
linux_dir := linux-alientek
busybox_dir := busybox-1.29.0-alientek
mfgtools_dir := mfgtools-alientek
tool_chain_dir := tool-chain-linaro-4.9.4

image := zImage-alientek-emmc
dtb := imx6ull-alientek-emmc.dtb
rootfs := rootfs-alientek-emmc.tar.bz2
uboot := u-boot-imx6ull-alientek-emmc.imx

img_defconf := imx_alientek_emmc_defconfig
uboot_defconf := mx6ull_alientek_emmc_defconfig
busybox_defconf := defconfig


include top.mk

all: linux uboot busybox
	mkdir output/rootfs output/uboot output/kernel -p; \
	cp $(busybox_dir)/output/* output/rootfs -r; tar -cjvf output/rootfs/$(rootfs) output/rootfs/*; \
	cp $(linux_dir)/arch/$(arch)/boot/zImage output/kernel/$(image); cp $(linux_dir)/arch/$(arch)/boot/dts/$(dtb) output/kernel; \
	cp $(uboot_dir)/u-boot.imx output/uboot/$(uboot); \


linux:
	$(call mk_target, $(linux_dir), $(mk_flags), $(img_defconf))

uboot:
	$(call mk_target, $(uboot_dir), $(mk_flags), $(uboot_defconf))

busybox:
	$(call mk_target, $(busybox_dir), $(mk_flags), $(busybox_defconf))
	$(call install_rootfs, $(mk_flags), $(tool_chain_dir), $(busybox_dir))

clean-all: clean-linux clean-uboot clean-busybox clean-mfgtools
	git clean  -df

clean-linux:
	$(call clean_submodule, $(linux_dir))

clean-uboot:
	$(call clean_submodule, $(uboot_dir))

clean-busybox:
	$(call clean_submodule, $(busybox_dir))

clean-mfgtools:
	$(call clean_submodule, $(mfgtools_dir))

