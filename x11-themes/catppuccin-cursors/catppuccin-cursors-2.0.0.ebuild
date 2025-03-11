# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

VARIANTS=(
	latte
	frappe
	macchiato
	mocha
)

COLORS=(
	rosewater
	flamingo
	pink
	mauve
	red
	maroon
	peach
	yellow
	green
	teal
	sky
	sapphire
	blue
	lavender
	dark
	light
)

DESCRIPTION="Catppuccin mouse cursors (based on Volantes cursors)"
HOMEPAGE="https://github.com/catppuccin/cursors"

SRC_URI="$(for variant in "${VARIANTS[@]}"; do for color in "${COLORS[@]}"; do echo "https://github.com/catppuccin/cursors/releases/download/v${PV}/catppuccin-${variant}-${color}-cursors.zip -> catppuccin-${variant}-${color}-cursors-${PV}.zip"; done; done)"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

IUSE="${VARIANTS[*]} ${COLORS[*]}"
REQUIRED_USE="|| ( $(for variant in "${VARIANTS[@]}"; do echo "${variant}? ( || ( ${COLORS[*]} ) )"; done) )"

RESTRICT="mirror"

src_install() {
	insinto "/usr/share/icons"
	for variant in "${VARIANTS[@]}"; do
		for color in "${COLORS[@]}"; do
			use "${variant}" && use "${color}" && doins -r "catppuccin-${variant}-${color}-cursors"
		done
	done
}
