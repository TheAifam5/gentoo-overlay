# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils

MY_PN="${PN//-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The design and use of the Talos Linux control application."
HOMEPAGE="https://www.talos.dev/"
SRC_URI="
	amd64? ( https://github.com/siderolabs/talos/releases/download/v${PV}/${MY_PN}-linux-amd64 -> ${MY_P} )
"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bash-completion zsh-completion fish-completion"
RESTRICT="bindist mirror"

RDEPEND="
	bash-completion? ( app-shells/bash-completion )
"

S="${WORKDIR}"

QA_PREBUILD="/usr/bin/${MY_PN}"

src_install() {
	cp "${DISTDIR}/${MY_P}" .
	chmod +x "${MY_P}"
	newbin "${MY_P}" "${MY_PN}"
	pax-mark -m "${ED}"/usr/bin/${MY_PN}

	install_completion() {
		./${MY_P} completion "$1" > "$1-completion"
		insinto "$2"
		newins "$1-completion" "$3"
	}

	# Install shell completions if enabled
	use bash-completion && install_completion "bash" "/usr/share/bash-completion/completions" "${MY_PN}"
	use zsh-completion && install_completion "zsh" "/usr/share/zsh/site-functions" "_${MY_PN}"
	use fish-completion && install_completion "fish" "/usr/share/fish/vendor_completions.d" "${MY_PN}.fish"
}
