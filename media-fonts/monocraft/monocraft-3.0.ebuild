# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

BASE_URI="https://github.com/IdreesInc/${PN}/releases/download/v${PV}"

DESCRIPTION="A monospaced programming font inspired by the Minecraft typeface"
HOMEPAGE="https://idreesinc.com/monocraft.html"
LICENSE="OFL-1.1"
SRC_URI="
	nerdfonts? ( ${BASE_URI}/Monocraft-nerd-fonts-patched.ttf -> monocraft-nerd-fonts-${PV}.ttf )
	noligatures? ( ${BASE_URI}/Monocraft-no-ligatures.ttf -> monocraft-no-ligatures-${PV}.ttf )
	ttf? ( ${BASE_URI}/Monocraft.ttf -> monocraft-${PV}.ttf )
	otf? ( ${BASE_URI}/Monocraft.otf -> monocraft-${PV}.otf )
"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="otf ttf nerdfonts noligatures"
REQUIRED_USE="
	|| ( otf ttf )
	ttf? ( ?? ( nerdfonts noligatures ) )
"
S="${WORKDIR}"

FONT_SUFFIX="ttf otf"

src_prepare() {
	default
	use otf && { cp "${DISTDIR}"/${P}.otf "${S}"/${PN}.otf || die ; }
	use ttf && { cp "${DISTDIR}"/${P}.ttf "${S}"/${PN}.ttf || die ; }
	use noligatures && { cp "${DISTDIR}"/${PN}-no-ligatures-${PV}.ttf "${S}"/${PN}.ttf || die ; }
	use nerdfonts && { cp "${DISTDIR}"/${PN}-nerd-fonts-${PV}.ttf "${S}"/${PN}.ttf || die ; }
}

src_install() {
	use otf && { FONT_SUFFIX="otf"; }
	use ttf && { FONT_SUFFIX="ttf"; }

	font_src_install
}
