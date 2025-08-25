# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/archive/v${PV}.tar.gz -> kubernetes-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="hardened bash-completion zsh-completion fish-completion"

BDEPEND=">=dev-lang/go-1.23.3"
RDEPEND="
	bash-completion? ( app-shells/bash-completion )
"
RESTRICT+=" test"
S="${WORKDIR}/kubernetes-${PV}"

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		emake -j1 GOFLAGS="${GOFLAGS}" GOLDFLAGS="" LDFLAGS="" FORCE_HOST_GO=yes WHAT=cmd/${PN}
}

src_install() {
	dobin _output/bin/${PN}

	install_completion() {
		_output/bin/${PN}  completion "$1" > "$1-completion"
		insinto "$2"
		newins "$1-completion" "$3"
	}

	# Install shell completions if enabled
	use bash-completion && install_completion "bash" "/usr/share/bash-completion/completions" "${PN}"
	use zsh-completion && install_completion "zsh" "/usr/share/zsh/site-functions" "_${PN}"
	use fish-completion && install_completion "fish" "/usr/share/fish/vendor_completions.d" "${PN}.fish"
}
