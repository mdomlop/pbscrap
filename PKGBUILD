# Maintainer: Manuel Domínguez López <mdomlop at gmail dot com>

_pkgver_year=2017
_pkgver_month=07
_pkgver_day=06

pkgname=pbscrap
pkgver=1.0b
pkgrel=1
pkgdesc="A simple pastebin.com scraper."
arch=('any')
url="https://github.com/mdomlop/$pkgname"
source=()
license=('GPL3')
depends=('python>=3' 'python-urllib3')
changelog=ChangeLog


build() {
    cd "$startdir"
    make
    }

package() {
    cd "$startdir"
    make install DESTDIR=$pkgdir
}
