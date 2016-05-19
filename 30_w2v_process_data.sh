#!/usr/bin/env bash
#
#
#
#
#

set -e

DATA_OUT_DIR="./word2vec"

W2V_THREADS=${W2V_THREADS:-4}
W2V_DEBUG=${W2V_DEBUG:-2}

[ -f "$DATA_IN" ] || ( echo "missing \$DATA_IN: ${DATA_IN}"; exit 1)
[ -z $W2V_SIZE ] && (echo "missing: \$W2V_SIZE"; exit 1)            # 500
[ -z $W2V_WINDOW ] && (echo "missing: \$W2V_WINDOW"; exit 1)        #  10
[ -z $W2V_SAMPLE ] && (echo "missing: \$W2V_SAMPLE"; exit 1)        #  10
[ -z $W2V_HS ] && (echo "missing: \$W2V_HS"; exit 1)                #   1
[ -z $W2V_NEGATIVE ] && (echo "missing: \$W2V_NEGATIVE"; exit 1)    #   5
[ -z $W2V_ITER ] && (echo "missing: \$W2V_ITER"; exit 1)            #   5
[ -z $W2V_MINCOUNT ] && (echo "missing: \$W2V_MINCOUNT"; exit 1)    #   
[ -z $W2V_ALPHA ] && (echo "missing: \$W2V_ALPHA"; exit 1)          #
[ -z $W2V_CBOW ] && (echo "missing: \$W2V_CBOW"; exit 1)            #

DATA_IN_DIR=$(dirname "$DATA_IN")
DATA_IN_FN=$(basename "$DATA_IN")

DATA_OUT_FN=$(basename "$DATA_IN" .txt)-size${W2V_SIZE}-window${W2V_WINDOW}-sample${W2V_SAMPLE}-hs${W2V_HS}-neg${W2V_NEGATIVE}-iter${W2V_ITER}-mincnt${W2V_MINCOUNT}-alpha${W2V_ALPHA}-cbow${W2V_CBOW}

[ -f "$DATA_OUT_DIR"/"$DATA_OUT_FN".vec ] && ( echo "output already exists: ${DATA_OUT_DIR}/${DATA_OUT_FN}.vec"; exit 1)

mkdir -p word2vec
./tmp/word2vec.svn/word2vec \
    -train "${DATA_IN_DIR}"/"${DATA_IN_FN}" \
    -output "${DATA_OUT_DIR}"/"${DATA_OUT_FN}".vec \
    -size $W2V_SIZE \
    -window $W2V_WINDOW \
    -sample $W2V_SAMPLE \
    -hs $W2V_HS \
    -negative $W2V_NEGATIVE \
    -iter $W2V_ITER \
    -min-count $W2V_MINCOUNT \
    -alpha $W2V_ALPHA \
    -cbow $W2V_CBOW \
    -threads $W2V_THREADS \
    -debug $W2V_DEBUG \
    -save-vocab "${DATA_OUT_DIR}"/"${DATA_OUT_FN}".voc
