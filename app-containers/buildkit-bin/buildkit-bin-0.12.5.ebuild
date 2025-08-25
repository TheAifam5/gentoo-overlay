# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils systemd

MY_PN="${PN//-bin/}"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="concurrent, cache-efficient, and Dockerfile-agnostic builder toolkit"
HOMEPAGE="https://github.com/moby/buildkit"
SRC_URI="
	amd64? ( https://github.com/moby/buildkit/releases/download/v${PV}/${MY_P}.linux-amd64.tar.gz )
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="bindist mirror"

S="${WORKDIR}/bin"

QA_PREBUILD="
	/usr/bin/buildctl
	/usr/bin/${MY_PN}d
	/usr/bin/${MY_PN}-qemu-aarch64
	/usr/bin/${MY_PN}-qemu-arm
	/usr/bin/${MY_PN}-qemu-i386
	/usr/bin/${MY_PN}-qemu-mips64
	/usr/bin/${MY_PN}-qemu-mips64le
	/usr/bin/${MY_PN}-qemu-ppc64le
	/usr/bin/${MY_PN}-qemu-riscv64
	/usr/bin/${MY_PN}-qemu-s390x
	/usr/bin/${MY_PN}-runc
"

src_install() {
	for file in *; do
		dobin ${file}
		pax-mark -m "${ED}"/"${file}"
	done

	systemd_dounit "${FILESDIR}/system/buildkit.service"
	systemd_dounit "${FILESDIR}/system/buildkit.socket"

	systemd_douserunit "${FILESDIR}/user/buildkit-proxy.service"
	systemd_douserunit "${FILESDIR}/user/buildkit-proxy.socket"
	systemd_douserunit "${FILESDIR}/user/buildkit.service"
}
