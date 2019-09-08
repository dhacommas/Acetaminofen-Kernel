KERNEL_DIR=$PWD
Anykernel_DIR=$KERNEL_DIR/AnyKernel3/
DATE=$(date +"%d%m%Y")
KERNEL_NAME="Acetaminofen"
DEVICE="-kenzo-"
FINAL_ZIP="$KERNEL_NAME""$DEVICE""$DATE"

# Cleanup before 
rm -rf $Anykernel_DIR/*zip
rm -rf $Anykernel_DIR/Image.gz-dtb
rm -rf arch/arm64/boot/Image
rm -rf arch/arm64/boot/dts/qcom/kenzo-msm8956-mtp.dtb
rm -rf arch/arm64/boot/Image.gz
rm -rf arch/arm64/boot/Image.gz-dtb

# Export few variables
export KBUILD_BUILD_USER="Dhaval"
export KBUILD_BUILD_HOST="BleedingEdge"
export CROSS_COMPILE=/home/dhacommas/Desktop/cm14.1/n/toolchain/bin/aarch64-linux-android-
export ARCH=arm64 && export SUBARCH=arm64
export USE_CCACHE=1

# Finally build it
rm -rf out/
mkdir -p out
make clean && make mrproper
make kenzo_defconfig
make menuconfig
make -j9 2>&1 | tee BuildLog.log


# Create the flashable zip
cp out/arch/arm64/boot/Image.gz-dtb $Anykernel_DIR
cd $Anykernel_DIR
zip -r9 $FINAL_ZIP.zip * -x modules patch ramdisk LICENSE .git README.md *placeholder

# Cleanup again
cd ../
rm -rf $Anykernel_DIR/Image.gz-dtb
rm -rf out/arch/arm64/boot/Image
rm -rf out/arch/arm64/boot/dts/qcom/kenzo-msm8956-mtp.dtb
rm -rf out/arch/arm64/boot/Image.gz
rm -rf out/arch/arm64/boot/Image.gz-dtb
