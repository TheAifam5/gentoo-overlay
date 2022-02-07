# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/heldercorreia/speedcrunch.git"
	S="${WORKDIR}/${P}/src"
else
	SRC_URI="https://bitbucket.org/heldercorreia/${PN}/get/release-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/heldercorreia-speedcrunch-ea93b21f9498/src"
fi

DESCRIPTION="Fast and usable calculator for power users"
HOMEPAGE="https://speedcrunch.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( dev-python/sphinx dev-python/sphinx-quark-theme dev-python/sphinx-qthelp )"

src_install() {
	use doc && local HTML_DOCS=( ../doc/build_html_embedded/. )
	cmake_src_install
	doicon -s scalable ../gfx/speedcrunch.svg
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

