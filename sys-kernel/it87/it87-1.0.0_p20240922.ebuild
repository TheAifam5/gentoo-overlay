# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT_ID="213db3aa999e9cb14d8b9a7f84d711e15d2619f6"

DESCRIPTION="IT87 sensors module"
HOMEPAGE="https://github.com/frankcrawford/it87"
SRC_URI="https://github.com/frankcrawford/it87/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/it87-${COMMIT_ID}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

CONFIG_CHECK="HWMON ~!CONFIG_SENSORS_IT87"

BDEPEND="virtual/linux-sources"

src_prepare() {
	# Set kernel build dir
	sed -i "s@^KERNEL_BUILD.*@KERNEL_BUILD := ${KV_DIR}@" "${S}/Makefile" || die "Could not fix build path"

	default
}

src_compile() {
	local modlist=(it87=kernel/drivers/hwmon:"${S}")

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	insinto /usr/share/lm_sensors/configs/IT87
	doins -r "${S}"/"Sensors configs"/.
}
