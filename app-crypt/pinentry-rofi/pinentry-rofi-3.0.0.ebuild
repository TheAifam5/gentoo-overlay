# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="rofi-based pinentry implementation"
HOMEPAGE="https://github.com/plattfot/${PN}"
SRC_URI="https://github.com/plattfot/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

DEPEND="
	>=dev-scheme/guile-2.0.0
"
RDEPEND="
	${DEPEND}
	|| ( gui-apps/rofi gui-apps/rofi-wayland )
"
BDEPEND="
	dev-build/autoconf-archive
"

src_prepare() {
	default
	eautoreconf
}
