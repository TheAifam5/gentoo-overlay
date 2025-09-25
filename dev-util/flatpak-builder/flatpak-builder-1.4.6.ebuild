# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"
DESCRIPTION="Tool to build flatpaks from source"
HOMEPAGE="http://flatpak.org/"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc +yaml +debugedit +fuse"

RDEPEND="
	>=dev-libs/glib-2.66:2=
	dev-libs/json-glib:=
	net-misc/curl:=
	>=dev-libs/elfutils-0.8.12:=
	>=dev-libs/libxml2-2.4:=
	>=dev-util/ostree-2019.5:=
	yaml? ( dev-libs/libyaml:= )

	>=dev-libs/appstream-1.0.0:=[compose]
	>=sys-apps/flatpak-0.99.1

	>=dev-util/debugedit-5.0:=
	sys-fs/fuse:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.18.2
	virtual/pkgconfig
	doc? (
		app-text/xmlto
		dev-libs/libxslt
	)
"

PATCHES=("${FILESDIR}/flatpak-builder-1.2.2-musl.patch")

src_configure() {
	econf \
		$(use_enable doc documentation) \
		$(use_enable doc docbook-docs) \
		$(use_with yaml) \
		$(use_with debugedit system-debugedit)
}
