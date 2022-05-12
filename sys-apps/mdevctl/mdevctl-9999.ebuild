# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
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

BDEPEND="dev-python/docutils"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_compile() {
	default
	RST2MAN="rst2man.py" cargo_src_compile
}

src_install() {
	default
	keepdir /etc/mdevctl.d
	insinto /lib/udev/rules.d/
	doins 60-mdevctl.rules
}
