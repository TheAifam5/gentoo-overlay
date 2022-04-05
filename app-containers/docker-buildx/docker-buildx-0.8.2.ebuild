# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit bash-completion-r1 go-module

# See: https://api.github.com/repos/docker/buildx/tags
MY_PV_REV="6224def4dd2c3d347eee19db595348c50d7cb491"

DESCRIPTION="Docker CLI plugin for extended build capabilities with BuildKit"
HOMEPAGE="https://github.com/docker/buildx"
SRC_URI="https://github.com/docker/buildx/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=app-containers/docker-cli-20.10.3"

S="${WORKDIR}/buildx-${PV}"

src_prepare() {
	default

    # copy prepared makefile for this version
    cp "${FILESDIR}"/builder-${PV}.Makefile builder.Makefile
}

src_compile() {
	emake -f builder.Makefile GIT_TAG=v${PV} GIT_REV=${MY_PV_REV}
}

src_test() {
	emake -f builder.Makefile test
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe bin/docker-buildx
	dodoc README.md
}

pkg_postinst() {
	ewarn "docker-buildx is a sub command of docker"
	ewarn "Use 'docker buildx' from the command line instead of"
	ewarn "'docker-buildx'"
}
