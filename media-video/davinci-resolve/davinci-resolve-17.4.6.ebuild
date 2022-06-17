# Copyright 2021
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker

DESCRIPTION="Professional A/V post-production software suite"
HOMEPAGE="https://www.blackmagicdesign.com/"
SRC_URI="DaVinci_Resolve_${PV}_Linux.run"

RESTRICT="fetch mirror strip"

KEYWORDS="~amd64"
SLOT="0"
LICENSE="DavinciResolve"

IUSE="keyboards panels braw"
BDEPEND=""
RDEPEND="virtual/libcrypt:="

RESOLVE_NAME="DaVinci Resolve"

S="${WORKDIR}"

QA_PREBUILT="opt/davinci-resolve"

src_unpack() {
	cp ${DISTDIR}/${A} .
	chmod +x ./${A}
}

src_configure() {
	./${A} --appimage-extract
}

src_install() {
	./squashfs-root/installer -i -y -a -C "${ED}/opt/davinci-resolve" ./squashfs-root

	# Remove uninstaller files
	rm "${ED}"/opt/davinci-resolve/share/DaVinciResolveInstaller.desktop
	rm "${ED}"/opt/davinci-resolve/installer{,.dat}
	rm "${ED}"/opt/davinci-resolve/graphics/DV_Uninstall.png

	# apply RESOLVE_INSTALL_LOCATION
	grep -rlI "RESOLVE_INSTALL_LOCATION" "${ED}" | xargs sed -i 's/RESOLVE_INSTALL_LOCATION/\/opt\/davinci\-resolve/g'

	# copy etc udev rules
	cp -r "${ED}"/opt/davinci-resolve/share/etc "${ED}"

	# copy application
	mkdir -p "${ED}"/usr/share/applications
	cp "${ED}"/opt/davinci-resolve/share/*.desktop "${ED}"/usr/share/applications
}
