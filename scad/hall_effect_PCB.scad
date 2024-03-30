$fn=60;
use <strip_connector_female.scad>
use <strip_connector_male.scad>

SCREWHOLE_RD=3.2/2;
PCB_WD = 40;
PCB_HT = 38;
PCB_TN=1.7;

HALL_PCB_SZ =20;
module hall_PCB_assy(){
    
    color("green",1.0){
        // Variboard PCB
        union(){
            difference(){
                cube([PCB_WD, PCB_HT, PCB_TN], center=true); // pcb
                translate([PCB_WD/2 - 4, PCB_HT/2-4, 0]){
                    cylinder(h = 2, r = SCREWHOLE_RD, center=true); // screw hole
                }
            }
            
            // start at 7mm from edge then work back in 2.2mm increments
            for(x = [13,13-(2.2*3),13-(2.2*10)]){
                translate([x, -5.4, -2.45]){
                    rotate([0, 0, 90]){
                        multi_female_connector(6);
                    }
                }
            }
        }
    }
    
    
    color("purple",1.0){
        
        // 90393 3D HAll Effect Sensor
        translate([-1, 3.2, 12.6]){
            union(){
                difference(){
                    cube([HALL_PCB_SZ, HALL_PCB_SZ, PCB_TN], center=true); // main PCB
                    // screwholes
                    translate([HALL_PCB_SZ/2 - 2.5, HALL_PCB_SZ/2 - 2.5, 0]){
                        cylinder(h = 2, r = SCREWHOLE_RD, center=true); // screw hole
                    }
                    translate([-HALL_PCB_SZ/2 + 2.5, HALL_PCB_SZ/2 - 2.5, 0]){
                        cylinder(h = 2, r = SCREWHOLE_RD, center=true); // screw hole
                    }
                }
                // chip sensor
                translate([0, 0, PCB_TN/2]){
                    cube([3, 3, PCB_TN], center=true);
                }
                
            
                translate([-10 + 2, -10 + 1.4, 2.25]){
                    rotate([180, 0, 90]){
                        multi_male_connector(conn_count = 6);
                    }
                }
                translate([10 - 2, -10 + 1.4, 2.25]){
                    rotate([180, 0, 90]){
                        multi_male_connector(conn_count = 6);
                    }
                }
            }
            
        }
        
    }
}