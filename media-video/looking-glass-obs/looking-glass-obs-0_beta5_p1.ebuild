# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="LookingGlass"
MY_PV="${PV//0_beta/B}"
MY_PV="${MY_PV/_p/.0.}"
MY_P="${MY_PN}-${MY_PV}"

inherit cmake git-r3

DESCRIPTION="OBS plugin Looking Glass"
HOMEPAGE="https://looking-glass.io/
		https://github.com/gnif/${MY_PN}"
EGIT_REPO_URI="https://github.com/gnif/${MY_PN}.git"

if [[ "${PV}" != *9999* ]]; then
	EGIT_COMMIT="${MY_PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="backtrace debug"

RDEPEND="
	=app-emulation/looking-glass-${PV}
	media-video/obs-studio
	"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPENDS} virtual/pkgconfig"

CMAKE_USE_DIR="${S}"/obs

src_configure() {
	local mycmakeargs=( -DUSER_INSTALL=OFF )

	use backtrace && mycmakeargs+=( -DENABLE_BACKTRACE=ON )

	cmake_src_configure
}

src_install() {
	exeinto /usr/$(get_libdir)/obs-plugins
	newexe ${BUILD_DIR}/liblooking-glass-obs.so obs-looking-glass.so
}
