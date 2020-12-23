EAPI=7

MULTILIB_COMPAT=( abi_x86_64 )

inherit desktop pax-utils multilib-build unpacker

DESCRIPTION="Driver for Ricoh SP 150SU printer"
HOMEPAGE="http://support.ricoh.com/bb/html/dr_ut_e/re1/model/sp150su/sp150su.htm"
SRC_URI="https://support.ricoh.com/bb/pub_e/dr_ut_e/0001294/0001294706/V10_22/r75392L2.exe -> ${P}.7z"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

BDEPEND="app-arch/p7zip[${MULTILIB_USEDEP}]"

RDEPEND="
	net-print/cups[${MULTILIB_USEDEP}]
	app-misc/ricoh150su-utility[${MULTILIB_USEDEP}]
"

QA_PREBUILT="*"
S="${WORKDIR}"

src_unpack() {
	default
	unpack "${WORKDIR}/RICOH-SP-150SU_1.0-22_amd64.deb"
	unpack "${WORKDIR}/data.tar.gz"
	unpack "${WORKDIR}/usr/share/doc/ricoh-sp-150su/changelog.Debian.gz"
}

src_prepare() {
	default
	rm usr/share/doc/ricoh-sp-150su/changelog.Debian.gz
	mv changelog.Debian usr/share/doc/ricoh-sp-150su/changelog.Debian
}

src_install() {
	dodir /opt
	cp -a opt/RICOH "${ED}"/opt || die

	dodir /usr/libexec/cups/filter
	cp -a usr/lib/cups/filter "${ED}"/usr/libexec/cups || die

	dodir /usr/share/cups/model
	cp -a usr/share/cups/model/RICOH "${ED}"/usr/share/cups/model || die

	dodoc -r usr/share/doc/ricoh-sp-150su/.
}

pkg_postinst() {
	elog "You need to restart cupsd to be able to use this driver."

	if has_version 'sys-apps/systemd' ; then
		elog "    'systemctl restart cupsd'"
	fi

	if has_version 'sys-apps/openrc' ; then
		elog "    'rc-service cupsd restart'"
	fi
}
