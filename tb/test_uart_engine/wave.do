onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group engine /sv_uart_engine/iclk
add wave -noupdate -group engine /sv_uart_engine/irst
add wave -noupdate -group engine /sv_uart_engine/m_axis_tdata
add wave -noupdate -group engine /sv_uart_engine/m_axis_tvalid
add wave -noupdate -group engine /sv_uart_engine/m_axis_tready
add wave -noupdate -group engine /sv_uart_engine/s_axis_tdata
add wave -noupdate -group engine /sv_uart_engine/s_axis_tvalid
add wave -noupdate -group engine /sv_uart_engine/s_axis_tready
add wave -noupdate -group engine /sv_uart_engine/idivider
add wave -noupdate -group engine /sv_uart_engine/otx
add wave -noupdate -group engine /sv_uart_engine/irx
add wave -noupdate -group engine /sv_uart_engine/tx__iclk
add wave -noupdate -group engine /sv_uart_engine/tx__irst
add wave -noupdate -group engine /sv_uart_engine/tx__s_axis_tdata
add wave -noupdate -group engine /sv_uart_engine/tx__s_axis_tvalid
add wave -noupdate -group engine /sv_uart_engine/tx__s_axis_tready
add wave -noupdate -group engine /sv_uart_engine/tx__idivider
add wave -noupdate -group engine /sv_uart_engine/tx__otx
add wave -noupdate -group engine /sv_uart_engine/rx__iclk
add wave -noupdate -group engine /sv_uart_engine/rx__irst
add wave -noupdate -group engine /sv_uart_engine/rx__m_axis_tdata
add wave -noupdate -group engine /sv_uart_engine/rx__m_axis_tvalid
add wave -noupdate -group engine /sv_uart_engine/rx__m_axis_tready
add wave -noupdate -group engine /sv_uart_engine/rx__idivider
add wave -noupdate -group engine /sv_uart_engine/rx__irx
add wave -noupdate -group engine /sv_uart_engine/tx_busy
add wave -noupdate -group engine /sv_uart_engine/tx_dat
add wave -noupdate -group engine /sv_uart_engine/cnt_tx
add wave -noupdate -group rx /sv_uart_engine/rx__/iclk
add wave -noupdate -group rx /sv_uart_engine/rx__/irst
add wave -noupdate -group rx /sv_uart_engine/rx__/m_axis_tdata
add wave -noupdate -group rx /sv_uart_engine/rx__/m_axis_tvalid
add wave -noupdate -group rx /sv_uart_engine/rx__/m_axis_tready
add wave -noupdate -group rx /sv_uart_engine/rx__/idivider
add wave -noupdate -group rx /sv_uart_engine/rx__/irx
add wave -noupdate -group rx /sv_uart_engine/rx__/frx
add wave -noupdate -group rx /sv_uart_engine/rx__/true_rx
add wave -noupdate -group rx /sv_uart_engine/rx__/dtrue_rx
add wave -noupdate -group rx /sv_uart_engine/rx__/ena
add wave -noupdate -group rx /sv_uart_engine/rx__/clk_ena
add wave -noupdate -group rx /sv_uart_engine/rx__/fall_rx
add wave -noupdate -group rx /sv_uart_engine/rx__/eop
add wave -noupdate -group rx /sv_uart_engine/rx__/cnt
add wave -noupdate -group rx /sv_uart_engine/rx__/cnt_pack
add wave -noupdate -group rx /sv_uart_engine/rx__/freg
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/iclk
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/irst
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/s_axis_tdata
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/s_axis_tvalid
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/s_axis_tready
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/idivider
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/otx
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/clk_ena
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/baud_gen
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/cnt
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/freg
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/stopbits
add wave -noupdate -expand -group tx /sv_uart_engine/tx__/ST
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14016018 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {21 us}
