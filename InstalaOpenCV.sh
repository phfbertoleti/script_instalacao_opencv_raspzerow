#!/bin/bash


PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
CMD_DEPENDENCIAS="apt-get pip sudo unzip wget"


#
# Funcoes
#
insert_msg()
{
  local msg=$1

  echo ""
  echo "-----------------------------------------------"
  echo "${msg}"
  echo "-----------------------------------------------"
  echo ""
}

check_root()
{
  local id_user=$(id -u)
  if [ "${id_user}" == "0" ]; then
    echo "[OK]  Permissao para super-usuario"
  else
    echo "[ERR]  Voce nao possui permissao de super-usuario"
    exit 4
  fi
}

check_dep()
{
  for cmd in ${CMD_DEPENDENCIAS}; do
    which ${cmd} >/dev/null 2>&1
    if [ "$?" == "1" ]; then
      echo "[ERR]  Comando ${cmd} nao encontrado!"
      exit 5
    fi
    echo "[OK]  ${cmd}"
  done
}

check_internet()
{
  # Verificando conexao internet, 1 ping com timeout de 3s
  ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1
  if [ "$?" != "0" ]; then
    echo ""
    echo "[ERR]  Internet Offline"
    exit 6
  fi

  # Verificando DNS configurado corretamente para resolver hosts, 1 ping com timeout de 3s
  ping -c 1 -W 3 google.com.br >/dev/null 2>&1
  if [ "$?" != "0" ]; then
    echo "[ERR]  Falha na resolucao de host, verifique o seu DNS"
    exit 7
  fi

  echo "[OK]  Conexao com Internet"
}


#
# Main
#

# Funcao para verificar permissao de super-usuario
insert_msg "Verificando Permissao de Super-Usuario"
check_root

# Funcao para verificar dependencias
insert_msg "Verificando dependencias, aguarde..."
check_dep

# Funcao para verificar conexao com internet
insert_msg "Verificando conexao com a Internet"
check_internet


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

# Sucesso
exit 0
