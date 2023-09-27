onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /lab7_check_tb/DUT/CPU/Moore/states
add wave -noupdate /lab7_check_tb/DUT/out_mem
add wave -noupdate /lab7_check_tb/DUT/mem_addr
add wave -noupdate /lab7_check_tb/DUT/CPU/vsel
add wave -noupdate -radix binary /lab7_check_tb/DUT/CPU/DP/datapath_out
add wave -noupdate /lab7_check_tb/DUT/CPU/PC
add wave -noupdate /lab7_check_tb/DUT/mem_cmd
add wave -noupdate /lab7_check_tb/DUT/CPU/sximm5
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/loadc
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/mdata
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/B_shift
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/loada
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/loadb
add wave -noupdate /lab7_check_tb/DUT/CPU/addr_sel
add wave -noupdate /lab7_check_tb/DUT/CPU/addr_out
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/alu/Ain
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/alu/Bin
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/alu/out
add wave -noupdate /lab7_check_tb/DUT/CPU/load_addr
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/REGFILE/R1
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/alu/ALUop
add wave -noupdate /lab7_check_tb/DUT/CPU/DP/readnum
add wave -noupdate /lab7_check_tb/DUT/write
add wave -noupdate /lab7_check_tb/DUT/write_address
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {319 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {216 ps} {342 ps}
