# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/NusantaraProject-ROM/android_manifest.git -b 11 -g default,-device,-mips,-darwin,-notdefault
git clone https://github.com/Fraschze97/local_manifest --depth=1 -b R3-NAD11 .repo/local_manifests
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all) || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

#patches
cd build/make
curl -LO https://github.com/Maanush2004/android_device_realme_RMX1821/blob/lineage-17.1-rmui/patches/build/make/0001-build-Add-option-to-append-vbmeta-image-to-boot-imag.patch
patch -p1 < *.patch
cd ../..

# build rom
. build/envsetup.sh
lunch nad_RMX1821-userdebug
export SKIP_API_CHECKS=true
export SKIP_ABI_CHECKS=true
export TZ=Asia/Jakarta
mka nad
 
# upload rom (if you don't need to upload multiple files, then you don't need to edit next line)
rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip cirrus:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P

