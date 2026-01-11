# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"
CRATES="
"

inherit shell-completion cargo

DESCRIPTION="Cocogitto is a set of cli tools for the conventional commit and semver specifications."
HOMEPAGE="https://docs.cocogitto.io/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense ZLIB"
SLOT="0"
IUSE="bash-completion elvish-completion fish-completion nushell-completion zsh-completion man"
RDEPEND="
	=dev-libs/libgit2-1.9*:=
	virtual/zlib
	bash-completion? ( app-shells/bash-completion )
	fish-completion? ( app-shells/fish )
	nushell-completion? ( app-shells/nushell )
	zsh-completion? ( app-shells/zsh )
	elvish-completion? ( app-shells/elvish )
"
RESTRICT="mirror"

src_unpack() {
	if [[ "${PV}" == *9999* ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_configure() {
	export LIBGIT2_NO_VENDOR=1
	export PKG_CONFIG_ALLOW_CROSS=1

	cargo_src_configure
}

src_install() {
	cargo_src_install

	if use man; then
		./target/$(usex debug debug release)/cog generate-manpages "${ED}/usr/share/man/man1" || die "Failed to generate man pages"
	fi

	generate_completion() {
		./target/$(usex debug debug release)/cog generate-completions "${1}" &> "cog.${1}" || die "Failed to generate $1 completion"
		echo "cog.${1}"
	}

	# Install shell completions if enabled
	if use bash-completion; then
		newzshcomp "$(generate_completion "bash")" cog
	fi

	if use fish-completion; then
		dofishcomp "$(generate_completion "fish")"
	fi

	if use nushell-completion; then
		insopts -m 0644
		insinto /usr/share/nushell/vendor/autoload
		newins "$(generate_completion "nu")" cog.nu
	fi

	if use zsh-completion; then
		newzshcomp "$(generate_completion "zsh")" _cog
	fi

	if use elvish-completion; then
		insopts -m 0644
		insinto /usr/share/elvish/lib
		newins "$(generate_completion "elvish")" cog.elv
	fi
}
