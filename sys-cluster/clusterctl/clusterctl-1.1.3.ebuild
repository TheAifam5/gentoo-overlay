# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module

DESCRIPTION="The clusterctl CLI tool handles the lifecycle of a Cluster API management cluster."
HOMEPAGE="https://cluster-api.sigs.k8s.io/"
SRC_URI="https://github.com/kubernetes-sigs/cluster-api/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		 https://github.com/TheAifam5/gentoo-overlay/raw/main/sys-cluster/clusterctl/cluster-api-v${PV}-deps.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hardened bash-completion zsh-completion"
RESTRICT+=" test"

DOCS=( README.md )

BDEPEND=">=dev-lang/go-1.18.1"
RDEPEND="
	bash-completion? ( app-shells/bash-completion )
"
RESTRICT+=" test"
S="${WORKDIR}/cluster-api-${PV}"

src_compile() {
	 CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" ego build ./cmd/${PN}
}

src_install() {
	dobin ${PN}
	einstalldocs

	install_completion() {
		./${PN} completion "$1" > "$1-completion"
		insinto "$2"
		newins "$1-completion" "$3"
	}

	# Install shell completions if enabled
	use bash-completion && install_completion "bash" "/usr/share/bash-completion/completions" "${PN}"
	use zsh-completion && install_completion "zsh" "/usr/share/zsh/site-functions" "_${PN}"
}
