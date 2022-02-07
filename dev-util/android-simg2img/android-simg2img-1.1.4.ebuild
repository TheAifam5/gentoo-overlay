# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool to convert Android sparse images to raw images."
HOMEPAGE="https://github.com/anestisb/android-simg2img"
SRC_URI="https://github.com/anestisb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	emake PREFIX="${D}/usr" install

	dodoc README.md
}
