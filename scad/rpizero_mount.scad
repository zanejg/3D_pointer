// RPI Zero standoff stanchions positioned correctly for the RPI Zero
// 4x 7mm stanchions with 2.8mm screw holes

$fn=100;


RPI_HOLE_WD = 58;
RPI_HOLE_LN = 23;
rpi_screwhole_x = RPI_HOLE_WD/2;
rpi_screwhole_y = RPI_HOLE_LN/2;

module RPI_Zero_mount(){
    
    STANCHION_RD = 7/2;
    SCREWHOLE_RD = 2.8/2;
    
    
    rpi_coords = [
        [rpi_screwhole_x, rpi_screwhole_y],
        [-rpi_screwhole_x, rpi_screwhole_y],
        [-rpi_screwhole_x, -rpi_screwhole_y],
        [rpi_screwhole_x, -rpi_screwhole_y],
    ];
    
    for (i = [0:3]) {
        translate([rpi_coords[i][0], rpi_coords[i][1], 0]) {
            difference(){
                cylinder(h = 10, r = STANCHION_RD, center = true);
                cylinder(h = 10.1, r = SCREWHOLE_RD, center = true);
            }
        }
    }
    
}
//RPI_Zero_mount();
 
//  The RPI Zero mount is a simple module that creates 4 stanchions with screw holes positioned correctly for the RPI Zero. 
//  The stanchions are 7mm in diameter and the screw holes are 2.8mm in diameter. 
