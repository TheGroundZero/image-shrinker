# image-shrinker

GitHub action that uses Imagemagick and Gifsicle to recursively shrink images to a given maximum width/height while maintaining aspect ratio.
Uses some smarts to avoid opening and re-saving images that aren't shrunk, so timestamps aren't impacted.

## Use in GitHub Action

```yaml
      - name: Shrink images in folder
        id: shrink-images
        uses: TheGroundZero/image-shrinker
        with:
          subdir: img  # Relative path starting from / in repo, default = ""
          maxwidth: 1920 # Default
          maxheight: 1080 # Default
        env:
          DEBUG: false # Default
      
      - name: Shrink single image in folder
        id: shrink-images
        uses: TheGroundZero/image-shrinker
        with:
          subdir: img  # Relative path starting from / in repo, default = ""
          image: image.jpg # image inside subdir
          maxwidth: 1920 # Default
          maxheight: 1080 # Default
        env:
          DEBUG: false # Default
```

This can be accompanied by steps committing the changes to the repo so images don't need to be resized after every run

```yaml
      # These actions are not vetted by myself or Github
      - name: Commit changes
        uses: EndBug/add-and-commit@v4
        with:
          add: '.'
          author_name: "github-actions[bot]"
          author_email: "github-actions@users.noreply.github.com"
          message: Images Resized by Github action
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
      - uses: mshick/add-pr-comment@v1
        with:
          message: Images Resized by Github action
          repo-token: ${{ secrets.GITHUB_TOKEN }}
          repo-token-user-login: 'github-actions[bot]'
          allow-repeats: true
```

## Run manually

```bash
git clone https://github.com/TheGroundZero/image-shrinker
cd image-shrinker
docker build --rm --tag "image-shrinker" --build-arg BUILD_DATE="$(date)" --build-arg BUILD_REVISION=0.1 .
docker run -it --rm -v [image folder]:/github/workspace -e INPUT_MAXWIDTH=1920 -e INPUT_MAXHEIGHT=1080 -e DEBUG=true image-shrinker
```
