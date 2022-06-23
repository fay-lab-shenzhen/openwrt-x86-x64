#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
echo "diy-part1.sh start......."
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
sed -i '$a src-git OpenAppFilter https://github.com/destan19/OpenAppFilter' feeds.conf.default
sed -i '$a src-git autotimeset https://github.com/sirpdboy/luci-app-autotimeset' feeds.conf.default


#sed -i '$a src-git luci-theme-opentomcat https://github.com/Leo-Jo-My/luci-theme-opentomcat' feeds.conf.default
#sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default
#sed -i '$a src-git AdGuardHome https://github.com/AdguardTeam/AdGuardHome' feeds.conf.default
#sed -i '$a src-git luci-app-clash https://github.com/frainzy1477/luci-app-clash' feeds.conf.default
#sed -i '$a src-git luci-app-aliddns https://github.com/honwen/luci-app-aliddns' feeds.conf.default
#sed -i '$a src-git luci-app-dockerman https://github.com/lisaac/luci-app-dockerman' feeds.conf.default
#sed -i '$a src-git luci-theme-argon https://github.com/jerrykuku/luci-theme-argon' feeds.conf.default
#sed -i '$a src-git luci-app-serverchan https://github.com/tty228/luci-app-serverchan' feeds.conf.default
#sed -i '$a src-git lua-maxminddb https://github.com/jerrykuku/lua-maxminddb' feeds.conf.default
#sed -i '$a src-git luci-app-vssr https://github.com/jerrykuku/luci-app-vssr' feeds.conf.default
#sed -i '$a src-git openwrt-smartdns https://github.com/pymumu/openwrt-smartdns' feeds.conf.default
#sed -i '$a src-git luci-app-smartdns https://github.com/pymumu/luci-app-smartdns' feeds.conf.default

cat feeds.conf.default

echo "diy-part1.sh complete......."
