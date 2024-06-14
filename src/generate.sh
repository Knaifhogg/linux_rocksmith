#!/bin/bash
trap "exit" INT

# number echos are meant for debugging purposes, to find the point where it doeesn't behave properly
# basically, it's a bunch of replacements for parts with a specific name. the name in 000-<name>-000 and the folder names match.
# The order of the subfolders is determined by need. This has the advantage that I don't need as much empty files.
# paths to the wineasio files are handled in a seperate .sh, because calling them like that makes sed want to run whatever is at those paths.
# Also, it's seperate so you can adjust them if needed, without having to work on this script.

path=../guides/setup

echo -1
rm $path/*.md # clean first
# for every variation
for dist in arch deb deck fed; do
	for sound in non-pipewire pipewire; do
		echo 0
		echo "$dist; $sound" # print out, which file is worked on, so it's easier to debug.
		# deck with non-pipewire is N/A, so we'll skip that.
		if [ "$dist" = "deck" ] && [ "$sound" = "non-pipewire" ]; then
			echo "recognized deck-non-pipewire loop, skipping."
			continue
		fi
		if [ "$dist" = "fed" ] && [ "$sound" = "non-pipewire" ]; then
			echo "recognized fed-non-pipewire loop, skipping."
			continue
		fi
		filename=$path/$dist-$sound.md
		cp base.md $filename # BASE SHOULD NEVER BE CHANGED BY THIS SCRIPT

		echo 01
		sed -i "s/000-title-000/cat title\/${dist}\/${sound}/e" $filename
		sed -i "s/000-title-note-000/cat title\/${dist}\/note/e" $filename

		echo 02
		sed -i "s/000-install-part-000/cat install-part\/${dist}\/${sound}/e" $filename #needs fixing

		echo 03
		sed -i "s/000-install-check-000/cat install-check\/${dist}/e" $filename # "deck" here is a symlink to "arch" here

		echo 04
		#sed -i "s/000-arch-base-devel-note-000/cat arch-base-devel-note\/${dist}/e" $filename # not used anymore
		echo 06
# 		sed -i "s/000-install-wineasio-system-000/cat install-wineasio-system\/${dist}/e" $filename
# 		sed -i "s/000-all-in-1-000/cat install-wineasio-system\/all-in-1/e" $filename
# 		sed -i "s/000-install-wineasio-system-1-000/cat install-wineasio-system\/${sound}/e" $filename
# 		sed -i "s/000-wineasio-source-000/cat install-wineasio-system\/wineasio-source/e" $filename
# 		sed -i "s/000-download-wineasio-000/cat install-wineasio-system\/download-wineasio\/${dist}/e" $filename
# 		sed -i "s/000-clone-wineasio-000/cat install-wineasio-system\/download-wineasio\/clone/e" $filename
		#sed -i "s/000-wineasio-installed-note-000/cat install-wineasio-system\/wineasio-installed-note/e" $filename

		echo 06-1
		sed -i "s/000-install-wineasio-system-000/cat install-wineasio-system\/${dist}/e" $filename
		sed -i "s/000-base-devel-000/cat install-wineasio-system\/stuff\/base-devel\/${dist}/e" $filename
		if [ "$dist" = "arch" ] && [ "$sound" = "non-pipewire" ]; then
			sed -i "s/000-line-before-download-000/cat install-wineasio-system\/stuff\/line-before-download\/arch-non-pipewire/e" $filename
			sed -i "s/000-arch-non-pipewire-after-wineasio-install-000/cat install-wineasio-system\/stuff\/arch-non-pipewire-after-wineasio-install/e" $filename
		elif [ "$dist" = "deck" ]; then
			sed -i "s/000-line-before-download-000/cat install-wineasio-system\/stuff\/line-before-download\/deck/e" $filename
		fi
		sed -i "s/000-line-before-download-000//g" $filename
		sed -i 's/000-arch-non-pipewire-after-wineasio-install-000//g' $filename
		sed -i "s/000-deck-additional-packages-000/cat install-wineasio-system\/stuff\/deck-additional-packages\/${dist}/e" $filename
		sed -i "s/000-fed-makefile-000/cat install-wineasio-system\/stuff\/fed-makefile\/${dist}/e" $filename


		echo 07
		sed -i "s/000-old-000/cat install-wineasio-runner\/old/e" $filename

		echo 08
		sed -i "s/000-jack-setup-000/cat jack-setup\/${sound}/e" $filename

		echo 09
		sed -i "s/000-steam-running-required-000/cat steam-running-required\/${sound}/e" $filename

		echo 10
		sed -i "s/000-pipewire-note-000/cat pipewire-note\/${sound}/e" $filename
		echo 10.1
		#sed -i "s/000-pipewire-bootup-000/cat pipewire-bootup\/${sound}/e" $filename # using "start" in the regex gave the following error message (I don't know why): sh: line 1: Save: command not found

		echo 11
		./replace-paths.sh $dist $filename
		# those lines cause issues, for some reason. Write a seperate script with the lines in it; quick fix.
		#echo 11
		# insert paths
		#sed -i 's/000-x64unix-000/'"`cat paths/$dist-x64unix`"'/' $filename # why does this thing ask for sudo?
		#echo 11.1
		#sed -i "s/000-x64windows-000/cat paths\/${dist}-x64windows/e" $filename
		#echo 11.2
		#sed -i "s/000-x32unix-000/cat paths\/${dist}-x32unix)e" $filename
		#echo 11.3
		#sed -i "s/000-x32windows-000/cat paths\/${dist}-x32windows/e" $filename
		echo 12
	done
done

# This will list all the file names, regardless of missing something, or not. If there's a tag that's not replaced, it will appear below the according filename.
echo 13
echo "missing replacements, by file:"
for file in $(ls $path); do
	echo $file
	cat $path/$file | grep -P "000-"
done
