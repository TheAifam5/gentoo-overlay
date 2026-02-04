# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="Multi-container orchestration for Docker"
HOMEPAGE="https://github.com/docker/mcp-gateway"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/docker/mcp-gateway.git"
	S="${WORKDIR}/docker-mcp-${PV}"
else
	SRC_URI="https://github.com/docker/mcp-gateway/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
    	https://github.com/TheAifam5/gentoo-overlay/raw/main/${CATEGORY}/${PN}/${PN}-${PV}-vendor.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/mcp-gateway-${PV}"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="|| (
	>=app-containers/docker-cli-23.0.0
	app-containers/podman[wrapper(+)]
)"
BDEPEND=">=dev-lang/go-1.24.7"

RESTRICT="test"

src_compile() {
	local version

	if [[ ${PV} == 9999 ]]; then
		version="$(git describe --tags --exact-match HEAD 2>/dev/null || git rev-parse HEAD)"
	else
		version="v${PV}"
	fi

	ego build -o docker-mcp \
		-ldflags "-X github.com/docker/mcp-gateway/cmd/docker-mcp/version.Version=${version}" \
		./cmd/docker-mcp
}

src_test() {
	ego test ./...
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe docker-mcp
	dodoc README.md
}
