# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev linux-mod

DESCRIPTION="Collection of Linux drivers for Razer devices."
HOMEPAGE="https://openrazer.github.io/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

IUSE="keyboard mouse kraken accessory +udev"
REQUIRED_USE="|| ( keyboard mouse kraken accessory )"

RDEPEND="udev? ( virtual/udev )"
DEPEND="${RDEPEND}"

LICENSE="GPL-2"
SLOT="0"

BUILD_PARAMS="-C ${KERNEL_DIR} M=${S}/driver"
BUILD_TARGETS="clean modules"

src_compile() {
	MODULE_NAMES="
		$(usex keyboard "razerkbd(hid:${S}/driver)" "")
		$(usex mouse "razermouse(hid:${S}/driver)" "")
		$(usex kraken "razerkraken(hid:${S}/driver)" "")
		$(usex accessory "razeraccessory(hid:${S}/driver)" "")
	"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	if use udev; then
		# Install udev rules
		udev_dorules install_files/udev/99-razer.rules
		exeinto "$(get_udevdir)"
		doexe install_files/udev/razer_mount
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst
	use udev && udev_reload
}

pkg_postrm() {
	linux-mod_pkg_postrm
	use udev && udev_reload
}
