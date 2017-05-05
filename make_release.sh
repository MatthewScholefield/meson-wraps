#!/bin/sh

info_filename="INFO"
wrap_dir="wrap"
notes_filename="release-notes.md"

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 version" >&2
  exit 1
fi

version="$1"
echo "Version tag: $version"

if [ -d "$version" ]; then
	echo "Warning: $version/ already exists"
else
	mkdir "$version"
fi

echo "Writing files to $version/"
echo
echo "" > $version/$notes_filename

for dir in *; do
	if ! [ -e "$dir/$info_filename" ]; then
		continue
	fi
	
	name="$dir"
	echo "=== $name ==="
	eval $(cat "$dir/$info_filename")
	echo "Source url is $source_url"
	
	source_name=$(wget --server-response -q -O - "$source_url" 2>&1 |
		grep "Content-Disposition:" | tail -1 |
		awk 'match($0, /filename=(.+)/, f){ print f[1] }')
  	echo "Source filename is $source_name"
  	
  	source_hash=$(curl -Ls $source_url | sha256sum | awk '{ print $1 }')
	echo "Source hash is $source_hash"
	
	patch_name=$(sed -e 's/.tar.gz/-meson.tar.gz/' <<< "$source_name")
	echo "Wrap filename is $patch_name"
	
	echo "Compressing wrap..."
	tar -czf "$version/$patch_name" "$dir/$wrap_dir"
	
	patch_hash=$(sha256sum $version/$patch_name | awk '{ print $1 }')
	echo "Source hash is $patch_hash"
	
	release_url="https://github.com/MatthewScholefield/meson-wraps/releases/download"
	patch_url="$release_url/$version/$patch_name"
	echo "Patch url is $patch_url"
	
	echo "### [$name:][$name-url] ###\n\`\`\`\n[wrap-file]\ndirectory = $dir\n\nsource_url = $source_url\nsource_filename = $source_name\nsource_hash = $source_hash\n\npatch_url = $patch_url\npatch_filename = $patch_name\npatch_hash = $patch_hash\n\`\`\`\n[$name-url]:$repository_url\n" >> "$version/$notes_filename"
done
