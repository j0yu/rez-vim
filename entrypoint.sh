#!/bin/bash
set -euf -o pipefail


git clone -b "v${VERSION}" \
    https://github.com/vim/vim.git \
    /usr/local/src/vim

cd /usr/local/src/vim/src

autoconf

PY_INCLUDES_ARGS=(/usr/include -mindepth 1 -maxdepth 1 -name "python*")
readarray -t PY_INCLUDES < <(find "${PY_INCLUDES_ARGS[@]}" -printf "-I%p\n")
CFLAGS="-D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_FORTIFY_SOURCE=2 ${PY_INCLUDES[*]}"
export CFLAGS CXXFLAGS="$CFLAGS"

./configure --prefix="${INSTALL_DIR}" \
    --with-features=huge \
    --enable-python3interp=dynamic \
    --with-python3-command=python3 \
    --enable-pythoninterp=dynamic \
    --with-python-command=python2
make -j$(nproc)
make install

# # Check how our vim compares (features) with the older one from yum/CentOS
# RUN make install
# RUN vim --version | sed -n -e '/):/,/:/ { s/  */\n/gp }' | grep '^+' | sort > /tmp/vim7.txt
# RUN ./vim --version | sed -n -e '/):/,/:/ { s/  */\n/gp }' | grep '^+' | sort > /tmp/vim8.txt
# RUN vimdiff /tmp/vim*

