# !/bin/bash

# NO SPACES!!!
toplevelname="conv_enc"
designfile="conv_enc.sv" #ADD ALL DESIGN FILES
testbench="conv_enc_tb.sv"

arg1=$1

if [ "$arg1" = "sim" ]; then
    iverilog -g2012 -o $toplevelname.vvp $designfile $testbench
    vvp $toplevelname.vvp -o
    rm $toplevelname.vvp
    mv dump.vcd.tmp  $toplevelname.vcd
    gtkwave $toplevelname.vcd

elif [ "$arg1" = "syn" ]; then
    yosys -p "read_verilog -sv $designfile; synth_ice40"

elif [ "$arg1" = "sch" ]; then
    yosys -p "read_verilog -sv $designfile; proc; write_json $toplevelname.rtl.json; synth_ice40; show -prefix $toplevelname.post_mapping -format svg -long -enum"
    netlistsvg $toplevelname.rtl.json -o $toplevelname.rtl.svg
    rsvg-convert -h 1000 -b white $toplevelname.rtl.svg > $toplevelname.rtl.png
    rsvg-convert -h 1000 -b white $toplevelname.post_mapping.svg > $toplevelname.post_mapping.png

    rm $toplevelname.rtl.json
    rm $toplevelname.rtl.svg
    rm $toplevelname.post_mapping.svg
    rm $toplevelname.post_mapping.dot
fi
