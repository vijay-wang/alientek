arch := "arm"
cross_compile := "arm-linux-gnueabihf-"
jobnums := "-j4"
visable := 1

mk_flags := ARCH=${arch} CROSS_COMPILE=${cross_compile} ${jobnums} V=${visable}

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

all: linux uboot busybox
	mkdir output/rootfs output/uboot output/kernel -p; \
	cp ${busybox_dir}/output/* output/rootfs -r; tar -cjvf output/rootfs/${rootfs} output/rootfs/*; \
	cp ${linux_dir}/arch/${arch}/boot/zImage output/kernel/${image}; cp ${linux_dir}/arch/${arch}/boot/dts/${dtb} output/kernel; \
	cp ${uboot_dir}/u-boot.imx output/uboot/${uboot}; \
	cp output/kernel/* output/rootfs/${rootfs} output/uboot/${uboot} ${mfgtools_dir}/Profiles/Linux/OS\ Firmware/firmware/


linux:
	cd ${linux_dir}; \
	make ${mk_flags} ${img_defconf}; \
	make  all ${mk_flags}; \
	cd ..

uboot:
	cd ${uboot_dir}; \
	make ${mk_flags} ${uboot_defconf}; \
	make ${mk_flags}
	cd ..

busybox:
	cd ${busybox_dir}; mkdir output; \
	make ${mk_flags} ${busybox_defconf}; \
	make ${mk_flags}; \
	make ${mk_flags} install CONFIG_PREFIX=./output; \
	cd output; \
	mkdir lib dev proc mnt sys tmp root etc usr/lib -p; \
	cp ../../${tool_chain_dir}/arm-linux-gnueabihf/libc/lib/*so* ../../${tool_chain_dir}/arm-linux-gnueabihf/libc/lib/*.a lib -d; \
	cp ../../${tool_chain_dir}/arm-linux-gnueabihf/lib/*so* ../../${tool_chain_dir}/arm-linux-gnueabihf/lib/*.a lib -d; \
	rm lib/ld-linux-armhf.so.3; \
	cp ../../${tool_chain_dir}/arm-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3 lib; \
	cp ../../${tool_chain_dir}/arm-linux-gnueabihf/libc/usr/lib/*so* usr/lib -d; \
	cp ../inittab ../fstab ../rcS etc; \
	cd ../../

clean-all: clean-linux clean-uboot clean-busybox clean-mfgtools
	git clean  -df

clean-linux:
	make -C ${linux_dir} distclean
	cd ${linux_dir}; git clean -df; cd ..

clean-uboot:
	make -C ${uboot_dir} distclean
	cd ${uboot_dir}; git clean -df; cd ..

clean-busybox:
	make -C ${busybox_dir} distclean
	cd ${busybox_dir}; git clean -df; cd ..

clean-mfgtools:
	cd ${mfgtools_dir}; git clean -df; cd ..

