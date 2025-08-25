# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font check-reqs

DESCRIPTION="Iconic font aggregator, and collection"
HOMEPAGE="https://nerdfonts.com https://github.com/ryanoasis/nerd-fonts"
RESTRICT="mirror"

LICENSE="
	MIT
	OFL-1.1
	Apache-2.0
	CC-BY-SA-4.0
	BitstreamVera
	BSD
	WTFPL-2
	Vic-Fieger-License
	UbuntuFontLicense-1.0
"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
#   | jq -r '.assets[].name | select(endswith(".tar.xz")) | split(".") | .[0] | select(test("(?i)symbolsonly") | not)'
FONTS=(
	0xProto
	3270
	Agave
	AnonymousPro
	Arimo
	AurulentSansMono
	BigBlueTerminal
	BitstreamVeraSansMono
	CascadiaCode
	CascadiaMono
	CodeNewRoman
	ComicShannsMono
	CommitMono
	Cousine
	D2Coding
	DaddyTimeMono
	DejaVuSansMono
	DroidSansMono
	EnvyCodeR
	FantasqueSansMono
	FiraCode
	FiraMono
	GeistMono
	Go-Mono
	Gohu
	Hack
	Hasklig
	HeavyData
	Hermit
	iA-Writer
	IBMPlexMono
	Inconsolata
	InconsolataGo
	InconsolataLGC
	IntelOneMono
	Iosevka
	IosevkaTerm
	IosevkaTermSlab
	JetBrainsMono
	Lekton
	LiberationMono
	Lilex
	MartianMono
	Meslo
	Monaspace
	Monofur
	Monoid
	Mononoki
	MPlus
	SymbolsOnly
	Noto
	OpenDyslexic
	Overpass
	ProFont
	ProggyClean
	Recursive
	RobotoMono
	ShareTechMono
	SourceCodePro
	SpaceMono
	Terminus
	Tinos
	Ubuntu
	UbuntuMono
	UbuntuSans
	VictorMono
	ZedMono
)

IUSE_FLAGS=(${FONTS[*],,})
IUSE="${IUSE_FLAGS[*]}"
REQUIRED_USE="|| ( ${IUSE_FLAGS[*]} )"

# curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest
#  | jq -r '.assets[] | select(.name | endswith(".tar.xz")) | (.name | split(".") | .[0] | ascii_downcase) + "? ( \"${MY_URI}/" + .name + "\" -> \"${PN}-" + (.name | split(".") | .[0] | ascii_downcase) + "-${PV}.tar.xz\" )"'
MY_URI="https://github.com/ryanoasis/${PN}/releases/download/v${PV}"
SRC_URI="
	0xproto? ( "${MY_URI}/0xProto.tar.xz" -> "${PN}-0xproto-${PV}.tar.xz" )
	3270? ( "${MY_URI}/3270.tar.xz" -> "${PN}-3270-${PV}.tar.xz" )
	agave? ( "${MY_URI}/Agave.tar.xz" -> "${PN}-agave-${PV}.tar.xz" )
	anonymouspro? ( "${MY_URI}/AnonymousPro.tar.xz" -> "${PN}-anonymouspro-${PV}.tar.xz" )
	arimo? ( "${MY_URI}/Arimo.tar.xz" -> "${PN}-arimo-${PV}.tar.xz" )
	aurulentsansmono? ( "${MY_URI}/AurulentSansMono.tar.xz" -> "${PN}-aurulentsansmono-${PV}.tar.xz" )
	bigblueterminal? ( "${MY_URI}/BigBlueTerminal.tar.xz" -> "${PN}-bigblueterminal-${PV}.tar.xz" )
	bitstreamverasansmono? ( "${MY_URI}/BitstreamVeraSansMono.tar.xz" -> "${PN}-bitstreamverasansmono-${PV}.tar.xz" )
	cascadiacode? ( "${MY_URI}/CascadiaCode.tar.xz" -> "${PN}-cascadiacode-${PV}.tar.xz" )
	cascadiamono? ( "${MY_URI}/CascadiaMono.tar.xz" -> "${PN}-cascadiamono-${PV}.tar.xz" )
	codenewroman? ( "${MY_URI}/CodeNewRoman.tar.xz" -> "${PN}-codenewroman-${PV}.tar.xz" )
	comicshannsmono? ( "${MY_URI}/ComicShannsMono.tar.xz" -> "${PN}-comicshannsmono-${PV}.tar.xz" )
	commitmono? ( "${MY_URI}/CommitMono.tar.xz" -> "${PN}-commitmono-${PV}.tar.xz" )
	cousine? ( "${MY_URI}/Cousine.tar.xz" -> "${PN}-cousine-${PV}.tar.xz" )
	d2coding? ( "${MY_URI}/D2Coding.tar.xz" -> "${PN}-d2coding-${PV}.tar.xz" )
	daddytimemono? ( "${MY_URI}/DaddyTimeMono.tar.xz" -> "${PN}-daddytimemono-${PV}.tar.xz" )
	dejavusansmono? ( "${MY_URI}/DejaVuSansMono.tar.xz" -> "${PN}-dejavusansmono-${PV}.tar.xz" )
	droidsansmono? ( "${MY_URI}/DroidSansMono.tar.xz" -> "${PN}-droidsansmono-${PV}.tar.xz" )
	envycoder? ( "${MY_URI}/EnvyCodeR.tar.xz" -> "${PN}-envycoder-${PV}.tar.xz" )
	fantasquesansmono? ( "${MY_URI}/FantasqueSansMono.tar.xz" -> "${PN}-fantasquesansmono-${PV}.tar.xz" )
	firacode? ( "${MY_URI}/FiraCode.tar.xz" -> "${PN}-firacode-${PV}.tar.xz" )
	firamono? ( "${MY_URI}/FiraMono.tar.xz" -> "${PN}-firamono-${PV}.tar.xz" )
	geistmono? ( "${MY_URI}/GeistMono.tar.xz" -> "${PN}-geistmono-${PV}.tar.xz" )
	go-mono? ( "${MY_URI}/Go-Mono.tar.xz" -> "${PN}-go-mono-${PV}.tar.xz" )
	gohu? ( "${MY_URI}/Gohu.tar.xz" -> "${PN}-gohu-${PV}.tar.xz" )
	hack? ( "${MY_URI}/Hack.tar.xz" -> "${PN}-hack-${PV}.tar.xz" )
	hasklig? ( "${MY_URI}/Hasklig.tar.xz" -> "${PN}-hasklig-${PV}.tar.xz" )
	heavydata? ( "${MY_URI}/HeavyData.tar.xz" -> "${PN}-heavydata-${PV}.tar.xz" )
	hermit? ( "${MY_URI}/Hermit.tar.xz" -> "${PN}-hermit-${PV}.tar.xz" )
	ia-writer? ( "${MY_URI}/iA-Writer.tar.xz" -> "${PN}-ia-writer-${PV}.tar.xz" )
	ibmplexmono? ( "${MY_URI}/IBMPlexMono.tar.xz" -> "${PN}-ibmplexmono-${PV}.tar.xz" )
	inconsolata? ( "${MY_URI}/Inconsolata.tar.xz" -> "${PN}-inconsolata-${PV}.tar.xz" )
	inconsolatago? ( "${MY_URI}/InconsolataGo.tar.xz" -> "${PN}-inconsolatago-${PV}.tar.xz" )
	inconsolatalgc? ( "${MY_URI}/InconsolataLGC.tar.xz" -> "${PN}-inconsolatalgc-${PV}.tar.xz" )
	intelonemono? ( "${MY_URI}/IntelOneMono.tar.xz" -> "${PN}-intelonemono-${PV}.tar.xz" )
	iosevka? ( "${MY_URI}/Iosevka.tar.xz" -> "${PN}-iosevka-${PV}.tar.xz" )
	iosevkaterm? ( "${MY_URI}/IosevkaTerm.tar.xz" -> "${PN}-iosevkaterm-${PV}.tar.xz" )
	iosevkatermslab? ( "${MY_URI}/IosevkaTermSlab.tar.xz" -> "${PN}-iosevkatermslab-${PV}.tar.xz" )
	jetbrainsmono? ( "${MY_URI}/JetBrainsMono.tar.xz" -> "${PN}-jetbrainsmono-${PV}.tar.xz" )
	lekton? ( "${MY_URI}/Lekton.tar.xz" -> "${PN}-lekton-${PV}.tar.xz" )
	liberationmono? ( "${MY_URI}/LiberationMono.tar.xz" -> "${PN}-liberationmono-${PV}.tar.xz" )
	lilex? ( "${MY_URI}/Lilex.tar.xz" -> "${PN}-lilex-${PV}.tar.xz" )
	martianmono? ( "${MY_URI}/MartianMono.tar.xz" -> "${PN}-martianmono-${PV}.tar.xz" )
	meslo? ( "${MY_URI}/Meslo.tar.xz" -> "${PN}-meslo-${PV}.tar.xz" )
	monaspace? ( "${MY_URI}/Monaspace.tar.xz" -> "${PN}-monaspace-${PV}.tar.xz" )
	monofur? ( "${MY_URI}/Monofur.tar.xz" -> "${PN}-monofur-${PV}.tar.xz" )
	monoid? ( "${MY_URI}/Monoid.tar.xz" -> "${PN}-monoid-${PV}.tar.xz" )
	mononoki? ( "${MY_URI}/Mononoki.tar.xz" -> "${PN}-mononoki-${PV}.tar.xz" )
	mplus? ( "${MY_URI}/MPlus.tar.xz" -> "${PN}-mplus-${PV}.tar.xz" )
	symbolsonly? (
		"${MY_URI}/NerdFontsSymbolsOnly.tar.xz" -> "${PN}-nerdfontssymbolsonly-${PV}.tar.xz"
		"https://raw.githubusercontent.com/ryanoasis/${PN}/v${PV}/10-nerd-font-symbols.conf" -> "${PN}-10-nerd-font-symbols-${PV}.conf"
	)
	noto? ( "${MY_URI}/Noto.tar.xz" -> "${PN}-noto-${PV}.tar.xz" )
	opendyslexic? ( "${MY_URI}/OpenDyslexic.tar.xz" -> "${PN}-opendyslexic-${PV}.tar.xz" )
	overpass? ( "${MY_URI}/Overpass.tar.xz" -> "${PN}-overpass-${PV}.tar.xz" )
	profont? ( "${MY_URI}/ProFont.tar.xz" -> "${PN}-profont-${PV}.tar.xz" )
	proggyclean? ( "${MY_URI}/ProggyClean.tar.xz" -> "${PN}-proggyclean-${PV}.tar.xz" )
	recursive? ( "${MY_URI}/Recursive.tar.xz" -> "${PN}-recursive-${PV}.tar.xz" )
	robotomono? ( "${MY_URI}/RobotoMono.tar.xz" -> "${PN}-robotomono-${PV}.tar.xz" )
	sharetechmono? ( "${MY_URI}/ShareTechMono.tar.xz" -> "${PN}-sharetechmono-${PV}.tar.xz" )
	sourcecodepro? ( "${MY_URI}/SourceCodePro.tar.xz" -> "${PN}-sourcecodepro-${PV}.tar.xz" )
	spacemono? ( "${MY_URI}/SpaceMono.tar.xz" -> "${PN}-spacemono-${PV}.tar.xz" )
	terminus? ( "${MY_URI}/Terminus.tar.xz" -> "${PN}-terminus-${PV}.tar.xz" )
	tinos? ( "${MY_URI}/Tinos.tar.xz" -> "${PN}-tinos-${PV}.tar.xz" )
	ubuntu? ( "${MY_URI}/Ubuntu.tar.xz" -> "${PN}-ubuntu-${PV}.tar.xz" )
	ubuntumono? ( "${MY_URI}/UbuntuMono.tar.xz" -> "${PN}-ubuntumono-${PV}.tar.xz" )
	ubuntusans? ( "${MY_URI}/UbuntuSans.tar.xz" -> "${PN}-ubuntusans-${PV}.tar.xz" )
	victormono? ( "${MY_URI}/VictorMono.tar.xz" -> "${PN}-victormono-${PV}.tar.xz" )
	zedmono? ( "${MY_URI}/ZedMono.tar.xz" -> "${PN}-zedmono-${PV}.tar.xz" )
"

DEPEND="app-arch/xz-utils"
RDEPEND="media-libs/fontconfig"

CHECKREQS_DISK_BUILD="3G"
CHECKREQS_DISK_USR="4G"

S="${WORKDIR}"
FONT_CONF=( "${S}/10-nerd-font-symbols.conf" )
FONT_S=${S}

pkg_pretend() {
	check-reqs_pkg_setup
}

src_prepare() {
	if use symbolsonly; then
		install -m644 "${DISTDIR}/${PN}-10-nerd-font-symbols-${PV}.conf" "${S}/10-nerd-font-symbols.conf" || die
	fi

	default
}

src_install() {
	declare -A font_filetypes
	local otf_file_number ttf_file_number

	otf_file_number=$(find ${S} -regex '.*\.otf' | wc -l)
	ttf_file_number=$(find ${S} -regex '.*\.ttf' | wc -l)

	if [[ ${otf_file_number} != 0 ]]; then
		font_filetypes[otf]=
	fi

	if [[ ${ttf_file_number} != 0 ]]; then
		font_filetypes[ttf]=
	fi

	FONT_SUFFIX="${!font_filetypes[@]}"

	font_src_install
}

pkg_postinst() {
	einfo "Font-patcher script is not included in this ebuild."
	einfo "You can get it from the nerd-font project."
	einfo "https://github.com/ryanoasis/nerd-fonts"

	elog "You might have to enable 50-user.conf and 10-nerd-font-symbols.conf by using"
	elog "eselect fontconfig"

	font_pkg_postinst
}
