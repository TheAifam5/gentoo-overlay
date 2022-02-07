
# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="LookingGlass"
MY_PV="${PV//0_beta/B}"
MY_P="${MY_PN}-${MY_PV}"

inherit git-r3 linux-info linux-mod

DESCRIPTION="KVM kermel module for Looking Glass"
HOMEPAGE="https://looking-glass.io/
		https://github.com/gnif/LookingGlass/"
EGIT_REPO_URI="https://github.com/gnif/${MY_PN}"
EGIT_COMMIT=${MY_PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND=""
DEPEND="=app-emulation/looking-glass-${PV}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${P}"

MODULE_NAMES="kvmfr(kvmfr:${S}/module:${S}/module)"
BUILD_TARGETS="clean modules"
BUILD_PARAMS="KDIR=/usr/src/linux-5.11_p8-pf"

src_compile() {
	local myABI="${ABI}"
	set_arch_to_kernel
	ABI="${KERNEL_ABI}"
	emake -C ${KERNEL_DIR} M="${S}"/module clean modules || die "Unable to compile the module"
	set_arch_to_portage
	ABI="${myABI}"
}
