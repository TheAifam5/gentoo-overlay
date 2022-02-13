# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo

if [ ${PV} == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mbilker/vgpu_unlock-rs"
else
	SRC_URI="https://github.com/mbilker/vgpu_unlock-rs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
fi


DESCRIPTION="Unlock vGPU functionality for consumer-grade GPUs on Linux"
HOMEPAGE="https://github.com/mbilker/vgpu_unlock-rs"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_unpack() {
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
