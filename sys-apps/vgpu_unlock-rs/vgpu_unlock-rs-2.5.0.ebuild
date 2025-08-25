# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	autocfg@1.5.0
	bitflags@2.9.3
	cfg-if@1.0.3
	ctor@0.2.9
	equivalent@1.0.2
	hashbrown@0.15.5
	indexmap@2.11.0
	libc@0.2.175
	lock_api@0.4.13
	memchr@2.7.5
	parking_lot@0.12.4
	parking_lot_core@0.9.11
	proc-macro2@1.0.101
	quote@1.0.40
	redox_syscall@0.5.17
	scopeguard@1.2.0
	serde@1.0.219
	serde_derive@1.0.219
	serde_spanned@0.6.9
	smallvec@1.15.1
	syn@2.0.106
	toml@0.8.23
	toml_datetime@0.6.11
	toml_edit@0.22.27
	toml_write@0.1.2
	unicode-ident@1.0.18
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	winnow@0.7.13
"

inherit cargo

DESCRIPTION="Unlock vGPU functionality for consumer-grade GPUs on Linux"
HOMEPAGE="https://github.com/mbilker/vgpu_unlock-rs"

if [ ${PV} == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mbilker/${PN}.git"
else
	SRC_URI="https://github.com/mbilker/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"
	KEYWORDS="-* ~amd64"
fi

LICENSE="MIT Unicode-DFS-2016"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/ba66a6c6eeb16eb8e2d2ec368d6605b974070d4b.patch # Support vGPU 18.x
	"${FILESDIR}"/2b08855f80739ac75b0ca2528ef6b6b599a5086e.patch # Support vGPU 19.x
)

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

	newlib.so target/release/libvgpu_unlock_rs.so libvgpu_unlock.so

	keepdir /etc/vgpu_unlock
	touch "${D}"/etc/vgpu_unlock/profile_override.toml
	touch "${D}"/etc/vgpu_unlock/config.toml
}
