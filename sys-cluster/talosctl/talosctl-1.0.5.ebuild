# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 go-module

DESCRIPTION="The design and use of the Talos Linux control application."
HOMEPAGE="https://www.talos.dev/"
SRC_URI="https://github.com/siderolabs/talos/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		 https://github.com/TheAifam5/gentoo-overlay/raw/main/sys-cluster/talosctl/talos-v${PV}-deps.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="hardened bash-completion zsh-completion fish-completion"
RESTRICT+=" mirror"

DOCS=( {README,CHANGELOG}.md )

RDEPEND="
	bash-completion? ( app-shells/bash-completion )
"

S="${WORKDIR}/talos-${PV}"

src_compile() {
	 CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" ego build ./cmd/${PN}
}

src_install() {
	dobin talosctl
	einstalldocs

	install_completion() {
		./talosctl completion "$1" > "$1-completion"
		insinto "$2"
		newins "$1-completion" "$3"
	}

	# Install shell completions if enabled
	use bash-completion && install_completion "bash" "/usr/share/bash-completion/completions" "${PN}"
	use zsh-completion && install_completion "zsh" "/usr/share/zsh/site-functions" "_${PN}"
	use fish-completion && install_completion "fish" "/usr/share/fish/vendor_completions.d" "${PN}.fish"
}
