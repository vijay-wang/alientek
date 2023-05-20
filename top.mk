define clean_submodule
	cd $(1); \
	make distclean; \
	git clean -df
endef

define install_rootfs
	cd $(3); \
	make $(1) install CONFIG_PREFIX=./output; \
	cd output; \
	mkdir lib lib/modules/4.1.15 dev proc mnt sys tmp root etc usr/lib \
        var media opt www boot etc/init.d home -p; \
	cp ../../$(strip $(2))/arm-linux-gnueabihf/libc/lib/*so* ../../$(strip $(2))/arm-linux-gnueabihf/libc/lib/*.a lib -rd; \
	cp ../../$(strip $(2))/arm-linux-gnueabihf/lib/*so* ../../$(strip $(2))/arm-linux-gnueabihf/lib/*.a lib -rd; \
	rm lib/ld-linux-armhf.so.3; \
	cp ../../$(strip $(2))/arm-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3 lib -rd; \
	cp ../../$(strip $(2))/arm-linux-gnueabihf/libc/usr/lib/*so* usr/lib -rd; \
	cp ../../$(strip $(2))/arm-linux-gnueabihf/libc/usr/lib/*.a usr/lib -rd; \
	cp ../inittab ../fstab etc; cp ../rcS etc/init.d/
endef

#arg1:dir
#arg2:mk_flags
#arg3:defconf
define mk_target
	cd $(1); \
	make $(2) $(3); \
	if [ "$(strip $(1))" = "$(busybox_dir)" ];then \
		mkdir output; \
		cp config_ok .config; \
	fi; \
	make $(2)
endef

define mk_buildroot
	cd $(1); \
	cp config_ok .config; \
	make
endef
