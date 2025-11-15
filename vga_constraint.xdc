################################################################################
# Constraints for Simple VGA Pattern Generator
# Target: Basys 3 Board (Artix-7)
################################################################################

#==========================================
# Clock
#==========================================
set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk -waveform {0.000 5.000} [get_ports clk]

#==========================================
# Reset Button (Center button)
#==========================================
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports rst]

#==========================================
# Switches (for pattern selection)
#==========================================
set_property -dict {PACKAGE_PIN V17 IOSTANDARD LVCMOS33} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN V16 IOSTANDARD LVCMOS33} [get_ports {sw[1]}]

#==========================================
# VGA Connector
#==========================================

# Horizontal Sync
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports vga_hsync]

# Vertical Sync
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports vga_vsync]

# Red (4 bits)
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {vga_r[0]}]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {vga_r[1]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {vga_r[2]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {vga_r[3]}]

# Green (4 bits)
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {vga_g[0]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {vga_g[1]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {vga_g[2]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {vga_g[3]}]

# Blue (4 bits)
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {vga_b[0]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {vga_b[1]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {vga_b[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {vga_b[3]}]

#==========================================
# Configuration
#==========================================
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

#==========================================
# Timing Constraints
#==========================================
# Create derived clock for VGA (25 MHz)
# The actual clock division happens in the design
create_generated_clock -name clk_25mhz -source [get_ports clk] -divide_by 4 [get_pins clk_25mhz_reg/Q]
