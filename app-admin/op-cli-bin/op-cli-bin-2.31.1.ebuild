# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/_beta/-beta.}"

DESCRIPTION="Command line interface for the 1Password password manager"
HOMEPAGE="https://1password.com/downloads/command-line/"
SITE="https://cache.agilebits.com/dist/1P/op2/pkg/v${MY_PV}"
SRC_URI="
amd64? ( ${SITE}/op_linux_amd64_v${MY_PV}.zip )
arm? ( ${SITE}/op_linux_arm_v${MY_PV}.zip )
arm64? ( ${SITE}/op_linux_arm64_v${MY_PV}.zip )
x86? ( ${SITE}/op_linux_386_v${MY_PV}.zip )
"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86"

BDEPEND="app-arch/unzip"
RDEPEND="acct-group/onepassword-cli"

QA_PREBUILT="usr/bin/op"
RESTRICT="bindist mirror"
S="${WORKDIR}"

src_install() {
  dobin op
}

pkg_postinst() {
  chgrp onepassword-cli /usr/bin/op
  chmod g+s /usr/bin/op
}
