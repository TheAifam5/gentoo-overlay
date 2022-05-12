# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	ansi_term-0.11.0
	anyhow-1.0.44
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.3.2
	cfg-if-1.0.0
	clap-2.33.3
	env_logger-0.8.4
	getrandom-0.2.3
	hashbrown-0.11.2
	heck-0.3.3
	humantime-2.1.0
	hermit-abi-0.1.19
	indexmap-1.7.0
	itoa-0.4.8
	lazy_static-1.4.0
	libc-0.2.103
	log-0.4.14
	memchr-2.4.1
	ppv-lite86-0.2.10
	proc-macro2-1.0.29
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	quote-1.0.9
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_hc-0.3.1
	regex-1.5.4
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	ryu-1.0.5
	serde-1.0.130
	serde_json-1.0.68
	strsim-0.8.0
	structopt-0.3.23
	structopt-derive-0.4.16
	syn-1.0.77
	redox_syscall-0.2.10
	tempfile-3.2.0
	termcolor-1.1.2
	textwrap-0.11.0
	unicode-segmentation-1.8.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	uuid-0.8.2
	vec_map-0.8.2
	version_check-0.9.3
	wasi-0.10.2+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-util-0.1.5
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A mediated device management utility for Linux"
HOMEPAGE="https://github.com/mdevctl/${PN}"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mdevctl/${PN}.git"
else
	SRC_URI="https://github.com/mdevctl/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

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
	keepdir /etc/mdevctl.d
	insinto /lib/udev/rules.d/
	doins 60-mdevctl.rules
}
