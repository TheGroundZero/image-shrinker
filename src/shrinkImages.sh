#!/bin/sh

DIR="$1"
MAXW=$2
MAXH=$3
IMG="$4"

if [ $DEBUG = true ]; then
    echo "[#] Currently located in $(pwd)"
    echo "[#] Resizing images in ${DIR}"
    echo "[#] Max image size (w x h): ${MAXW}x${MAXH}"
fi

resize_img()
{
    IMG=$1
    if [ $DEBUG = true ]; then echo "[#] Checking ${IMG}"; fi

    mime=$(printf '%s\n' $(file --mime-type "$IMG"))
    if echo $mime | grep -Fqe "image"; then
        if echo $mime | grep -Fqe "gif"; then
            dimensions=$(gifsicle --no-logical-screen -I "$IMG")
            imageWidth=$(echo $dimensions | awk '/logical screen/ {split($3,a,x); print a[1]}')
            imageHeight=$(echo $dimensions | awk '/logical screen/ {split($3,a,x); print a[2]}')

            if [ "$imageWidth" -gt "$MAXW" ] || [ "$imageHeight" -gt "$MAXH" ]; then
                gifsicle --no-logical-screen --resize-fit "${MAXW}x${MAXH}" "$IMG"
                if [ $DEBUG = true ]; then echo "[+] Resized ${IMG} (${imageWidth}x${imageHeight})"; fi
            else
                if [ $DEBUG = true ]; then echo "[-] Skipping ${IMG} (${imageWidth}x${imageHeight})"; fi
            fi
        else
            imageWidth=$(identify -format "%w" "$IMG")
            imageHeight=$(identify -format "%h" "$IMG")

            if [ "$imageWidth" -gt "$MAXW" ] || [ "$imageHeight" -gt "$MAXH" ]; then
                mogrify -resize "${MAXW}x${MAXH}>" "$IMG"
                if [ $DEBUG = true ]; then echo "[+] Resized ${IMG} (${imageWidth}x${imageHeight})"; fi
            else
                if [ $DEBUG = true ]; then echo "[-] Skipping ${IMG} (${imageWidth}x${imageHeight})"; fi
            fi
        fi
    else
        if [ $DEBUG = true ]; then echo "[/] Not an image - ${IMG}"; fi
    fi
}

if [ -z $IMG ]; then
    find "$DIR" -type f | while read img; do
        resize_img $img
    done
else
    resize_img "$DIR/$IMG"
fi