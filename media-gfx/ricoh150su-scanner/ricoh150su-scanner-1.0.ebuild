EAPI=7

MULTILIB_COMPAT=( abi_x86_64 )

inherit desktop pax-utils multilib-build unpacker

DESCRIPTION="SANE scanner driver for Ricoh SP 150SU"
HOMEPAGE="http://support.ricoh.com/bb/html/dr_ut_e/re1/model/sp150su/sp150su.htm"
SRC_URI="https://support.ricoh.com/bb/pub_e/dr_ut_e/0001294/0001294703/V100/r75389L2.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

BDEPEND="app-arch/p7zip[${MULTILIB_USEDEP}]"

RDEPEND="
	media-gfx/sane-backends[${MULTILIB_USEDEP}]
	dev-libs/libusb-compat[${MULTILIB_USEDEP}]
	app-misc/ricoh150su-utility[${MULTILIB_USEDEP}]
"

QA_PREBUILT="*"
S="${WORKDIR}"

src_install() {
	dodir /usr/lib64/sane
	cp -a RICOH-SP-150SU-Scan_v1.00/64bit/libsane-alto.so.1.0.22 "${ED}"/usr/lib64/sane
	cp -a RICOH-SP-150SU-Scan_v1.00/64bit/alto_ntdcmsdll.so "${ED}"/usr/lib64/sane
	ln -s libsane-alto.so.1.0.22 "${ED}"/usr/lib64/sane/libsane-alto.so.1
	ln -s libsane-alto.so.1.0.22 "${ED}"/usr/lib64/sane/libsane-alto.so

	dodir /etc/sane.d/dll.d
	printf "alto\n" > "${ED}"/etc/sane.d/dll.d/alto.conf
}

pkg_postinst() {
	elog "You need to restart saned to be able to use this driver."

	if has_version 'sys-apps/systemd' ; then
		elog "    'systemctl restart saned'"
	fi

	if has_version 'sys-apps/openrc' ; then
		elog "    'rc-service saned restart'"
	fi
}
