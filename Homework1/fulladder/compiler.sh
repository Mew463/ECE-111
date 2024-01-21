# NO SPACES!!!
toplevelname="fulladder"
designfile="fulladder_gate.sv"
testbench="fulladdder_testbench.sv"

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
    yosys -p "read_verilog -sv $designfile; proc; write_json $designfile.rtl.json; synth_ice40; show -prefix $designfile.post_mapping -format svg -long -enum"
    netlistsvg $designfile.rtl.json -o $designfile.rtl.svg
    rsvg-convert -h 1000 -b white $designfile.rtl.svg > $designfile.rtl.png
    rsvg-convert -h 1000 -b white $designfile.post_mapping.svg > $designfile.post_mapping.png

    rm $designfile.rtl.json
    rm $designfile.rtl.svg
    rm $designfile.post_mapping.svg
    rm $designfile.post_mapping.dot
fi
