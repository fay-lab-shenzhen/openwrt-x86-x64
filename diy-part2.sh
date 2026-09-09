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
sed -i 's/192.168.$((addr_offset++)).1/192.168.111.1/g' package/base-files/files/bin/config_generate
sed -i 's/192\.168\.[0-9]\+\.1/192.168.111.1/g' package/base-files/files/bin/config_generate

echo "Removing official qBittorrent packages..."

# 1. 先删除已生成的软链接（防止死链接）
rm -f package/feeds/packages/qBittorrent
rm -f package/feeds/packages/qBittorrent-static
rm -f package/feeds/luci/luci-app-qbittorrent

# 2. 再删除官方源文件
rm -rf feeds/packages/net/qBittorrent
rm -rf feeds/packages/net/qBittorrent-static
rm -rf feeds/luci/applications/luci-app-qbittorrent

echo "Official qBittorrent packages removed."

echo "Installing sbwml qBittorrent packages..."
./scripts/feeds install -a -p qbittorrent
echo "sbwml qBittorrent packages installed."

echo "========================================"
echo "        Verify qBittorrent Status"
echo "========================================"

echo
echo "===== 1. sbwml feed source ====="
ls -ld feeds/qbittorrent 2>/dev/null || \
    echo "ERROR: feeds/qbittorrent 不存在"

echo
echo "===== 2. sbwml Makefiles ====="
find feeds/qbittorrent -maxdepth 2 -type f -name Makefile 2>/dev/null

echo
echo "===== 3. sbwml installed links ====="
ls -ld package/feeds/qbittorrent/qbittorrent 2>/dev/null || \
    echo "ERROR: qbittorrent 未安装到 package/feeds/qbittorrent/"

ls -ld package/feeds/qbittorrent/luci-app-qbittorrent 2>/dev/null || \
    echo "ERROR: luci-app-qbittorrent 未安装到 package/feeds/qbittorrent/"

echo
echo "===== 4. OFFICIAL cleanup check ====="
# 关键：检查官方包是否已彻底删除
ls -ld package/feeds/packages/qBittorrent 2>/dev/null && \
    echo "WARNING: 官方 qBittorrent 残留！" || \
    echo "OK: 官方 qBittorrent 已清除"

ls -ld package/feeds/luci/luci-app-qbittorrent 2>/dev/null && \
    echo "WARNING: 官方 luci-app-qbittorrent 残留！" || \
    echo "OK: 官方 luci-app-qbittorrent 已清除"

echo
echo "===== 5. duplicate check in menuconfig ====="
# 如果同时存在大小写两个版本，make menuconfig 会显示重复
grep -r "qBittorrent" package/feeds/packages/ 2>/dev/null && \
    echo "WARNING: packages feed 中发现 qBittorrent 关键字" || \
    echo "OK: packages feed 中无 qBittorrent"

grep -r "qbittorrent" package/feeds/qbittorrent/ 2>/dev/null && \
    echo "OK: qbittorrent feed 中发现 qbittorrent 关键字" || \
    echo "WARNING: qbittorrent feed 中无 qbittorrent"

echo "Removing official ksmbd packages..."

# 1. 正确卸载 feed 软链接（用目录名，不是子包名）
./scripts/feeds uninstall ksmbd-tools || true
./scripts/feeds uninstall luci-app-ksmbd || true

# 2. 删除 LEDE 主仓库的 autosamba
rm -rf package/lean/autosamba

# 3. 删除 feed 源文件（用户空间工具 + LuCI）
rm -rf feeds/packages/net/ksmbd-tools
rm -rf feeds/luci/applications/luci-app-ksmbd

# 4. 清理可能残留的软链接（feeds uninstall 失败时的补救）
rm -f package/feeds/packages/ksmbd-tools
rm -f package/feeds/luci/luci-app-ksmbd

echo "ksmbd removing completed."

echo "===== verify ksmbd cleanup ====="
ls -ld package/feeds/packages/ksmbd-tools 2>/dev/null && \
    echo "WARNING: ksmbd-tools 软链接残留" || echo "OK: ksmbd-tools 软链接已清除"

ls -ld package/feeds/luci/luci-app-ksmbd 2>/dev/null && \
    echo "WARNING: luci-app-ksmbd 软链接残留" || echo "OK: luci-app-ksmbd 软链接已清除"

ls -ld package/kernel/ksmbd 2>/dev/null && \
    echo "WARNING: ksmbd 内核模块残留" || echo "OK: ksmbd 内核模块已清除"

echo "===== Qt5 package config ====="
grep -E '^CONFIG_PACKAGE_(qtbase|qttools)=' .config || true

echo "===== Packages depending on qtbase ====="
grep -R -nE '(\+| )qtbase([ /]|$)' package/feeds package/lean 2>/dev/null || true

echo "===== Packages depending on qttools ====="
grep -R -nE '(\+| )qttools([ /]|$)' package/feeds package/lean 2>/dev/null || true

echo "===== Current Qt5 Makefiles ====="
find package/feeds package/lean \
  \( -path '*/qtbase/Makefile' -o -path '*/qttools/Makefile' \) \
  2>/dev/null

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

