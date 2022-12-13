arch := "arm"
cross_compile := "arm-linux-gnueabihf-"
jobnums := "-j4"


all: linux uboot busybox

linux:
	cd linux-alientek; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} imx_alientek_emmc_defconfig; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} all ${jobnums} V=99; \
	cd ..

uboot:
	cd uboot-alientek; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} mx6ull_alientek_emmc_defconfig; \
	cd ..

busybox:
	cd busybox-1.29.0-alientek; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} ${jobnums}; \
	mkdir output; \
	make ARCH=${arch} CROSS_COMPILE=${cross_compile} install CONFIG_PREFIX=./output; \
	cd output; \
	mkdir lib; \
	cp ../../busybox-1.29.0-alientek/arm-linux-gnueabihf/libc/lib/*so* ../../busybox-1.29.0-alientek/arm-linux-gnueabihf/libc/lib/*.a lib -d; \
	cp ../../busybox-1.29.0-alientek/arm-linux-gnueabihf/lib/*so* ../../busybox-1.29.0-alientek/arm-linux-gnueabihf/lib/*.a lib -d; \
	cp /arm-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3 lib; \
	mkdir usr/lib -p; \
	cp ../../busybox-1.29.0-alientek/arm-linux-gnueabihf/libc/usr/lib/*so* ../../busybox-1.29.0-alientek/arm-linux-gnueabihf/libc/usr/lib/*.a usr/lib -d; \
	mkdir dev proc mnt sys tmp root etc; \
	cp ../inittab ../fstab ../rcS etc; \
	cd ../../

clean-all: clean-linux clean-uboot clean-busybox


clean-linux:
	make -C linux-alientek distclean
	cd linux-alientek; git clean -df; cd ..

clean-uboot:
	make -C uboot-alientek distclean
	cd uboot-alientek; git clean -df; cd ..

clean-busybox:
	make -C busybox-1.29.0-alientek distclean
	cd busybox-1.29.0-alientek; git clean -df; cd ..
