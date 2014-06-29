function vznope-images-available () {
    curl -s $VZN_IMAGES_URL | 
        grep 'href=' | 
        awk '
            BEGIN {
                format = "% 20s  % 10s  % 10s  % 6s\n";
                printf(format, "DISTRO@VERSION", "ARCH", "TAG", "SIZE");
            }

            $0 ~ /\.tar\.gz\"/ {
                match($0, /[0-9]+M/);
                size = substr($0, RSTART, RLENGTH);

                match($0, /href=\".+\.tar\.gz"/);
                file = substr($0, RSTART, RLENGTH);
                sub(/^href=\"/, "", file);
                sub(/\"/, "", file);

                filepart = file;
                sub(/\.tar\.gz$/, "", filepart);
                split(filepart, part, "-");

                distro  = part[1];
                version = part[2];
                arch    = part[3];
                tag     = part[4];

                printf(format, distro"@"version, arch, tag, size);
            }
        ' 
}

function fetch-image () {
    getopt $*
    distver=$OPT_0
    arch=$OPT_arch
    tag=$OPT_tag
    if [[ "$distver" =~ @ ]] ; then
        dist=$(echo $distver | sed 's/\@.*//')
        version=$(echo $distver | sed 's/.*\@//')
    else
        dist=$distver
    fi
    vznope-images-available | sed '1d' |
        awk '$1 ~ /'$dist'/ && $1 ~ /'$version'/'
}

function vznope-image () {
    fetch-image $*
}
