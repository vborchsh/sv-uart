onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sv_uart_rx/iclk
add wave -noupdate /sv_uart_rx/irst
add wave -noupdate /sv_uart_rx/m_axis_tvalid
add wave -noupdate /sv_uart_rx/m_axis_tdata
add wave -noupdate /sv_uart_rx/m_axis_tready
add wave -noupdate /sv_uart_rx/idivider
add wave -noupdate /sv_uart_rx/irx
add wave -noupdate /sv_uart_rx/frx
add wave -noupdate /sv_uart_rx/true_rx
add wave -noupdate /sv_uart_rx/dtrue_rx
add wave -noupdate /sv_uart_rx/ena
add wave -noupdate /sv_uart_rx/clk_ena
add wave -noupdate /sv_uart_rx/fall_rx
add wave -noupdate /sv_uart_rx/eop
add wave -noupdate /sv_uart_rx/cnt
add wave -noupdate /sv_uart_rx/cnt_pack
add wave -noupdate /sv_uart_rx/freg
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
