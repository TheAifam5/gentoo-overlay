# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Disk benchmarking tool"
HOMEPAGE="https://github.com/JonMagon/KDiskMark"
EGIT_REPO_URI="https://github.com/JonMagon/KDiskMark.git"
S="${WORKDIR}/${PN}-${PV}"

inherit cmake

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

DEPEND="
	dev-qt/qtbase:6[gui,widgets,network,dbus]
	dev-qt/qttools:6[linguist]
	kde-frameworks/extra-cmake-modules
	sys-auth/polkit-qt
	sys-block/fio[aio]"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DQT_DEFAULT_MAJOR_VERSION=6
	)
	cmake_src_configure
}
