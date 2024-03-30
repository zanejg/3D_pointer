use <../OpenSCAD/MCAD/involute_gears.scad>
$fn=100;
pi = 3.14159;
GEAR_TN = 10;
CENTER_HUB_RD = 15;

module cable_gear(){
    
    
    difference(){
        gear (number_of_teeth=18,
                    circular_pitch=700*pi/180,
                    gear_thickness=GEAR_TN,
                    rim_thickness=GEAR_TN,
                    hub_thickness=GEAR_TN/2,
                    hub_diameter=10,
                    circles=0);
    
        translate([0, 0, 3]){
            difference(){
                cylinder(h = GEAR_TN, r = 25);
                
            }
        }
    }
    
    //CENTER_HUB_RD = 15;
    difference(){
        cylinder(h = 25, r = CENTER_HUB_RD);
        translate([0, 0, 18]){
            cylinder(h = 7.2, r = 22/2);
        }
        translate([0, 0, 11]){
            cylinder(h = 8, r = 16/2);
        }
    }
    
}
cable_gear();
// GRIPPING SPOOL
module gripping_spool(){
    // V-shaped profile rim to be printed in TPU to put around 
    // the hub of the cable gear

    SPOOL_HT = 10;
    SPOOL_WD = 10;
    GRIP_DP = 5;
    NUMBER_TEETH = 25;
    tooth_angle = 360/NUMBER_TEETH;
    
    spool_grip_pts = [
        [0, 0],
        [SPOOL_WD,0],
        [SPOOL_WD-GRIP_DP, SPOOL_HT/2],
        [SPOOL_WD, SPOOL_HT],
        [0, SPOOL_HT],
    ];

    tooth_rd = CENTER_HUB_RD + (SPOOL_WD - GRIP_DP) - 0.3  ;

    translate([0, 0, 20]){
        rotate_extrude(angle=360){ 
            translate([CENTER_HUB_RD + 0.1, -SPOOL_HT/2, 0]){
                polygon(points = spool_grip_pts);
            }
        }
        for(i = [0:NUMBER_TEETH-1]){
            rotate([0, 0, i*tooth_angle]){
                translate([tooth_rd, 0, 0]){
                    biter();
                }
            }
        }
    }
    
}
color("green",1.0){
    intersection(){
        !gripping_spool();
        translate([0, 0, 25]){
            difference(){
                cylinder(h = 5, r = CENTER_HUB_RD + 10, center=true);
                cylinder(h = 6, r = CENTER_HUB_RD -1, center=true);
            }
        }
    }
    
}


module biter(){
    BITER_AN = 20;
    BITER_HT = 4;
    translate([0, 0, BITER_HT/2-0.5]){
        rotate([0, BITER_AN,0]){
            scale([1.2, 1, 1]){
                rotate([0, 0, 45]){
                    cube([2,2 ,BITER_HT ], center=true);   
                }
            }
        }
    }
    translate([0, 0, -BITER_HT/2+0.5]){
        rotate([0, -BITER_AN,0]){
            scale([1.2, 1, 1]){
                rotate([0, 0, 45]){
                    cube([2,2 ,BITER_HT ], center=true);   
                }
            }
        }
    }
}

