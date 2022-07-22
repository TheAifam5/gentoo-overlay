# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command line interface for the 1Password Password Manager"
HOMEPAGE="https://1password.com/downloads/command-line/"
SRC_URI="amd64? ( https://cache.agilebits.com/dist/1P/op2/pkg/v${PV}/op_linux_amd64_v${PV}.zip )"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

IUSE="bash-completion zsh-completion fish-completion"

BDEPEND="app-arch/unzip"
RDEPEND="
  bash-completion? ( app-shells/bash-completion )
"

QA_PREBUILT="usr/bin/op"
RESTRICT="bindist mirror test strip"
S="${WORKDIR}"

src_install() {
  # Install op binary
  dobin op

  install_completion() {
    ./op completion "$1" > "$1-completion"
    insinto "$2"
    newins "$1-completion" "$3"
  }

  # Install shell completions if enabled
  use bash-completion && install_completion "bash" "/usr/share/bash-completion/completions" "op"
  use zsh-completion && install_completion "zsh" "/usr/share/zsh/site-functions" "_op"
  use fish-completion && install_completion "fish" "/usr/share/fish/vendor_completions.d" "op.fish"
}
