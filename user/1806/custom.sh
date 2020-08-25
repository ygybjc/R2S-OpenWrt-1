sudo -E apt-get -y install jq

cd package/lean/default-settings/files
sed -i "s/DISTRIB_REVISION='\([^']*\)'/DISTRIB_DESCRIPTION='\1 | Build by BUILDUSER'/g" zzz-default-settings
sed -i 's/luciversion = "[^"]*"/luciversion = "BUILDVERSION"/g' zzz-default-settings
cd ../../../..

sed -i 's/Os/O3/g' include/target.mk
sed -i 's/O2/O3/g' ./rules.mk
sed -i 's/16384/65536/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

sed -i "s/PKG_HASH:=.*/PKG_HASH:=skip/g" feeds/packages/net/ariang/Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$(curl --silent "https://api.github.com/repos/mayswind/AriaNg/releases/latest" | jq ".tag_name" | sed -E 's/^.*"([^"]+)".*$/\1/')/g" feeds/packages/net/ariang/Makefile

sed -i 's/TARGET_x86_64/TARGET_x86_64||TARGET_rockchip/g' feeds/packages/utils/collectd/Makefile

sed -i 's,-DMULTIT,-Ofast -DMULTIT,g' package/lean/coremark/Makefile
sed -i '9,$d' package/lean/coremark/coremark.sh

mkdir -p package/base-files/files/etc/openclash/core
cd package/base-files/files/etc/openclash/core
curl -L https://github.com/vernesong/OpenClash/releases/download/Clash/clash-linux-armv8.tar.gz | tar zxf -
chmod +x clash
cd ../../../../../..