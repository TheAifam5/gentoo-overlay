# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

DESCRIPTION="A backport of the Realtek Wifi 5 drivers from the wireless-next repo."
HOMEPAGE="https://github.com/lwfinger/rtw88"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lwfinger/rtw88"
	EGIT_REPO_BRANCH="master"
else
	COMMIT="461b696b51317ba4ca585a4ddb32f2e72cd4efc9"
	SRC_URI="https://github.com/lwfinger/rtw88/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/rtw88-${COMMIT}"
	KEYWORDS="~amd64"
fi

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT=0

MODULES_KERNEL_MIN=6.1
CONFIG_CHECK="~!RTW88"

src_prepare() {
	default_src_prepare

	# Remove the FWDIR variable from the Makefile
	sed -i -e '/^FWDIR/d' "${S}"/Makefile || die "Failed to remove FWDIR from Makefile"
}

src_compile() {
	local modlist=(
		rtw_8703b=net/wireless/realtek/rtw88
		rtw_8723cs=net/wireless/realtek/rtw88
		rtw_8723de=net/wireless/realtek/rtw88
		rtw_8723d=net/wireless/realtek/rtw88
		rtw_8723ds=net/wireless/realtek/rtw88
		rtw_8723du=net/wireless/realtek/rtw88
		rtw_8723x=net/wireless/realtek/rtw88
		rtw_8812au=net/wireless/realtek/rtw88
		rtw_8814a=net/wireless/realtek/rtw88
		rtw_8814au=net/wireless/realtek/rtw88
		rtw_8821a=net/wireless/realtek/rtw88
		rtw_8821au=net/wireless/realtek/rtw88
		rtw_8821ce=net/wireless/realtek/rtw88
		rtw_8821c=net/wireless/realtek/rtw88
		rtw_8821cs=net/wireless/realtek/rtw88
		rtw_8821cu=net/wireless/realtek/rtw88
		rtw_8822be=net/wireless/realtek/rtw88
		rtw_8822b=net/wireless/realtek/rtw88
		rtw_8822bs=net/wireless/realtek/rtw88
		rtw_8822bu=net/wireless/realtek/rtw88
		rtw_8822ce=net/wireless/realtek/rtw88
		rtw_8822c=net/wireless/realtek/rtw88
		rtw_8822cs=net/wireless/realtek/rtw88
		rtw_8822cu=net/wireless/realtek/rtw88
		rtw_core=net/wireless/realtek/rtw88
		rtw_pci=net/wireless/realtek/rtw88
		rtw_sdio=net/wireless/realtek/rtw88
		rtw_usb=net/wireless/realtek/rtw88
	)
	local modargs=( KSRC="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}

src_install() {
	emake "${MODULES_MAKEARGS[@]}" DESTDIR="${ED}" FWDIR="${ED}/lib/firmware/rtw88" install_fw
	linux-mod-r1_src_install
}
