# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 bash-completion-r1 go-module

DESCRIPTION="The clusterctl CLI tool handles the lifecycle of a Cluster API management cluster."
HOMEPAGE="https://cluster-api.sigs.k8s.io/"
SRC_URI="https://github.com/TheAifam5/gentoo-overlay/raw/main/sys-cluster/clusterctl/cluster-api-v${PV}-deps.tar.xz"
EGIT_REPO_URI="https://github.com/kubernetes-sigs/cluster-api.git"
EGIT_COMMIT="v${PV}"

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

src_unpack() {
	git-r3_src_unpack
	go-module_src_unpack
}

src_compile() {
	emake -j1 LDFLAGS="-extldflags '$(usex hardened '-fno-PIC' '')' $(hack/version.sh)" ${PN}
}

src_install() {
	dobin bin/${PN}
	einstalldocs

	install_completion() {
		bin/${PN} completion "$1" > "$1-completion"
		insinto "$2"
		newins "$1-completion" "$3"
	}

	# Install shell completions if enabled
	use bash-completion && install_completion "bash" "/usr/share/bash-completion/completions" "${PN}"
	use zsh-completion && install_completion "zsh" "/usr/share/zsh/site-functions" "_${PN}"
}
