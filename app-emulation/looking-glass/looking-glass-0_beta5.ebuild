# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="LookingGlass"
MY_PV="${PV//0_beta/B}"
MY_P="${MY_PN}-${MY_PV}"

inherit cmake git-r3 desktop

DESCRIPTION="A low latency KVM FrameRelay implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.io/
		https://github.com/gnif/${MY_PN}"
EGIT_REPO_URI="https://github.com/gnif/${MY_PN}.git"

if [[ "${PV}" != *9999* ]]; then
	EGIT_COMMIT=${MY_PV}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="X opengl egl wayland libdecor debug"
REQUIRED_USE="
	libdecor? ( wayland )
	opengl? ( egl )
	|| ( X wayland )
"

RDEPEND="
	media-libs/fontconfig:1.0
	wayland? (
		dev-libs/wayland
		x11-libs/libxkbcommon
		libdecor? ( gui-libs/libdecor )
		egl? ( gui-libs/egl-wayland )
	)
	X? (
	   x11-libs/libX11
	   x11-libs/libXi
	   x11-libs/libXfixes
	   x11-libs/libXScrnSaver
	   x11-libs/libXinerama
	   x11-libs/libXcursor
	   x11-libs/libXpresent
	)
	opengl? ( virtual/opengl )
	egl? ( virtual/opengl )
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

CMAKE_USE_DIR="${S}"/client

src_configure() {
	local mycmakeargs=(
		-DENABLE_X11=$(usex X)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_OPENGL=$(usex opengl)
		-DENABLE_EGL=$(usex egl)
		-DENABLE_LIBDECOR=$(usex libdecor)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	domenu	"${FILESDIR}"/looking-glass.desktop
}
