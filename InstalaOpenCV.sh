#!/bin/bash

echo ""
echo "-----------------------------------------------"
echo "Instalacao de pacotes necessarios para o OpenCV"
echo "-----------------------------------------------"
echo ""

sudo apt-get install -y build-essential cmake pkg-config
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libgtk2.0-dev
sudo apt-get install -y libatlas-base-dev gfortran
sudo apt-get install -y python2.7-dev python3-dev

echo ""
echo "----------------------------------------"
echo "Download do codigo-fonte do OpenCV 3.1.0"
echo "----------------------------------------"
echo ""

cd ~
wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.1.0.zip
unzip opencv.zip

wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip
unzip opencv_contrib.zip

echo ""
echo "------------------------------------------------------------------------"
echo "Instalacao do numpy "
echo "(pacote do Python para operacoes com arrays e matrizes multidimensionais"
echo "------------------------------------------------------------------------"
echo ""

pip install numpy

echo ""
echo "--------------------------"
echo "Compilacao do OpenCV 3.1.0"
echo "--------------------------"
echo ""

cd ~/opencv-3.1.0/
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D ENABLE_PRECOMPILED_HEADERS=OFF \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.1.0/modules \
    -D BUILD_EXAMPLES=ON ..


make

echo ""
echo "--------------------------"
echo "Instalacao do OpenCV 3.1.0"
echo "--------------------------"
echo ""

sudo make install

echo ""
echo "--------------------------------------------"
echo "cria links e cache para bibliotecas"
echo "recentemente adicionadas (no caso, o OpenCV)"
echo "--------------------------------------------"
echo ""

sudo ldconfig
