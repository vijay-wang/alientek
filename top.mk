define clean_submodule
	cd $1; \
	make distclean; \
	git clean -df; \
	cd ..
endef

define install_rootfs
	make $1 install CONFIG_PREFIX=./output; \
	cd output; \
	mkdir lib dev proc mnt sys tmp root etc usr/lib -p; \
	cp ../../$2/arm-linux-gnueabihf/libc/lib/*so* ../../$2/arm-linux-gnueabihf/libc/lib/*.a lib -d; \
	cp ../../$2/arm-linux-gnueabihf/lib/*so* ../../$2/arm-linux-gnueabihf/lib/*.a lib -d; \
	rm lib/ld-linux-armhf.so.3; \
	cp ../../$2/arm-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3 lib; \
	cp ../../$2/arm-linux-gnueabihf/libc/usr/lib/*so* usr/lib -d; \
	cp ../inittab ../fstab ../rcS etc; \
	cd ../../
endef

#arg1:dir
#arg2:mk_flags
#arg3:defconf
define mk_target
	cd $1; \
	if [ $1 eq "busybox_dir" ];then \
		mkdir output; \
	fi; \
	make $2 $3; \
	make $2; \
	if [ $1 nq "busybox_dir" ];then \
		cd ..; \
	fi; \
	$(call install_rootfs, $2, $1)
endef
