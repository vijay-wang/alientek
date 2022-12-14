arch := "arm"
cross_compile := "arm-linux-gnueabihf-"
jobnums := "-j4"
visable := 1


all: linux uboot busybox
	mkdir output/rootfs output/uboot output/kernel -p; \
	cp busybox-1.29.0-alientek/output/* output/rootfs -r; tar -cjvf output/rootfs/rootfs-alientek-emmc.tar.bz2 output/rootfs/*; \
	cp linux-alientek/arch/${arch}/boot/zImage output/kernel/zImage-alientek-emmc; cp linux-alientek/arch/${arch}/boot/dts/imx6ull-alientek-emmc.dtb output/kernel; \
	cp uboot-alientek/u-boot.imx output/uboot/u-boot-imx6ull-alientek-emmc.imx; \
	cp output/kernel/* output/rootfs/rootfs-alientek-emmc.tar.bz2 output/uboot/u-boot-imx6ull-alientek-emmc.imx mfgtools-alientek/Profiles/Linux/OS\ Firmware/firmware/


linux:
	cd linux-alientek; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} imx_alientek_emmc_defconfig; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} all ${jobnums} V=${visable}; \
	cd ..

uboot:
	cd uboot-alientek; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} mx6ull_alientek_emmc_defconfig; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} ${jobnums} V=${visable}
	cd ..

busybox:
	cd busybox-1.29.0-alientek; mkdir output; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} defconfig; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} ${jobnums} V=${visable}; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} V=${visable} install CONFIG_PREFIX=./output; \
	cd output; \
	mkdir lib dev proc mnt sys tmp root etc usr/lib -p; \
	cp ../../tool-chain-linaro-4.9.4/arm-linux-gnueabihf/libc/lib/*so* ../../tool-chain-linaro-4.9.4/arm-linux-gnueabihf/libc/lib/*.a lib -d; \
	cp ../../tool-chain-linaro-4.9.4/arm-linux-gnueabihf/lib/*so* ../../tool-chain-linaro-4.9.4/arm-linux-gnueabihf/lib/*.a lib -d; \
	rm lib/ld-linux-armhf.so.3; \
	cp ../../tool-chain-linaro-4.9.4/arm-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3 lib; \
	cp ../../tool-chain-linaro-4.9.4/arm-linux-gnueabihf/libc/usr/lib/*so* usr/lib -d; \
	cp ../inittab ../fstab ../rcS etc; \
	cd ../../

clean-all: clean-linux clean-uboot clean-busybox clean-mfgtools
	git clean  -df

clean-linux:
	make -C linux-alientek distclean
	cd linux-alientek; git clean -df; cd ..

clean-uboot:
	make -C uboot-alientek distclean
	cd uboot-alientek; git clean -df; cd ..

clean-busybox:
	make -C busybox-1.29.0-alientek distclean
	cd busybox-1.29.0-alientek; git clean -df; cd ..

clean-mfgtools:
	cd mfgtools-alientek; git clean -df; cd ..

