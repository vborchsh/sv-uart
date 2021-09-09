onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sv_uart_tx/iclk
add wave -noupdate /sv_uart_tx/irst
add wave -noupdate /sv_uart_tx/s_axis_tvalid
add wave -noupdate /sv_uart_tx/s_axis_tdata
add wave -noupdate /sv_uart_tx/s_axis_tready
add wave -noupdate /sv_uart_tx/idivider
add wave -noupdate /sv_uart_tx/otx
add wave -noupdate /sv_uart_tx/clk_ena
add wave -noupdate /sv_uart_tx/baud_gen
add wave -noupdate /sv_uart_tx/cnt
add wave -noupdate /sv_uart_tx/fdat
add wave -noupdate /sv_uart_tx/freg
add wave -noupdate /sv_uart_tx/ST
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
