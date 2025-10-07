# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module shell-completion

DESCRIPTION="The Multiple Runtime Version Manager"
HOMEPAGE="https://asdf-vm.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/asdf-vm/asdf.git"
else
	MY_PV=${PV/_/-}
	SRC_URI="https://github.com/asdf-vm/asdf/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
			https://github.com/TheAifam5/gentoo-overlay/raw/main/${CATEGORY}/${PN}/${PN}-${PV}-vendor.tar.xz
			https://github.com/TheAifam5/gentoo-overlay/raw/main/${CATEGORY}/${PN}/${PN}-${PV}-deps.tar.xz"
	KEYWORDS="~amd64 ~arm64"
	S="${WORKDIR}/asdf-${MY_PV}"
fi

LICENSE="Apache-2.0"
SLOT="2"

IUSE="bash-completion elvish-completion fish-completion nushell-completion zsh-completion test"

RDEPEND="
	net-misc/curl
	dev-vcs/git
	bash-completion? ( app-shells/bash-completion )
	fish-completion? ( app-shells/fish )
	nushell-completion? ( app-shells/nushell )
	zsh-completion? ( app-shells/zsh )
	elvish-completion? ( app-shells/elvish )
"
BDEPEND="
	>=dev-lang/go-1.23.4
	test? ( dev-util/bats )
"

RESTRICT="!test? ( test )"

src_compile() {
	local version

	if [[ ${PV} == 9999 ]]; then
		version="$(./scripts/asdf-version)"
	else
		version=${MY_PV}
	fi

	ego build -o asdf -ldflags "-X main.version=${version}" ./cmd/asdf
}

src_test() {
	if ! ./asdf --version; then
		die "asdf version test failed"
	fi

	# Avoid error like:
	# -buildmode=pie not supported when -race is enabled on linux/amd64
	# Skipped tests:
	# TestBatsTests/plugin_add_command - no internet connection in build environment
	# TestBatsTests/plugin_extension_command - $PROJECT_DIR is not defined
	# TestBatsTests/shim_exec - not ok 4 asdf exec should pass all arguments to executable even if shim is not in PATH
	GOFLAGS=${GOFLAGS//-buildmode=pie/}
	ego test \
		-skip 'TestBatsTests/plugin_add_command|TestBatsTests/plugin_extension_command|TestBatsTests/shim_exec' \
		-coverpkg=./... \
		-coverprofile=coverage.txt \
		-bench= \
		-v -race -ldflags "-s -X main.version=${version}" \
		./...
}

src_install() {
	dobin asdf

	dodoc help.txt
	dodoc README.md
	dodoc LICENSE
	dodoc CONTRIBUTING.md

	if use bash-completion; then
		newbashcomp internal/completions/asdf.bash asdf
	fi

	if use elvish-completion; then
		insopts -m 0644
		insinto /usr/share/elvish/lib
		newins internal/completions/asdf.elvish asdf.elv
	fi

	if use fish-completion; then
		dofishcomp internal/completions/asdf.fish
	fi

	if use nushell-completion; then
		insopts -m 0644
		insinto /usr/share/nushell/vendor/autoload
		newins internal/completions/asdf.nushell asdf.nu
	fi

	if use zsh-completion; then
		newzshcomp internal/completions/asdf.zsh _asdf
	fi
}
