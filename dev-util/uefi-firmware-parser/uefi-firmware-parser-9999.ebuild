# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=(python3_{8,9,10} pypy3)

inherit distutils-r1

DESCRIPTION="Parse BIOS/Intel ME/UEFI firmware related structures: Volumes, FileSystems, Files, etc."
HOMEPAGE="https://github.com/theopolis/${PN}"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/theopolis/${PN}.git"
else
	SRC_URI="https://github.com/theopolis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Custom"
SLOT="0"
IUSE=""

distutils_enable_tests setup.py
