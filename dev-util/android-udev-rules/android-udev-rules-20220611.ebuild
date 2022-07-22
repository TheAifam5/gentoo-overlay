# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="Comprehensive list of udev rules to connect to android devices"
HOMEPAGE="https://github.com/M0Rf30/${PN}"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/M0Rf30/${PN}.git"
else
	SRC_URI="https://github.com/M0Rf30/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

RDEPEND="
	acct-group/adbusers
	virtual/udev
"

src_install() {
	udev_dorules 51-android.rules
}

pkg_postinst() {
	einfo "To be able to use android devices,"
	einfo "add yourself to the 'adbusers' group by calling"
	einfo "  usermod -a -G adbusers <user>"
}
