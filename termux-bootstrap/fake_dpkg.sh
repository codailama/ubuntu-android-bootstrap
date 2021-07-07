#!/data/data/com.klibot/files/usr/bin/bash
for var in "$@"
do
	if [[ "$var" == *.deb ]]
	then
		>&2 echo "Replacing deb $var"
		dpkg_replacer $var
		rm $var
		mv $var.replaced $var 
		
	fi
done
/data/data/com.klibot/files/usr/bin/realDpkg $@
