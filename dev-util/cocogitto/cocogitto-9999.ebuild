# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo

DESCRIPTION="Cocogitto is a set of cli tools for the conventional commit and semver specifications."
HOMEPAGE="https://github.com/${PN}/${PN}"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		$(cargo_crate_uris)"
	KEYWORDS="~amd64 ~x86"
fi

RESTRICT="mirror"
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
IUSE="bash-completion zsh-completion fish-completion"
RDEPEND="
	bash-completion? ( app-shells/bash-completion )
"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_install() {
	default
	cargo_src_install

	install_completion() {
		./target/$(usex debug debug release)/cog generate-completions "$1" > "$1-completion"
		insinto "$2"
		newins "$1-completion" "$3"
	}

	# Install shell completions if enabled
	use bash-completion && install_completion "bash" "/usr/share/bash-completion/completions" "cog"
	use zsh-completion && install_completion "zsh" "/usr/share/zsh/site-functions" "_cog"
	use fish-completion && install_completion "fish" "/usr/share/fish/vendor_completions.d" "cog.fish"
}
