# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module systemd

DESCRIPTION="dockerd as a compliant Container Runtime Interface for Kubernetes"
HOMEPAGE="https://mirantis.github.io/cri-dockerd/"
SRC_URI="https://github.com/Mirantis/cri-dockerd/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
IUSE="hardened selinux"

BDEPEND=">=dev-lang/go-1.20"
RDEPEND="selinux? ( sec-policy/selinux-cri-dockerd )"

RESTRICT+=" test mirror"

REVISION=178ed782

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" \
		VERSION="${PV}" REVISION="${REVISION}" \
		cri-dockerd
}

src_install() {
	dobin ./${PN}
	systemd_dounit ./packaging/systemd/cri-docker.service
	systemd_dounit ./packaging/systemd/cri-docker.socket
}
