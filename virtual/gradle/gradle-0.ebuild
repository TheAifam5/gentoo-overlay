# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for gradle"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="|| ( dev-java/gradle-bin
		dev-java/gradle )"