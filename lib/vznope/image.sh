function vznope-images-available () {
    subtype=$1 ; shift
    url=$VZN_IMAGES_URL
    if [ ! -z "$subtype" ] ; then
        url=$VZN_IMAGES_URL$subtype/;
    fi
    curl -sL $url | 
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
                if (! tag) {
                    tag = "default";
                }

                printf(format, distro"@"version, arch, tag, size);
            }
        ' 
}

function vznope-image () {
    getopt $*
    distver=$OPT_0
    arch=$OPT_arch
    tag=$OPT_tag
    subtype=$OPT_subtype
    url=$VZN_IMAGES_URL
    if [ -z "$arch" ] ; then
        arch=$(uname -i)
    fi
    if [ -z "$tag" ] ; then
        tag="default"
    fi
    if [[ "$distver" =~ @ ]] ; then
        dist=$(echo $distver | sed 's/\@.*//')
        version=$(echo $distver | sed 's/.*\@//')
    else
        dist=$distver
    fi
    vznope-images-available $subtype | 
        sed '1d' |
        awk '$1 ~ /'$dist'/ && $1 ~ /'$version'/ && $2 == "'$arch'" && $3 == "'$tag'"' |
        sort -nr |
        head -n 1 | 
        awk '
            {
                baseurl = "'$url'";
                distver = $1;
                arch = $2;
                tag = $3;
                split(distver, distpart, "@");
                dist = distpart[1];
                version = distpart[2];
                if (tag == "default") {
                    printf "%s-%s-%s\n", dist, version, arch;
                }
                else {
                    printf "%s-%s-%s-%s\n", dist, version, arch, tag;
                }
            }
        '
}

