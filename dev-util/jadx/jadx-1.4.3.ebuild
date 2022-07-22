# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-utils-2 gradle

DESCRIPTION="Android Dex to Java decompiler"
HOMEPAGE="https://github.com/skylot/${PN}"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/skylot/${PN}.git"
	EGIT_SUBMODULES=( "*" "-*test*" )
else
	SRC_URI="https://github.com/skylot/${PN}/archive/refs/tags/v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="quark-engine"

RDEPEND="
	>=virtual/jre-1.7:*
	quark-engine? ( dev-python/quark-engine )
	dev-util/android-commandlinetools-bin
"
DEPEND="
	${RDEPEND}
	virtual/gradle
"

src_compile() {
	EGRADLE_BIN="./gradlew" egradle dist -Pgradle_installPath=dist
}

src_install() {
	cd "${S}/build/${PN}/lib";
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar}
	done

	java-pkg_dolauncher ${PN} --main jadx.cli.JadxCLI
	java-pkg_dolauncher ${PN}-gui --main jadx.gui.JadxGUI

	newicon "${S}"/jadx-gui/src/main/resources/logos/jadx-logo.svg jadx.svg
	domenu "${FILESDIR}/jadx-gui.desktop"
}
