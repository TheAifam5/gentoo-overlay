# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake lua-single

DESCRIPTION="Open Tibia Client"
HOMEPAGE="https://github.com/mehah/${PN}"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mehah/${PN}.git"
else
	SRC_URI="https://github.com/mehah/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+bot-protection lto libcxx +crash-handler"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	media-libs/libglvnd[X]
	dev-libs/boost
	${LUA_DEPS}
	dev-games/physfs
	|| ( sys-libs/zlib sys-libs/zlib-ng )
	dev-libs/protobuf
	app-arch/lzma
	media-libs/glew
	sys-libs/ncurses
	media-libs/openal
	dev-libs/openssl
	media-libs/libvorbis
	media-libs/libogg
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
	dev-build/cmake
	dev-cpp/nlohmann_json
	libcxx? ( sys-libs/libcxx )
	${LUA_DEPS}
"

src_configure() {
	local mycmakeargs=(
		-DBOT_PROTECTION=$(usex bot-protection ON OFF)
		-DUSE_LTO=$(usex lto ON OFF)
		-DUSE_LIBCPP=$(usex libcxx ON OFF)
		-DCRASH_HANDLER=$(usex crash-handler ON OFF)
		-DLUAJIT=$(usex lua_single_target_luajit ON OFF)
		-DUSE_STATIC_LIBS=OFF
	)
	cmake_src_configure
}
