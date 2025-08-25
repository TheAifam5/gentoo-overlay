# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "

inherit udev cargo

DESCRIPTION="A mediated device management utility for Linux"
HOMEPAGE="https://github.com/mdevctl/${PN}"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mdevctl/${PN}.git"
else
	SRC_URI="https://github.com/mdevctl/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/mdevctl/mdevctl/releases/download/v${PV}/mdevctl-${PV}-vendor.tar.gz -> ${P}-vendor.tar.gz
		$(cargo_crate_uris)"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
# Dependent crate licenses
LICENSE+="
	MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/docutils
	virtual/pkgconfig
"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
		ln -s "${WORKDIR}/vendor/"* "${CARGO_HOME}/gentoo/"
	fi
}

src_install() {
	make DESTDIR="${D}" install
	keepdir /etc/mdevctl.d
	keepdir /lib/mdevctl/scripts.d
	keepdir /lib/mdevctl/scripts.d/callouts
	keepdir /lib/mdevctl/scripts.d/notifiers
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
