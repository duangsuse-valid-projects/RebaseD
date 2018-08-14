Summary: Never lost source code Rebase API server.
Name: rebase-server
Version: 0.1.0
Release: 1
License: AGPL
Group: System Environment/Daemons
Source: https://github.com/duangsuse/RebaseD
BuildRoot: /var/tmp/%{name}-buildroot

%description
The rebased program allows the user to serve a custom rebase api service.

See API document at https://github.com/duangsuse/RebaseD/blob/master/README.md

Install rebase-server if you'd like to open a really open source Rebase API server.

%prep
%setup -q

%build
rake build spec
pushd dist
make manpage
cp rebased.1 ..
popd

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT/usr/bin
mkdir -p $RPM_BUILD_ROOT/usr/man/man1

install -s -m 755 rebased $RPM_BUILD_ROOT/usr/bin/rebased
install -s -m 755 rebased-unit $RPM_BUILD_ROOT/usr/bin/rebased-unit
install -m 644 rebased.1 $RPM_BUILD_ROOT/usr/man/man1/rebased.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root)
%doc COPYING

/usr/bin/rebased
/usr/bin/rebased-server
/usr/man/man1/rebased.1

%changelog
* Tue Aug 14 2018 duangsuse <fedora-opensuse@outlook.com>
- Project created
