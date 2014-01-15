FTP Bulk Download Stuff
-----------------------

First, genny up a list of FTP servers that respond favorably to SYN:

    sudo zmap -p 21 -o - -v 5 | gzip > ftpsites.gz

(zmap from <https://github.com/zmap/zmap>)

Then, look through them for sites that respond favorably to
'anonymous' login and the LIST command:

    zcat ftpsites.gz | parallel -j 100 ./check-ftp.sh {} ;
