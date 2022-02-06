# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit android

DESCRIPTION="Command-Line Tools for Android"
HOMEPAGE="https://developer.android.com/studio"
SRC_URI="https://dl.google.com/android/repository/commandlinetools-linux-${PV##*.}_latest.zip -> ${P}.zip"

LICENSE="android"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+udev +group-writable +bootstrap"

DEPEND="
	group-writable? ( acct-group/androidsdk )
"
BDEPEND="
	${DEPEND}
"
RDEPEND="
	${DEPEND}
	sys-libs/glibc
	virtual/jdk
	udev? ( dev-util/android-udev-rules )
	group-writable? ( sys-apps/acl )
"

S="${WORKDIR}/cmdline-tools"
_D="${ANDROID_SDK_ROOT}/cmdline-tools/latest"
QA_PREBUILT="${ANDROID_SDK_ROOT}/*"

src_install() {
	dodir ${_D%/*}
	mv "${S}" "${ED%/}"${_D} || die

	insinto /etc/profile.d
	doins "${FILESDIR}/android-sdk-cmdline-tools-latest.csh"
	doins "${FILESDIR}/android-sdk-cmdline-tools-latest.sh"
}

pkg_config() {
	# automatically accept licenses
	echo y | "${_D}/bin/sdkmanager"
}

pkg_postinst() {
	einfo "To be able to use android command-line tools,"
	if use group-writable; then
		einfo "add yourself to the 'androidsdk' group by calling"
		einfo "  usermod -a -G androidsdk <user>"
		einfo ""
		einfo "and change ACL of the ${ANDROID_SDK_ROOT} by calling as root"
		einfo "  setfacl -R -m g:androidsdk:rwx \"${ANDROID_SDK_ROOT}\""
		einfo "	 setfacl -d -m g:androidsdk:rwX \"${ANDROID_SDK_ROOT}\""
	else
		einfo "you need to authenticate yourself as root"
	fi
}
