#!/bin/bash
echo Building OpenPLC environment:
echo [OPLC_COMPILER]
cd OPLC_Compiler_source
g++ *.cpp -o OPLC_Compiler &> /dev/null
echo [LADDER]
cd ..
cp ./OPLC_Compiler_source/OPLC_Compiler ./
./OPLC_Compiler ./ladder_files/blank_ladder.ld &> /dev/null
rm ./core/ladder.cpp
mv ./ladder.cpp ./core/
cd core
rm ./hardware_layer.cpp

echo [OPLC_STARTER]
cd OPLC_starter_src
g++ *.cpp -o OPLC_starter
cd ..
cp ./OPLC_starter_src/OPLC_starter ./

echo The OpenPLC needs a driver to be able to control physical or virtual hardware.
echo Please select the driver you would like to use:
OPTIONS="Blank Fischertechnik RaspberryPi Simulink Unipi"
select opt in $OPTIONS; do
	if [ "$opt" = "Blank" ]; then
		cp ./hardware_layers/blank.cpp ./hardware_layer.cpp
		echo [OPENPLC]
		g++ -pthread *.cpp -o openplc
		exit
	elif [ "$opt" = "Fischertechnik" ]; then
		cp ./hardware_layers/fischertechnik.cpp ./hardware_layer.cpp
		echo [OPENPLC]
		g++ -lrt -lwiringPi -lpthread *.cpp -o openplc
		exit
	elif [ "$opt" = "RaspberryPi" ]; then
		cp ./hardware_layers/raspberrypi.cpp ./hardware_layer.cpp
		echo [OPENPLC]
		g++ -lrt -lwiringPi -lpthread *.cpp -o openplc
		exit
	elif [ "$opt" = "Simulink" ]; then
		cp ./hardware_layers/simulink.cpp ./hardware_layer.cpp
		echo [OPENPLC]
		g++ -pthread *.cpp -o openplc
		exit
	elif [ "$opt" = "Unipi" ]; then
		cp ./hardware_layers/unipi.cpp ./hardware_layer.cpp
		echo [OPENPLC]
		g++ -lrt -lwiringPi -lpthread *.cpp -o openplc
		exit
	else
		#clear
		echo bad option
	fi
done
