# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	autocfg-1.1.0
	bitflags-1.3.2
	cfg-if-1.0.0
	ctor-0.1.22
	instant-0.1.12
	libc-0.2.126
	lock_api-0.4.7
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	proc-macro2-1.0.40
	quote-1.0.20
	redox_syscall-0.2.13
	scopeguard-1.1.0
	serde-1.0.140
	serde_derive-1.0.140
	smallvec-1.9.0
	syn-1.0.98
	toml-0.5.9
	unicode-ident-1.0.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Unlock vGPU functionality for consumer-grade GPUs on Linux"
HOMEPAGE="https://github.com/mbilker/${PN}"

if [ ${PV} == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mbilker/${PN}.git"
else
	SRC_URI="https://github.com/mbilker/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

src_unpack() {
	default
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_install() {
	default
	dolib.so target/release/libvgpu_unlock_rs.so
	keepdir /etc/vgpu_unlock
}
