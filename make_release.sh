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
echo "" > $version/$notes_filename

for dir in *; do
	if ! [ -e "$dir/$info_filename" ]; then
		continue
	fi
	
	name="$dir"
	echo
	echo "=== $name ==="
	eval $(cat "$dir/$info_filename")
	echo "Source url is $source_url"
	
	source_name=$(wget --server-response -q -O - "$source_url" 2>&1 |
		grep "Content-Disposition:" | tail -1 |
		awk 'match($0, /filename=(.+)/, f){ print f[1] }')
	
  	echo "Source filename is $source_name"
  	
  	wget --content-disposition -q -O "$source_name" "$source_url"
  	
  	folder_name=$(tar -xvf "$source_name" | sed -e 's/\([^\/]*\)\//\1/gm' | head -n 1)
  	echo "Tar folder name is $folder_name"
  	rm -rf "$folder_name"
  	
  	source_hash=$(cat $source_name | sha256sum | awk '{ print $1 }')
	echo "Source hash is $source_hash"
	
	rm "$source_name"
	
	patch_name=$(sed -e 's/.tar.gz/-meson.tar.gz/' <<< "$source_name")
	echo "Wrap filename is $patch_name"
	
	echo "Compressing wrap..."
	tar -cf "$version/$patch_name" --xform="s,$dir/$wrap_dir/,$folder_name/," $(find "$dir/$wrap_dir" -type f)
	
	patch_hash=$(sha256sum $version/$patch_name | awk '{ print $1 }')
	echo "Source hash is $patch_hash"
	
	release_url="https://github.com/MatthewScholefield/meson-wraps/releases/download/$version"
	patch_url="$release_url/$patch_name"
	echo "Patch url is $patch_url"
	
	wrap_txt_name=$name.wrap
	printf "[wrap-file]\ndirectory = $folder_name\n\nsource_url = $source_url\nsource_filename = $source_name\nsource_hash = $source_hash\n\npatch_url = $patch_url\npatch_filename = $patch_name\npatch_hash = $patch_hash\n" > "$version/$wrap_txt_name"
	
	wrap_img_url="https://raw.githubusercontent.com/MatthewScholefield/meson-wraps/master/resources/wrap-file.png"
	website_img_url="https://raw.githubusercontent.com/MatthewScholefield/meson-wraps/master/resources/website.png"
	
	scripts=""
	if [ -f $dir/$wrap_dir/build.py ]; then scripts="fabricate, $scripts"; fi
	if [ -f $dir/$wrap_dir/meson.build ]; then scripts="meson, $scripts"; fi
	scripts="${scripts%??}"  # Remove last ", "
	
	printf "<h1><p align=center>$name</p></h1><p align=center>($scripts)<p align=center><a href=\"$release_url/$wrap_txt_name\"><img src=\"$wrap_img_url\"></a><a href=\"$repository_url\"><img src=\"$website_img_url\"></a></p><br>\n" >> "$version/$notes_filename"
done

