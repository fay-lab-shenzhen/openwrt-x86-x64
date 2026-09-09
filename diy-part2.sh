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

echo "Removing official ksmbd packages..."
./scripts/feeds uninstall ksmbd-utils || true
./scripts/feeds uninstall kmod-fs-ksmbd || true
./scripts/feeds uninstall ksmbd-server || true
./scripts/feeds uninstall luci-app-ksmbd || true
./scripts/feeds uninstall luci-i18n-ksmbd-zh-cn || true
echo "ksmbd feed removing completed."

echo "===== Qt5 package config ====="
grep -E '^CONFIG_PACKAGE_(qtbase|qttools)=' .config || true

echo "===== Packages depending on qtbase ====="
grep -R -nE '(\+| )qtbase([/ ]|$)' package feeds 2>/dev/null || true

echo "===== Packages depending on qttools ====="
grep -R -nE '(\+| )qttools([/ ]|$)' package feeds 2>/dev/null || true

echo "===== Qt5 package Makefiles ====="
find package feeds -path '*/qtbase/Makefile' -o -path '*/qttools/Makefile' 2>/dev/null

echo "========================================"
echo "        ksmbd dependency check"
echo "========================================"

echo ""
echo "===== ksmbd related config ====="
grep -E '^CONFIG_PACKAGE_.*ksmbd' .config || true

echo ""
echo "===== Packages depending on ksmbd ====="
grep -R -nE 'DEPENDS.*(\+ksmbd|ksmbd)|HOST_BUILD_DEPENDS.*ksmbd|PKG_BUILD_DEPENDS.*ksmbd' \
    package feeds 2>/dev/null || true

echo ""
echo "===== All ksmbd references ====="
grep -R -nE 'ksmbd' package feeds 2>/dev/null | head -200 || true

echo ""
echo "========================================"

