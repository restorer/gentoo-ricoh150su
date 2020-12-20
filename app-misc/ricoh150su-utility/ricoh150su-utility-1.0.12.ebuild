EAPI=7

MULTILIB_COMPAT=( abi_x86_64 )

inherit desktop pax-utils multilib-build unpacker

DESCRIPTION="Utility for Ricoh SP 150SU printer (provides access to several network printing administrative features)"
HOMEPAGE="http://support.ricoh.com/bb/html/dr_ut_e/re1/model/sp150su/sp150su.htm"
SRC_URI="https://support.ricoh.com/bb/pub_e/dr_ut_e/0001297/0001297718/V10_12/r77138L2.exe -> ${P}.7z"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

BDEPEND="app-arch/p7zip[${MULTILIB_USEDEP}]"
RDEPEND="virtual/udev[${MULTILIB_USEDEP}]"
QA_PREBUILT="*"
S="${WORKDIR}"

src_unpack() {
	default
	unpack "${WORKDIR}/RICOH-SP-150SU-SP-150_1.0-12_all.deb"
	unpack "${WORKDIR}/data.tar.gz"
	unpack "${WORKDIR}/opt/RICOH/share/app_amd64.tar.gz"
}

src_prepare() {
	default

	rm "opt/RICOH/app/RICOH SP 150SU_SP 150/libsocket.so"
	rm "opt/RICOH/app/RICOH SP 150SU_SP 150/libvopusb.so"
	rm "opt/RICOH/app/RICOH SP 150SU_SP 150/RICOH Printer"

	mv libsocket.so "opt/RICOH/app/RICOH SP 150SU_SP 150"
	mv libvopusb.so "opt/RICOH/app/RICOH SP 150SU_SP 150"
	mv "RICOH Printer" "opt/RICOH/app/RICOH SP 150SU_SP 150"

	sed -i -e /SYSFS/d etc/udev/rules.d/99-vop-permissions.rules
}

src_install() {
	dodir /lib
	cp -a etc/udev "${ED}"/lib || die

	dodir /opt/RICOH
	cp -a opt/RICOH/app "${ED}"/opt/RICOH || die
}
