# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/aejsmith/${PN}.git"
	inherit git-r3
else
	MY_PV="${PV%.*}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/aejsmith/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="Vulkan layer to force a specific device to be used"
HOMEPAGE="https://github.com/aejsmith/vkdevicechooser"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	media-libs/vulkan-loader[layers]
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/vulkan-headers
	dev-util/vulkan-utility-libraries
	dev-build/meson
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-vk-layer-dispatch-table.patch
)
