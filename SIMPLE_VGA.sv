 // Simple VGA Pattern Generator

 // Description: Single-file VGA controller displaying test patterns
 //Author: [Your Name]
 //Date: January 2025
 //Target: Xilinx Artix-7 (Basys 3 / Nexys A7)
 //
 //Features:
 //  - VGA 640x480 @ 60Hz output
 //  - 4 selectable test patterns
 //  - No framebuffer (direct pattern generation)
 //  - Simple and easy to understand


module SIMPLE_VGA (
    input  logic       clk,          // 100 MHz system clock
    input  logic       rst,          // Reset button
    input  logic [1:0] sw,           // Switches for pattern selection
    output logic       vga_hsync,    // VGA horizontal sync
    output logic       vga_vsync,    // VGA vertical sync
    output logic [3:0] vga_r,        // VGA red (4 bits)
    output logic [3:0] vga_g,        // VGA green (4 bits)
    output logic [3:0] vga_b         // VGA blue (4 bits)
);


 logic clk_pix;       // 25.175 MHz output
 logic pll_locked;
 logic signed [11:0] dx, dy;
 localparam int cx = 320;
 localparam int cy = 240;
 localparam int r  = 200;


 clk_wiz_0 vga_pll_inst (
        .clk_in1(clk),
        .reset(rst),
        .clk_out1(clk_pix),
        .locked(pll_locked)
    );








    //==========================================================================
    // Clock Generation: 100 MHz -> ~25 MHz
    //==========================================================================
    // For VGA 640x480@60Hz, we need 25.175 MHz
    // We'll use 25 MHz (divide by 4) - close enough for most monitors
    
    //logic clk_25mhz;
    //logic [1:0] clk_counter;
   
    //
    //always_ff @(posedge clk or posedge rst) begin
    //    if (rst) begin
    //        clk_counter <= 0;
    //        clk_25mhz <= 0;
    //    end else begin
    //        clk_counter <= clk_counter + 1;
            // Toggle clk_25mhz every other cycle of clk_counter
            // This gives 100MHz / 4 = 25MHz
     //       if (clk_counter == 2'd1)
     //           clk_25mhz <= ~clk_25mhz;
      //  end
   // end
    
    //==========================================================================
    // VGA Timing Parameters (640x480 @ 60Hz)
    //==========================================================================
    // Horizontal timing (pixels)
    localparam H_DISPLAY   = 640;   // Display area
    localparam H_FRONT     = 16;    // Front porch
    localparam H_SYNC      = 96;    // Sync pulse
    localparam H_BACK      = 48;    // Back porch
    localparam H_TOTAL     = 800;   // Total pixels
    
    // Vertical timing (lines)
    localparam V_DISPLAY   = 480;   // Display area
    localparam V_FRONT     = 10;    // Front porch
    localparam V_SYNC      = 2;     // Sync pulse
    localparam V_BACK      = 33;    // Back porch
    localparam V_TOTAL     = 525;   // Total lines
    
    //==========================================================================
    // VGA Timing Counters
    //==========================================================================
    logic [9:0] h_count;  // Horizontal counter (0-799)
    logic [9:0] v_count;  // Vertical counter (0-524)
    
    // Horizontal counter
    always_ff @(posedge clk_pix or posedge rst) begin
        if (rst)
            h_count <= 0;
        else if (h_count == H_TOTAL - 1)
            h_count <= 0;
        else
            h_count <= h_count + 1;
    end
    
    // Vertical counter (increments when horizontal counter wraps)
    always_ff @(posedge clk_pix or posedge rst) begin
        if (rst)
            v_count <= 0;
        else if (h_count == H_TOTAL - 1) begin
            if (v_count == V_TOTAL - 1)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end
    end
    
    //==========================================================================
    // Sync Signal Generation
    //==========================================================================
    logic hsync_reg, vsync_reg;
    
    always_ff @(posedge clk_pix or posedge rst) begin
        if (rst) begin
            hsync_reg <= 1'b1;
            vsync_reg <= 1'b1;
        end else begin
            // Hsync: low during sync pulse (656-751)
            hsync_reg <= ~((h_count >= H_DISPLAY + H_FRONT) && 
                          (h_count < H_DISPLAY + H_FRONT + H_SYNC));
            
            // Vsync: low during sync pulse (490-491)
            vsync_reg <= ~((v_count >= V_DISPLAY + V_FRONT) && 
                          (v_count < V_DISPLAY + V_FRONT + V_SYNC));
        end
    end
    
    assign vga_hsync = hsync_reg;
    assign vga_vsync = vsync_reg;
    
    //==========================================================================
    // Video Active Region Detection
    //==========================================================================
    logic video_on;
    assign video_on = (h_count < H_DISPLAY) && (v_count < V_DISPLAY);
    
    //==========================================================================
    // Pattern Generation
    //==========================================================================
    always_ff @(posedge clk_pix or posedge rst) begin
        if (rst) begin
            vga_r <= 4'h0;
            vga_g <= 4'h0;
            vga_b <= 4'h0;
        end else if (video_on) begin
            // Generate pattern based on switch selection
            case (sw)
                2'b00: begin  // Pattern 0: Color Bars
                    if (h_count < 80) begin
                        // White
                        vga_r <= 4'hF;
                        vga_g <= 4'hF;
                        vga_b <= 4'hF;
                    end else if (h_count < 160) begin
                        // Yellow
                        vga_r <= 4'hF;
                        vga_g <= 4'hF;
                        vga_b <= 4'h0;
                    end else if (h_count < 240) begin
                        // Cyan
                        vga_r <= 4'h0;
                        vga_g <= 4'hF;
                        vga_b <= 4'hF;
                    end else if (h_count < 320) begin
                        // Green
                        vga_r <= 4'h0;
                        vga_g <= 4'hF;
                        vga_b <= 4'h0;
                    end else if (h_count < 400) begin
                        // Magenta
                        vga_r <= 4'hF;
                        vga_g <= 4'h0;
                        vga_b <= 4'hF;
                    end else if (h_count < 480) begin
                        // Red
                        vga_r <= 4'hF;
                        vga_g <= 4'h0;
                        vga_b <= 4'h0;
                    end else if (h_count < 560) begin
                        // Blue
                        vga_r <= 4'h0;
                        vga_g <= 4'h0;
                        vga_b <= 4'hF;
                    end else begin
                        // Black
                        vga_r <= 4'h0;
                        vga_g <= 4'h0;
                        vga_b <= 4'h0;
                    end
                end
                
                2'b01: begin  // Pattern 1: Checkerboard
                    // XOR of bit 5 creates checkerboard pattern
                    if ((h_count[5] ^ v_count[5]) == 1'b1) begin
                        vga_r <= 4'hF;
                        vga_g <= 4'hF;
                        vga_b <= 4'hF;
                    end else begin
                        vga_r <= 4'h0;
                        vga_g <= 4'h0;
                        vga_b <= 4'h0;
                    end
                end
                
                2'b10: begin  // Pattern 2: RGB Gradient
                    // Use upper bits of position for color
                    vga_r <= h_count[9:6];  // Red increases horizontally
                    vga_g <= v_count[9:6];  // Green increases vertically
                    vga_b <= 4'h8;          // Blue constant medium
                end
                
                  // Pattern 3: Border Test
                    // Red border, blue center
                    //if (h_count < 10 || h_count > 629 || 
                        //v_count < 10 || v_count > 469) begin
                        // Border
                        //vga_r <= 4'h0;
                        //vga_g <= 4'h0;
                        //vga_b <= 4'h0;
                    //end else begin
                        // Center
                        //vga_r <= 4'h0;
                        //vga_g <= 4'h0;
                        //vga_b <= 4'hF;
                    //end
         2'b11: begin  // Pattern 3: Circle Pattern
    // Use the CURRENT pixel coordinates from VGA timing
    dx <= h_count - cx;  // hcount is your current X position
    dy <= v_count - cy;  // vcount is your current Y position
    
    if (dx*dx + dy*dy <= r*r) begin
        // White circle
        vga_r <= 4'hF;
        vga_g <= 4'hF;
        vga_b <= 4'hF;
    end else begin
        // Black background
        vga_r <= 4'h0;
        vga_g <= 4'h0;
        vga_b <= 4'h0;
    end
end
   endcase
        end else begin
            // Blanking interval - output black
            vga_r <= 4'h0;
            vga_g <= 4'h0;
            vga_b <= 4'h0;
        end
    end

endmodule
