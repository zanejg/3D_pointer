use <cable_gear.scad>;
use <model_sprung_reel.scad>;
use <encoder_gear.scad>

$fn=60;

ENCODER_CABLE_DISTANCE = 46.7;
SPRUNG_REEL_X = -70;
SPRUNG_REEL_Y = -20;

BOX_LN=170;
BOX_WD=100;
BOX_HT=3;
BOX_WALL_HT = 8;
BOX_WALL_TN = 3;

// model offsets
X = 15;
Y = 5;
Z = 29;

ENCODER_X = ENCODER_CABLE_DISTANCE + X;

module whole_box(){
    // Box base
    translate([0, 0, -6.5]){
        cube([BOX_LN, BOX_WD,BOX_HT], center=true);
        translate([0, 0, (BOX_WALL_HT - BOX_HT)/2]){
            difference(){
                cube([BOX_LN + BOX_WALL_TN, BOX_WD+BOX_WALL_TN , BOX_WALL_HT], center=true);
                cube([BOX_LN , BOX_WD, BOX_WALL_HT+1], center=true);
            }
        }
    }
    // cable hole stanchion
    rotate([0, 0, 180]){
        translate([BOX_LN/2-1, -BOX_WD/2 + 15, 5]){
            difference(){
                cube([4,20,25 ], center=true);
                #translate([-3, 0, 7.5]){
                    rotate([0, 90, 0]){
                        cylinder(h = 6, r = 3);
                    }
                }
            }
            translate([-8, 0, -3]){
                difference(){
                    cube([15,20,15 ], center=true);
                    translate([-9, 11, 10]){
                        rotate([90, 0, 0]){
                            cylinder(h = 22, r = 15);
                        }
                    }
                }
            }
        }
    }
    
    translate([SPRUNG_REEL_X + X, SPRUNG_REEL_Y + Y, 0]){
        difference(){
            // The sprung reel shaft needs to be split
            translate([0, 0, -6.5]){
                cylinder(h = 36.5, r = 7/2, center=false);
            }
            translate([0, 0, 23]){
                cube([8, 1, 35], center=true);
            }
        }
        // Fillet at base of shaft
        translate([0, 0, -5]){
            difference(){
                cylinder(h = 6, r = 10);
                translate([0, 0, 6]){
                    rotate_extrude(angle=360){
                        translate([7/2+6,0,0]){
                            circle(r = 6);    
                        }
                    }
                }
            }
        }
        // Ring surround for reel support
        translate([0, 0, -5.1]){
            difference(){
                cylinder(h = 9, r = 18/2);
                cylinder(h = 10, r = 15/2);
            }
        }
    
    }
    
    //encoder_mount();
    
    
    
    // Cable gear hub
    translate([X, Y, BOX_HT/2]){
        cylinder(h = 10, r = 8.2/2);
        translate([0, 0, -6.6]){
            cylinder(h = 8, r = 12/2);
        }
    }
    
    
    
}
//################################################################
//###############################################################
module encoder_mount(){
    // encoder mount
    MOUNT_LN=27;
    MOUNT_WD=22;
    MOUNT_HT=10;
    translate([ENCODER_X + 3, Y+1, 0]){
        difference(){
            cube([MOUNT_LN, MOUNT_WD, MOUNT_HT], center=true);
    
            // cavity under board
            translate([0, 0, 5]){
                rotate([0, 90, 0]){
                    cylinder(h = MOUNT_LN * 1.2, r = MOUNT_WD/3.4, center=true);
                }
            }
            //chop off corner to avoid connector pins
            translate([MOUNT_LN/2 + 1, MOUNT_WD/2 - 3, 4]){
                cube([15, 8, 5], center=true);
            }
    
            // screwholes
            translate([-9.5, -MOUNT_WD/2 + 2, 0]){
                cylinder(h = 12, r = 2/2);
            }
            translate([-9.5 + 16.5, -MOUNT_WD/2 + 2, 0]){
                cylinder(h = 12, r = 2/2);
            }
        }
        // PCB corner grip
        translate([-MOUNT_LN/2 + 1, MOUNT_WD/2 - 3.5, MOUNT_HT/2 +2]){
            difference(){
                rotate([0, 0, 45]){
                    cube([4, 4,4 ], center=true);
                }
                translate([0, -2.5, -(2-1.7/2)]){
                    cube([6, 4, 1.7], center=true);
                }
                translate([-2, 0, 0]){
                    cube([2,6 ,6 ], center=true);
                }
            }
        }
    }
}

//###############################################
// Measuring sticks for the encoder mount

// translate([73, 5.4, 7]){
//     cube([2, 14.9,2 ], center=true);
// }
// translate([55, 5.4, 7]){
//     cube([2, 14.9,2 ], center=true);
// }
// color("yellow",1.0){
//     translate([52.7, -3.7, 7]){
//         cube([3, 1,1 ], center=true);
//     }
// }

//###############################################





// MODELLING for the cogs etc

module cogs_etc(){
    
    rotate([180, 0, 0]){
        cable_gear();
    }
    
    translate([ENCODER_CABLE_DISTANCE, 0, -10]){
        rotate([0, 0, 30]){
            encoder_gear();
        }
    }
    
    
    
    translate([ENCODER_CABLE_DISTANCE, 0, -22.6]){
        color("green",1.0){
            rotate([0, 0, 180]){
                import("rotary_switch-Part.stl");
            }
        }
    }
    
    translate([-70, -20, -13]){
        color("darkgray",1.0){
            sprung_reel();
        }
    }
}





// translate([X, Y, Z]){
//     cogs_etc();
// }

translate([0, 0, 1.4]){
    whole_box();
}

//encoder_mount();