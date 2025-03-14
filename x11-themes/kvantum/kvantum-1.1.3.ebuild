# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QT5MIN="5.15.0"
QT6MIN="6.6.0"
KF5MIN="5.82.0"
KF6MIN="6.0.0"

inherit cmake multibuild xdg

DESCRIPTION="SVG-based theme engine for Qt5, KDE Plasma and LXQt"
HOMEPAGE="https://github.com/tsujan/Kvantum"
SRC_URI="https://github.com/tsujan/${PN^}/archive/V${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN^}-${PV}/${PN^}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="qt5 +qt6 kde linguist"
REQUIRED_USE="|| ( qt5 qt6 )"
RESTRICT="test" # no tests

CDEPEND="
	qt5? (
		>=dev-qt/qtcore-${QT5MIN}:5
		>=dev-qt/qtgui-${QT5MIN}:5
		>=dev-qt/qtsvg-${QT5MIN}:5
		>=dev-qt/qtwidgets-${QT5MIN}:5
		>=dev-qt/qtx11extras-${QT5MIN}:5
		kde? ( >=kde-frameworks/kwindowsystem-${KF5MIN}:5 )
	)
	qt6? (
		>=dev-qt/qtbase-${QT6MIN}:6[X,gui,widgets]
		>=dev-qt/qtsvg-${QT6MIN}:6
		kde? ( >=kde-frameworks/kwindowsystem-${KF6MIN}:6 )
	)
	x11-libs/libX11
"
DEPEND="
	${CDEPEND}
	x11-base/xorg-proto
"
RDEPEND="
	${CDEPEND}
"
BDEPEND="
	linguist? ( qt5? ( >=dev-qt/linguist-tools-${QT5MIN}:5 ) )
	qt6? ( >=dev-qt/qttools-${QT6MIN}:6[linguist?] )
"

pkg_setup() {
	MULTIBUILD_VARIANTS=($(usev qt5) qt6)
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			-DENABLE_QT4=OFF
		)
		if [[ ${MULTIBUILD_VARIANT} = qt5 ]]; then
			mycmakeargs+=(
				-DENABLE_QT5=ON
				-DWITHOUT_KF=$(usex !kde)
			)
		elif [[ ${MULTIBUILD_VARIANT} = qt6 ]]; then
			mycmakeargs+=(
				-DENABLE_QT5=OFF
				-DWITHOUT_KF=$(usex !kde)
			)
		fi
		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install

	einstalldocs
}
