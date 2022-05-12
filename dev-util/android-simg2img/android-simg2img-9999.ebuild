# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool to convert Android sparse images to raw images."
HOMEPAGE="https://github.com/anestisb/${PN}"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/anestisb/${PN}.git"
else
	SRC_URI="https://github.com/anestisb/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
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
