#!/bin/sh

DIR="$1"
MAXW=$2
MAXH=$3

if [ $DEBUG = true ]; then
    echo "[#] Currently located in $(pwd)"
    echo "[#] Resizing images in ${DIR}"
    echo "[#] Max image size (w x h): ${MAXW}x${MAXH}"
fi

find "$DIR" -type f | while read img; do
    mime=$(printf '%s\n' $(file --mime-type "$img"))
    if echo $mime | grep -Fqe "image"; then
        if echo $mime | grep -Fqe "gif"; then
            dimensions=$(gifsicle --no-logical-screen -I "$img")
            imageWidth=$(echo $dimensions | awk '/logical screen/ {split($3,a,x); print a[1]}')
            imageHeight=$(echo $dimensions | awk '/logical screen/ {split($3,a,x); print a[2]}')

            if [ "$imageWidth" -gt "$MAXW" ] || [ "$imageHeight" -gt "$MAXH" ]; then
                gifsicle --no-logical-screen --resize-fit "${MAXW}x${MAXH}" "$img"
                if [ $DEBUG = true ]; then echo "[+] Resized $img (${imageWidth}x${imageHeight})"; fi
            else
                if [ $DEBUG = true ]; then echo "[-] Skipping $img (${imageWidth}x${imageHeight})"; fi
            fi
        else
            imageWidth=$(identify -format "%w" "$img")
            imageHeight=$(identify -format "%h" "$img")

            if [ "$imageWidth" -gt "$MAXW" ] || [ "$imageHeight" -gt "$MAXH" ]; then
                mogrify -resize "${MAXW}x${MAXH}>" "$img"
                if [ $DEBUG = true ]; then echo "[+] Resized $img (${imageWidth}x${imageHeight})"; fi
            else
                if [ $DEBUG = true ]; then echo "[-] Skipping $img (${imageWidth}x${imageHeight})"; fi
            fi
        fi
    else
        if [ $DEBUG = true ]; then echo "[/] Not an image - ${img}"; fi
    fi
done