#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.111.1/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.$((addr_offset++)).1/192.168.111.1/g' package/base-files/files/bin/config_generate
sed -i 's/192\.168\.[0-9]\+\.1/192.168.111.1/g' package/base-files/files/bin/config_generate

echo "Removing official qBittorrent packages..."

./scripts/feeds uninstall qbittorrent || true
./scripts/feeds uninstall qbittorrent-static || true
./scripts/feeds uninstall luci-app-qbittorrent || true

echo "Installing sbwml qBittorrent packages..."

./scripts/feeds install -a -p qbittorrent

echo "qBittorrent feed replacement completed."
