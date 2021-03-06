#!/usr/bin/env bash
#
# Get training, test, etc. data for EmpiriST 2016
# * de.wikipedia.org Artikel, Artikeldiskussionen, Nutzerdiskussionen

set -e
. 99_utils-get_data

#
### Wikipedia
#
# from http://corpora.ids-mannheim.de/pub/wikipedia-deutsch/2015/
# cf. http://www1.ids-mannheim.de/kl/projekte/korpora/verfuegbarkeit.html#Download
#
# * download Artikel, Artikeldiskussionen, Nutzerdiskussionen of the German Wikipedia
# * make them look like one-token-per-line files
# * introduce <s> </s> marks
# * convert from latin1 to utf-8 (silently ignoring errors)
#
# This data still needs to be processed be word2vec (or a different method)
#
SUBDIR=tmp/de.wikipedia.org
mkdir -p ${SUBDIR}
for file in wud15.tt.xml.bz2 wdd15.tt.xml.bz2 wpd15.tt.xml.bz2; do

    [ -e "${SUBDIR}"/$(basename "${file}" .tt.xml.bz2).tt.bz2 ] \
    || 
    ( \
        download "${SUBDIR}"/"${file}" 'http://corpora.ids-mannheim.de/pub/wikipedia-deutsch/2015/'"${file}" \
        && echo "Downloaded ${file}" \
        && bzcat "${SUBDIR}"/"${file}" \
           | grep -e 'sentence>' -e '<surface-form>' \
           | sed -e 's#\s\+<sentence>#<s>#' \
                 -e 's#\s\+</sentence>#</s>#' \
                 -e 's#\s\+<surface-form>##' \
                 -e 's#</surface-form>##' \
           > "${SUBDIR}"/$(basename "${file}" .tt.xml.bz2).tt \
        && echo "tt-ed ${file}"

        iconv -flatin1 -tutf8//IGNORE "${SUBDIR}"/$(basename "${file}" .tt.xml.bz2).tt \
        | bzip2 -c -9 > "${SUBDIR}"/$(basename "${file}" .tt.xml.bz2).tt.bz2 \
        && echo "iconv-ed ${file}" \
        && rm "${SUBDIR}"/$(basename "${file}" .tt.xml.bz2).tt
   )
done
