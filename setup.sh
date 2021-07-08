#!/usr/bin/env bash


##Updating Repos & Installing dependencies
echo      ++++++++++ SYZKALLER INSTALLER ++++++++++++
echo   ----------- FUZZ LINUX KERNELs ON THE GO -----------
echo --------------------------------------------------------
echo  
echo
echo 
echo                 follow me on 
echo          https://github.com/ch3332xr
echo  [......////////\\\ This May Take a While.........@#$%^*]
echo  [+++  Updating repos and  installing dependencies]
apt update
apt install build-essential manpages-dev flex bison libssl-dev libelf-dev debootstrap qemu-system-x86 libncurses-dev unzip
##Cloning the LINUX KERNEL &  building it
echo  [+++  Cloning and Bulding LINUX KERNEL]
git clone https://github.com/torvalds/linux.git $KERNEL
cd linux
make CC="$GCC/usr/bin/gcc" defconfig
make CC="$GCC/bin/gcc" kvm_guest.config
##Editing .config file
echo  [+++  Setting up Config]
sed -i 's/# CONFIG_KCOV is not set/CONFIG_KCOV=y/' .config
sed -i 's/# CONFIG_DEBUG_INFO is not set/CONFIG_DEBUG_INFO=y/' .config
sed -i 's/# CCONFIG_KASAN is not set/CONFIG_KASAN=y/' .config
sed -i 's/# CONFIG_KASAN_INLINE is not set/CONFIG_KASAN_INLINE=y/' .config
sed -i 's/# CONFIG_CONFIGFS_FS is not set/CONFIG_CONFIGFS_FS=y/' .config
sed -i 's/# CONFIG_SECURITYFS is not set/CONFIG_SECURITYFS=y/' .config
sed -i 's/# CONFIG_FAULT_INJECTION is not set/CONFIG_FAULT_INJECTION=y/' .config
sed -i 's/# CONFIG_FAULT_INJECTION_DEBUG_FS is not set/CONFIG_FAULT_INJECTION_DEBUG_FS=y/' .config
sed -i 's/# CONFIG_DEBUG_KMEMLEAK is not set/CONFIG_DEBUG_KMEMLEAK=y/' .config
sed -i 's/# CONFIG_FAILSLAB is not set/CONFIG_FAILSLAB=y/' .config
sed -i 's/# CONFIG_KCOV_ENABLE_COMPARISONS is not set/CONFIG_KCOV_ENABLE_COMPARISONS=y/' .config
##Reconfig make
echo  [+++  Rebuilding....]
make CC="$GCC/usr/bin/gcc" olddefconfig
##Kernel Build
echo  [+++++  Building Custom Kernel for FUZZING +++++]
make CC="$GCC/usr/bin/gcc" -j64
##Creating Debian Image
echo  [+++  Creating a Debian img]
wget https://raw.githubusercontent.com/google/syzkaller/master/tools/create-image.sh -O create-image.sh
chmod +x create-image.sh
./create-image.sh
##Launch QEMU
##echo -e “[+++  QEMU LAUNCH]”
##qemu-system-x86_64 -m 4G -smp 2 -kernel arch/x86_64/boot/bzImage -append "console=ttyS0 root=/dev/sda earlyprintk=serial" -drive file=stretch.img -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 -net nic,model=e1000 -enable-kvm -nographic -pidfile vm.pid 2>&1 | tee vm.log
##Build SYZKALLER
cd ..
echo  [+++ Building SYZKALLER  ]
wget https://dl.google.com/go/go1.14.2.linux-amd64.tar.gz
tar -xvf go1.14.2.linux-amd64.tar.gz
mv go goroot
mkdir gopath
export GOPATH=/home/ubuntu/SYZKALLER/gopath
export GOROOT=/home/ubuntu/SYZKALLER/goroot
export PATH=$GOPATH/bin:$PATH
export PATH=$GOROOT/bin:$PATH
go get -u -d github.com/google/syzkaller/prog
cd gopath/src/github.com/google/syzkaller/
make
mkdir workdir
echo  [***** Patience Pays *****]
echo  Launch SYZKALLER :  ./bin/syz-manager -config=my.cfg
echo  GET FUZZING!!!
echo  [-------------SkFJX01BSEFLQUwh------------]
echo  follow me on https://github.com/ch3332xr
