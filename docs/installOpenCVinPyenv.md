# Install OpenCV for Python 3 in Pyenv

Tested with OpenCV 3.1.1 and Python 3.5.2.

1. Create a new virtual-env.

```sh
pyenv virtualenv PYTHON_VERSION opencv_env-PYTHON_VERSION
pyenv local opencv_env-PYTHON_VERSION
```

2. Build OpenCV.

```sh
git clone https://github.com/opencv/opencv.git

cd opencv
mkdir build
cd build

PREFIX=`pyenv prefix`
PREFIX_MAIN=`pyenv virtualenv-prefix`

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX="$PREFIX" \
    -D PYTHON3_EXECUTABLE="$PREFIX"/bin/python \
    -D PYTHON3_PACKAGES_PATH="$PREFIX"/lib/python3.5/site-packages \
    -D PYTHON3_LIBRARY="$PREFIX_MAIN"/lib/libpython3.5m.dylib \
    -D PYTHON3_INCLUDE_DIR="$PREFIX_MAIN"/include/python3.5m \
    -D PYTHON3_NUMPY_INCLUDE_DIRS="$PREFIX"/lib/python3.5/site-packages/numpy/core/include \
    -D INSTALL_C_EXAMPLES=OFF \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D BUILD_EXAMPLES=ON \
    -D BUILD_opencv_python3=ON \
    -D INSTALL_NAME_DIR=${CMAKE_INSTALL_PREFIX}/lib ..

make -j12
make install
```
