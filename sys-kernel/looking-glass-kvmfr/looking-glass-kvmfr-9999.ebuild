
# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="LookingGlass"
MY_PV="${PV//0_beta/B}"
MY_P="${MY_PN}-${MY_PV}"

inherit git-r3 linux-mod

DESCRIPTION="KVM kermel module for Looking Glass"
HOMEPAGE="https://looking-glass.io/
		https://github.com/gnif/${MY_PN}"
EGIT_REPO_URI="https://github.com/gnif/${MY_PN}.git"

if [[ "${PV}" != *9999* ]]; then
	EGIT_COMMIT=${MY_PV}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

RDEPEND=""
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P}"

MODULE_NAMES="kvmfr(kvmfr:${S}/module:${S}/module)"
BUILD_TARGETS="clean all"

src_compile() {
	BUILD_PARAMS="KDIR=${KERNEL_DIR} KVER=${KV_FULL}"
	linux-mod_src_compile
}
