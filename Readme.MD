# Instructions: 


Make sure the corresponding paths in the shell scripts are right on your computer.   


    sudo ./mkfs.sh -r [ROOT's directory ]  
change the ROOT'S directory 



    sudo ./mkfs.sh -b [BUSYBOX's directory ]  
change the BUSYBOX'S directory  
   
    sudo ./mkfs.sh -c [CROSS's directory ]  
change the CROSS'S directory  

    sudo ./mkfs.sh -t [TARGET_LIBS's directory ]  
change the TARGET_LIBS'S directory  
 
    sudo ./mkfs.sh -d [DEST's directory ]  
change the DEST'S directory  

---
you can also use:

    sudo ./mkfs.sh -k [module directory]   
to add the kernel module  

    sudo ./mkfs.sh -u [user program directory] 
to add the user program  

    sudo ./mkfs.sh -b [boot scripts directory]
to replace the boot scripts in the system  

Otherwise, nothing will be added.

---

These shell scripts will create a **1.2M-sized image**, which can work well in the qemu. In addition, the shell scripts are non-interactive, it means that they won't ask you to insert anything as the input.

---
# Motivations about my project:

Based on the half-working example, there are two main things which I need to do  for 
this project.

1.The inclusion of custom programs, kernel modules, or boot scripts in the image must be supported.  
I used getopts to sparse them, dividing them into several cases. ":" after the choice(k,u,b) means that it permits you to add some new parameters after the choice.

2.The size of the initramfs must be reduced to the minimum.  

This is the most important project's part.

---

At the beginning, I entered the folder ../rootfs/lib and cancelled all the files
*.o and *.a. Because in terms of executables, they have been compiled by static libraries(or maybe a single object file), object files and static libraries are not needed any more in the image.

For instance,I need to know which shared objects are necessary. In the ../rootfs/bin folder, with "arm-unknown-linux-gnu-readelf -d busybox", I can easily find that "libc.so" ,"libcrypt.so"and "libm.so" are needed. Moreover, to login the system, I checked every shared objects with "arm-unknown-linux-gnu-nm" and found that "libnss_compat-2.3.2.so" supports the login.(00002eac t copy_pwd_changes
00005948 t copy_spwd_changes)

Continuously, I used "arm-unknown-linux-gnu-readelf -d [ELF file]" to read the relationships between each shared objects(*.so). "libcrypt-2.3.2.so" and "libm-2.3.2.so" rely on "libc-2.3.2.so", it's OK, but "libc.so" relies on "ld-2.3.2.so", so this one I shouldn't cancel. For the same reason, "libnss_compat-2.3.2.so" depends on "libnsl-2.3.2.so" which should also  be kept.

So in conclusion, the necessary dynamic libraries are:
libc-2.3.2.so
libcrypt-2.3.2.so
libm-2.3.2.so
ld-2.3.2.so
libnsl-2.3.2.so
libnss_compat-2.3.2.so

However, it has not been finished yet. After cancelling all the unwanted dynamic libraries, I need to use "arm-unknown-linux-gnu-strip" to reduce the size of the needed dynamic libraries. GNU strip discards all symbols from object files objfile. The list of object files may include archives. It can help us to reduce the size of the output image.

At last, we can get a 1.2M sized image. In the qemu, it supports the system's login and every shell in the folder bin and sbin. If you want to use the kernel module, sometimes you may need to add and insmod some other kernel modules(ex,xenomai) so that you can run it. But for our case to minimize the image , they’re not needed because the main advantage of kernel module is that you can add and use it whenever you want.
