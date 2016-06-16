#!/bin/bash

# pia.command version checker v0.05

#before seeing if pia has updated, see if this script has updated
piaVersionChecker=`curl -s https://raw.githubusercontent.com/mdupuy/MacPiaVersionChecker/master/pia.command |grep -m 1 'v[0-9]\.[0-9][0-9]'`

#check the web version by grepping out the number from https://www.privateinternetaccess.com/pages/client-support
#web_version=`curl -s https://www.privateinternetaccess.com/pages/client-support/ |grep -m 1 'v\.[0-9][0-9]'| tr -d ' '`
web_version=`curl -s https://www.privateinternetaccess.com/pages/client-support/ |grep -m 1 'v[0-9][0-9]'| tr -d ' '|sed -e 's/<[^>]*>//g'|sed 's/v//g'`
echo web version $web_version

#check my current number from the default install directory for single users
#my_version1=`fgrep v. ~/.pia_manager/pia_tray.app/Contents/Resources/settings.html | sed -e 's/<[^>]*>//g'|tr -d ' '|sed 's/v\.//g'`
#my_version2=`fgrep v. ~/.pia_manager/version |sed 's/v\.//g'`
#my_version3=`fgrep v. ~/.pia_manager/pia_tray_files/index.html | sed -e 's/<[^>]*>//g'|tr -d ' '| sed 's/v\.//g'`

#Too many different version storage locations, find them all!
my_version=`grep -ri "v\."[0-9][0-9] ~/.pia_manager/* | fgrep -v Binary | sed -e 's/<[^>]*>//g'| sed 's/.*v\.//'`
#my_version="58 59 55"
#echo $my_version

my_version=( $my_version )  #convert tokens in to array
howMany=${#my_version[@]}
#echo $howMany

#find the highest version number of them all (currently 3)
if [ $howMany ]; then
	for (( itr=$[$howMany-1],  higestVersion=${my_version[itr]}; $[$itr+1] ; itr-=1 )); do
		#echo ${my_version[itr]} $itr
		if [ "${my_version[itr]}" -gt "$higestVersion" ]; then 
			higestVersion=${my_version[itr]}
			#echo Higest version $higestVersion
		fi
	done
else
	higestVersion=0
fi
#echo $higestVersion
my_version=$higestVersion

echo installed version $my_version

if [ "$my_version" != "$web_version" ]; then
		echo "Getting version $web_version"
		# if you don't have wget installed, these should work, otherwise install wget via homebrew first
		#open https://www.privateinternetaccess.com/installer/download_installer_osx
		#open https://s3.amazonaws.com/privateinternetaccess/installers/latest/installer_osx.dmg

		# I download it to the user's directory, do whatever you prefer
		wget -O ~/Desktop/pia_"$web_version"_installer_osx.dmg https://s3.amazonaws.com/privateinternetaccess/installers/latest/installer_osx.dmg
		##open ~/Desktop/pia_"$web_version"_installer_osx.dmg
		hdiutil attach ~/Desktop/pia_"$web_version"_installer_osx.dmg

		# need a better way to gracefully quit pia before opening the new installer
		#osascript -e 'quit app "pia_tray"'
		pkill pia openvpn
		
		piaPIDs=`ps ax|fgrep pia_|awk '{print $1}'`
		#echo $piaPIDs
		for pid in $piaPIDs; do
			kill $pid
		done
		
		open /Volumes/Private\ Internet\ Access/Private\ Internet\ Access\ Installer.app
		##mv ~/Desktop/pia_"$web_version"_installer_osx.dmg ~/.Trash
		#mv ~/Desktop/pia_"$web_version"_installer_osx.dmg ~/Desktop/Desk
fi
