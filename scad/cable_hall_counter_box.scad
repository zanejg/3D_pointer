//use <cable_gear.scad>;
use <model_sprung_reel.scad>
use <encoder_gear.scad>
use <hall_effect_PCB.scad>
use <rpizero_mount.scad>
include <model_1602_display.scad>
include <model_Raspi_zero.scad>

$fn=100;

ENCODER_CABLE_DISTANCE = 46.7;
SPRUNG_REEL_X = -70;
SPRUNG_REEL_Y = -20;

BOX_LN=170;
BOX_WD=115;
BOX_HT=3;
BOX_WALL_HT = 8;
BOX_WALL_TN = 3;

// model offsets
X = 15;
Y = 5;
Z = 29;

ENCODER_X = ENCODER_CABLE_DISTANCE + X;

module oldbuttress(ht,ln){
    // // buttress for reel support
            
    // // CALCULATE THE ANGLE ACROSS THE DIAGONAL
    // buttress_an = atan(ln/ht);
    // buttress_diagonal = sqrt(ht^2 + ln^2);
    // // to ensure that the negative block crosses the diagonal
    // // all we have to do is ensure the edge goes thru the zero origin
    // neg_wd = buttress_diagonal;

    // neg_lcnr_x = -neg_wd/2;
    // neg_lcnr_y = -ht/2;
    // neg_lcnr_len = sqrt(neg_lcnr_x^2 + neg_lcnr_y^2);
    // lncr_an = -buttress_an;

    


    // translate([21, 0, 4.7]){
    //     difference(){
    //         cube([ht, TABLE_TN,ln ], center=true);
    //         #translate([neg_lcnr_len - ht/2, 0, ln/2]){
    //             rotate([0, buttress_an, 0]){
    //                 cube([buttress_diagonal, TABLE_TN * 1.1, ht], center=true);
    //             }
    //         }

    //     }
    // }
}

RECT_MATRIX = [ 
    [ 1, 1], 
    [ 1,-1], 
    [-1,-1], 
    [-1, 1] 
];

function rect(wd,ln) = [
        for (rm = RECT_MATRIX) 
            [rm[0]*wd/2, rm[1]*ln/2]
    ];


module buttress(ht,ln,tn){
    // buttress for reel support
    // calculate the 3 points of the triangle
    // the first point is the origin
    // the second point is the end of the buttress
    // the third point is the end of the buttress at the top        
    tri_points = [
        [0, 0],
        [0, ht],
        [ln, 0],
    ];

    rotate([90, 0, 0]){
        linear_extrude(height = tn, center=true){
            polygon(points = tri_points);
        }
    }


    
}
// buttress(45,20,2.5);


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
            translate([0, 0, 17.5]){
                difference(){
                    cube([4,20,60 ], center=true);
                    translate([-3, 0, 25]){
                        rotate([0, 90, 0]){
                            cylinder(h = 6, r = 3);
                        }
                    }
                }
            }
            // translate([-8, 0, 12]){
            //     difference(){
            //         cube([15,20,45 ], center=true);
            //         translate([-9, 11, 25]){
            //             rotate([90, 0, 0]){
            //                 cylinder(h = 22, r = 15);
            //             }
            //         }
            //     }
            // }
        }
    }
    // buttress for cable hole stanchion
    translate([-82.3, 43, -5]){
        buttress(ht = 40, ln = 20, tn = BOX_WALL_TN);
    }
    
    translate([SPRUNG_REEL_X + X, SPRUNG_REEL_Y + Y, 0]){
        difference(){
            // The sprung reel shaft needs to be split
            translate([0, 0, -6.5]){
                cylinder(h = 70, r = 7/2, center=false);
            }
            translate([0, 0, 50]){
                cube([8, 1, 35], center=true);
            }
        }
        // Fillet at base of shaft
        translate([0, 0, -5]){
            // difference(){
            //     cylinder(h = 6, r = 10);
            //     translate([0, 0, 6]){
            //         rotate_extrude(angle=360){
            //             translate([7/2+6,0,0]){
            //                 circle(r = 6);    
            //             }
            //         }
            //     }
            // }
            circular_fillet(12, 7/2, 6);
        }
        // Ring surround for reel support
        translate([0, 0, -5.1]){
            difference(){
                cylinder(h = 40.5, r = 18/2);
                cylinder(h = 50, r = 15/2);
            }
            // shore up the shaft with some support
            translate([0, 0, 17]){
                rotate([0, 0, -20]){
                    cube([16, 2, 35], center=true);
                }
            }
        }
        // buttress reel support
        translate([8.8, 0, -5.3]){
            buttress(ht = 25, ln = 20, tn= BOX_WALL_TN);
        }
    
    }
    
    //encoder_mount();
    
    
    
    // Cable gear hub using X and Y
    
    
    
}

// !whole_box();


module circular_fillet(outer_rd, inner_rd, ht){
    fillet_rd = outer_rd - inner_rd;
    difference(){
        // cylinder to surround the inner radius at outer rad tn
        cylinder(h = ht, r = outer_rd);
        // remove a donut shape from the cylinder
        translate([0, 0, ht]){
            rotate_extrude(angle=360){
                translate([outer_rd,0,0]){
                    circle(r = fillet_rd);    
                }
            }
        }
        // remove the inner radius
        translate([0, 0, -ht/20]){
            cylinder(h = ht*1.1, r = inner_rd);
        } 
    }
}


module straight_fillet(length, width, ht){
    difference(){
        cube([length, width, ht], center=true);
        translate([0, width/2, ht/2]){
            rotate([0, 90, 0]){
                linear_extrude(height = length*1.1, center=true){
                    scale([1,width/ht,1]){
                        circle(r = ht);
                    }
                }
            }
        } 
    }
  
}
// !straight_fillet(length = 30, width = 5, ht = 10);


// FOR CREATING THE CONICAL SECTION TO GRIP THE BEARING
// SMALLER RAD IS THE RAD OF THE BEARING - OS ***Not anymore
// LARGER RAD IS THE RAD OF THE BEARING + OS
CONICAL_OS = 0.75; 

// ################################################################
//############ ORIGINAL STICKY BEARING       ####################
// BEARING_OUTER_RD = 41/2;
// BEARING_INNER_RD = (30)/2; // 30 is true rad
// BEARING_HT = 6.5;
//################################################################
//#####  NEW BEARING WITH FREER RUNNING  ########################
BEARING_OUTER_RD = 37/2;
BEARING_INNER_RD = 20/2; //  is true rad
BEARING_HT = 9;


module bearing() {
    color("yellow",1.0){
        intersection(){
            difference() {
                cylinder(h = BEARING_HT, r = BEARING_OUTER_RD, center=true);
                cylinder(h = BEARING_HT * 1.1, r = BEARING_INNER_RD, center=true);
                translate([0, 0, -2]){
                    cylinder(h = BEARING_HT * 6, r2 = 0.1, r1 = BEARING_OUTER_RD + 10, center=true);
                }
            }
            translate([0, 0, 8.4]){
                cylinder(h = BEARING_HT * 6, r2 = 0.1, r1 = BEARING_OUTER_RD + 10, center=true);
            }
    }
    }
}
// !bearing();




TABLE_SZ = 70;
TABLE_HT = 65;
LEG_WD = 10;
TABLE_TN = 2.5;

BEARING_MT_TN = 8;
BEARING_MT_HT = 10;
BEARING_MT_FILLET_RD = 5;
bearing_mt_rd = BEARING_OUTER_RD + BEARING_MT_TN;

SQUARE_SHAFT_SZ = 10;
SQUARE_SHAFT_HT = 25;
SHAFT_CLEARANCE = 0.8;


// !circular_fillet(bearing_mt_rd + 5, bearing_mt_rd, 5);


// table shape for holding the bearing mount
module table(){
    // main table shape
    difference(){
        union(){
            difference(){
                cube([TABLE_SZ, TABLE_SZ, TABLE_HT], center=true);
                translate([0, 0, -TABLE_TN]){
                    cube([TABLE_SZ - (LEG_WD *2), TABLE_SZ * 1.1, TABLE_HT], center=true);
                }
                translate([0, 0, -TABLE_TN]){
                    cube([TABLE_SZ * 1.1, TABLE_SZ - (LEG_WD *2),  TABLE_HT], center=true);
                }
                translate([0, 0, -TABLE_TN]){
                    cube([TABLE_SZ - (TABLE_TN*2), TABLE_SZ - (TABLE_TN*2), TABLE_HT], center=true);
                }
            }
            // bearing mount
            
            translate([0, 0, -TABLE_TN * 2]){
                translate([0, 0, TABLE_HT/2]){
                    difference(){
                        cylinder(h = BEARING_MT_HT, r = bearing_mt_rd, center=true);
                        
                    }
                }
                translate([0, 0, TABLE_HT/2 + BEARING_MT_HT/2-TABLE_TN]){
                    rotate([180, 0, 0]){
                        circular_fillet(bearing_mt_rd + BEARING_MT_FILLET_RD, bearing_mt_rd, BEARING_MT_FILLET_RD);
                    }
                }
            }
            
        }
        // main bearing hole
        translate([0, 0, TABLE_HT/2 - BEARING_MT_HT/2]){
            cylinder(h = BEARING_MT_HT * 1.1, r = BEARING_OUTER_RD, center=true);
        }
        // leg screwholes
        SCREWHOLE_POSIS = [
            [TABLE_SZ/2 - LEG_WD/2, TABLE_SZ/2],
            [TABLE_SZ/2 - LEG_WD/2, -TABLE_SZ/2],
            [-TABLE_SZ/2 + LEG_WD/2, -TABLE_SZ/2],
            [-TABLE_SZ/2 + LEG_WD/2, TABLE_SZ/2],
        ];
        for(sposi = SCREWHOLE_POSIS){
            translate([sposi[0], sposi[1], -TABLE_HT/2 + 8]){
                rotate([90, 0, 0]){
                    cylinder(h = 8, r = 3.1/2, center=true);
                }
            }
            translate([sposi[0], sposi[1], -TABLE_HT/2 + 3]){
                rotate([90, 0, 0]){
                    cylinder(h = 8, r = 3.1/2, center=true);
                }
            }
        }

        // translate([TABLE_SZ/2 - LEG_WD/2, TABLE_SZ/2, -TABLE_HT/2 + 8]){ //-27.6
        //     rotate([90, 0, 0]){
        //         cylinder(h = 8, r = 3.1/2, center=true);
        //     }
        // }
        // translate([TABLE_SZ/2 - LEG_WD/2, TABLE_SZ/2, -TABLE_HT/2 + 3]){ // -32.6
        //     rotate([90, 0, 0]){
        //         cylinder(h = 8, r = 3.1/2, center=true);
        //     }
        // }

    }
    // FOR MODELLING PURPOSES ONLY NOT FOR PRINTING
    // translate([0, 0, 30]){
    //     bearing();
    // }
    
    



    //
}
// Testing the table for bearing fit
// intersection(){
    // !table();
//     #translate([0, 0, 30]){
//         cylinder(h = 5, r = BEARING_OUTER_RD+7, center=true);
//     }
// }


// NOW we want the commutating insert that will contain magnet shaft
// There will be no gears in this design
// The hall sensor will be mounted below the table
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


// GRIPPING SPOOL
module gripping_spool(){
    // V-shaped profile rim to be printed in TPU(maybe) to put around 
    // the hub of the cable commutator

    SPOOL_HT = 10;
    SPOOL_WD = 10;
    GRIP_DP = 5;
    NUMBER_TEETH = 25;
    tooth_angle = 360/NUMBER_TEETH;
    SPOOL_BASE_RD = 30/2;
    
    spool_grip_pts = [
        [0, 0],
        [SPOOL_WD,0],
        [SPOOL_WD-GRIP_DP, SPOOL_HT/2],
        [SPOOL_WD, SPOOL_HT],
        [0, SPOOL_HT],
    ];

    tooth_rd = SPOOL_BASE_RD + (SPOOL_WD - GRIP_DP) - 0.3  ;

    translate([0, 0, -7]){
        rotate_extrude(angle=360){ 
            translate([SPOOL_BASE_RD + 0, -SPOOL_HT/2, 0]){
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
        // fill up any gaps between spool and commutator
        difference(){
            cylinder(h = SPOOL_HT, r = SPOOL_BASE_RD, center=true);
            cylinder(h = SPOOL_HT, r = BEARING_INNER_RD -0.1, center=true);
        }

    }
    
}



// The commutator will be mounted on a shaft that will be adjustable in height
COMMUTATOR_HT = 25;
module commutator_insert() {
    // The insert will be a cylinder with a hole which will
    // contain an m3 brass bush that can be used to adjust the height
    // of the magnet.
    // the insert will need a string pulley arrangement to allow the string from 
    // the sprung reel to spin the commutator

    difference(){
        union(){
            cylinder(h = COMMUTATOR_HT, r = BEARING_INNER_RD, center=true);
            // create connical section to grip bearing
            translate([0, 0, 6]){
                cylinder(h = BEARING_HT, r2 = BEARING_INNER_RD,r1 = BEARING_INNER_RD+CONICAL_OS, center=true);
            }
            translate([0, 0, -0.5]){
                gripping_spool();
            }
        }
        translate([0, 0, -2.5 - 10 ]){ // -2.5 is flush with the top
            cube([SQUARE_SHAFT_SZ + SHAFT_CLEARANCE, SQUARE_SHAFT_SZ + SHAFT_CLEARANCE, 30], center=true);
        }
        translate([0, 0, 0]){
            cylinder(h = 15, r = 4.2/2); // 4.2mm for a std brass bush
        }
        // tapered top to hole for printability
        translate([0, 0, 2.5]){
            hull(){
                translate([0, 0, 5]){
                    cylinder(h = 0.1, r = 4.2/2);
                }
                cube([SQUARE_SHAFT_SZ + SHAFT_CLEARANCE, SQUARE_SHAFT_SZ + SHAFT_CLEARANCE, 0.1], center=true);
            }
        }



        // translate([25, 0, 0]){
        //     cube([50,80 , 40], center=true);
        // }

    }
}
// !commutator_insert();



MAG_HOLE_RD = 3.2/2; // MAG MEASURES 3MM


module square_shaft(){
    color("white",1.0){
        difference(){
            cube([SQUARE_SHAFT_SZ,SQUARE_SHAFT_SZ , SQUARE_SHAFT_HT], center=true);
            // we need a hole to acommodate the brass bush
            // then we need a hole to acommodate the screw travel inside the shaft
            translate([0, 0, 5.6]){
                cylinder(h = 7, r = 4.2/2);
            }
            translate([0, 0, -4.3]){
                cylinder(h = 10, r = 5/2);
            }
            // now we need the claw to hold the magnet
            translate([0, 0, -11]){
                rotate([90, 0, 0]){
                    hull(){
                        cylinder(h = SQUARE_SHAFT_SZ *1.2, r = MAG_HOLE_RD, center=true);
                        translate([0, -MAG_HOLE_RD,0]){
                            cube([MAG_HOLE_RD*2,MAG_HOLE_RD*2 , SQUARE_SHAFT_SZ *1.2], center=true);
                        }
                    }
                }
            }
    
        }
        
    
    }
}


module PCB_stanchion() {
    difference() {
        cylinder(h = 10, r = 7.5/2, center=true);
        #translate([0, 0, 1]){
            cylinder(h = 8.5, r = 2.3/2, center=true);
        }
    }
    translate([0, 0, -5]){
        circular_fillet(13/2, 7.5/2, 4);
    }
}
// !PCB_stanchion();

FOOT_SZ =20;
module table_foot() {
    translate([2, 2, 0]){
        cube([FOOT_SZ, FOOT_SZ,2 ], center=true);
    }
    translate([TABLE_TN/2, TABLE_TN/2, 15]){
        difference(){
            cube([ LEG_WD + TABLE_TN, LEG_WD + TABLE_TN , 30], center=true);
            translate([-TABLE_TN * 0.5, -TABLE_TN * 0.5, 0]){
                cube([ LEG_WD +0.5 , LEG_WD +0.5, 31 ], center=true);
                // screwholes
                translate([0, 8, 0]){
                    rotate([90, 0, 0]){
                        cylinder(h = 5, r = 3.1/2);
                    }
                }
                translate([0, 8, 10]){
                    rotate([90, 0, 0]){
                        cylinder(h = 5, r = 3.1/2);
                    }
                }
                // screwholes at 90 deg
                translate([3, 0, 0]){
                    rotate([0, 90, 0]){
                        cylinder(h = 5, r = 3.1/2);
                    }
                }
                translate([3, 0, 10]){
                    rotate([0, 90, 0]){
                        cylinder(h = 5, r = 3.1/2);
                    }
                }
            }
        }
        // fillet
        translate([0, 8.2, -12.05]){
            straight_fillet(length = LEG_WD + TABLE_TN, width = 4, ht = 4);
        }
        // fillet at 90 deg
        translate([8.2, 0, -12.05]){
            rotate([0, 0, -90]){
                straight_fillet(length = LEG_WD + TABLE_TN, width = 4, ht = 4);
            }
        }
    }
}

//###################################################################################
//## mounting assemblies for the electronics

ELECBASE_HT = 2;
ELECBASE_LN = 40;
ELECBASE_WD = 83;
DISPLAY_AN = -30; 
//display_screwhole_coords = display_screwhole_coords;
PILLAR_RD = 6/2;
pillar_corners = rect(ELECBASE_LN-PILLAR_RD*2,ELECBASE_WD-PILLAR_RD*2);

module display_mount(){
    
    difference(){
        union(){
            difference(){
                // pillars
                for(pc = pillar_corners){
                    translate([pc[0], pc[1], 25]){
                        difference(){
                            cylinder(h = 50, r = PILLAR_RD, center=true);
                            // screwholes in bottom of pillars
                            translate([0, 0, -20.1]){
                                rotate([0, 0, 0]){
                                    cylinder(h = 10, r = 2.8/2, center=true);
                                }
                            }
                        }
                    }
                }
                // chop off the top of the pillars to form diagonal plane for base
                translate([0, 0, 50]){
                    rotate([0, DISPLAY_AN, 0]){
                        translate([-10, 0, 0]){
                            cube([ELECBASE_LN * 1.5, ELECBASE_WD, 30], center=true);
                        }
                    }
                
                }
            }
            // flat base to mount the display
            translate([0, 0, 33.8]){
                rotate([0, DISPLAY_AN, 0]){
                    translate([-1, 0, 0]){
                        difference(){
                            cube([ELECBASE_LN * 1.16, ELECBASE_WD, 2], center=true);
                            cube([36,67, 4], center=true);
                            
                        }
                        // frame reinforcement
                        translate([0, ELECBASE_WD/2 - 3, -2]){
                            cube([ELECBASE_LN, 2, 4], center=true);
                            // pillar buttress
                            translate([ELECBASE_LN/2 - 9, 0, -4.4]){
                                rotate([0, -30, 0]){
                                    rotate([90, 0, 0]){
                                        cylinder(h = 2, r = 5, $fn=3, center=true);
                                    }
                                }
                            }
                            
                        }
                        translate([0, -ELECBASE_WD/2 + 3, -2]){
                            cube([ELECBASE_LN, 2, 4], center=true);
                            // pillar buttress
                            translate([ELECBASE_LN/2 - 9, 0, -4.4]){
                                rotate([0, -30, 0]){
                                    rotate([90, 0, 0]){
                                        cylinder(h = 2, r = 5, $fn=3, center=true);
                                    }
                                }
                            }
                            
                        
                        }

                        translate([ELECBASE_LN/2 + 0, 0, -2]){
                            cube([2, ELECBASE_WD, 4], center=true);
                        }
                        translate([-ELECBASE_LN/2 + 0, 0, -2]){
                            cube([2, ELECBASE_WD, 4], center=true);
                        }



                        // screwhole reinforcements
                        translate([ELECBASE_LN/2 -5, ELECBASE_WD/2 - 3, -3]){
                            cube([5, 5, 5], center=true);
                        }
                        translate([ELECBASE_LN/2 -5, -ELECBASE_WD/2 + 3, -3]){
                            cube([5, 5, 5], center=true);
                        }
                        translate([-ELECBASE_LN/2 +4, ELECBASE_WD/2 - 3, -3]){
                            cube([5, 5, 5], center=true);
                        }
                        translate([-ELECBASE_LN/2 +4, -ELECBASE_WD/2 + 3, -3]){
                            cube([5, 5, 5], center=true);
                        }
                    }
                }
            }
        }
        // display mounting screwholes
        translate([0, 0, 33.8]){
            rotate([0, DISPLAY_AN, 0]){
                translate([-1, 0, 0]){
                    // screwholes
                    rotate([0, 0, 90]){
                        for(this_coord = display_screwhole_coords){
                            translate([this_coord[0], this_coord[1], -6.8]){
                                #cylinder(h = 8, r = 2.5/2);
                            }
                        }
                    }
                }
            }
        }
    }
}



module control_mount() {
    // A mounting assembly for holding the Raspberry Pi Zero and the LCD display
    // The assembly will be connected to the box base
    

    
    
    difference(){
        cube([ELECBASE_LN, ELECBASE_WD, ELECBASE_HT], center=true);
        // remove the screw holes for the pillars using pillar_corners
        for(pc = pillar_corners){
            translate([pc[0], pc[1], -1.5]){
                cylinder(h = 10, r = 3.2/2, center=true);
                translate([0, 0, 0]){
                    cylinder(h = 3, r1 = 6, r2 = 3.2/2, center=true);
                }
            }
        }

    }
    !display_mount();
        
    
    translate([0, 0, 5.9]){
        rotate([0, 0, 90]){
            RPI_Zero_mount();
        }
    }



    // //#############################################################
    // //#### NOT for PRINTING - for modelling purposes only    
    // translate([0, 0, 35.9]){
    //     rotate([0, DISPLAY_AN, 0]){
    //         translate([-2, 0, 0]){
    //             rotate([0, 0, 90]){
    //                 display_model_1602();
    //             }
    //         }
    //     }
    // }

    // // now we put the raspberry pi zero in the mount
    // translate([0, 0, 11.5]){
    //     rotate([0, 0, 180]){
    //         raspberrypi_zero_model();
    //     }
    // }
        

    
}

translate([-110, 0, -5.9]){
    control_mount();
}

// hooks for the control mount
HOOK_TN  =2;
HOOK_WD = 10;
HOOK_HT = 6.5;
HOOK_LN = 7;
HOOK_FOOT_LN = 20;
HOOK_TOP_LN = 4;

translate([-BOX_LN/2 - 13, 0, -3.9]){
    union(){
        cube([HOOK_FOOT_LN, HOOK_WD,HOOK_TN ], center=true);
        translate([HOOK_FOOT_LN/2, 0, HOOK_HT/2 - HOOK_TN/2]){
            cube([HOOK_TN, HOOK_WD, HOOK_HT], center=true);
        }
        translate([HOOK_TOP_LN/2 + HOOK_FOOT_LN/2 - HOOK_TN/2, 0, HOOK_HT]){
            cube([HOOK_TOP_LN, HOOK_WD,HOOK_TN ], center=true);   
        }
        translate([HOOK_FOOT_LN/2 + HOOK_TOP_LN, 0, HOOK_HT - HOOK_LN/2 + HOOK_TN/2]){
            cube([HOOK_TN, HOOK_WD, HOOK_LN], center=true);
        }
    }
}





union(){
    
    
    // for testing magnet claw
    // difference(){
    //     square_shaft();
    //     translate([0, 0, 13]){
    //         cube([15, 15, 40], center=true);
    //     }
    // }
    
    // difference(){
    //     union(){
    //         table();
    //         translate([0, 0, 15]){ 
    //             commutator_insert();
    //         }
    //         // adjustable shaft
    //         translate([0, 0, -10]){ // 5 is the top of the travel -10 is the bottom
    //             square_shaft();
    //         }
    //     }
    
    //     // // for cross section view
    //     // translate([0, 25, 0]){
    //     //     cube([100, 50, 80], center=true);
    //     // }
    // }
    
    
    
    // for a test print
    // !difference(){
    //     intersection(){
    //         commutator_insert();
    //         translate([0, 0, 6]){
    //             cube([80, 80, BEARING_HT * 1.4], center=true);
    //         }
    //     }
    //     #translate([0, 0, 0]){
    //         cylinder(h = BEARING_HT * 1.8, r = BEARING_INNER_RD * 0.9);
    //     }
    // }
    
}





// translate([X, Y, Z]){
//     cogs_etc();
// }

//#################################################################################################
//###         MODEL WHOLE ASSEMBLY
//##################################################################################################3
difference(){
    union(){
        translate([20, 0, 0]){
            rotate([0, 0, 25]){
                union(){
                    translate([0, 0, 37]){
                        union(){
                            table();
                            translate([0, 0, 21]){ 
                                difference(){
                                    commutator_insert();
                                    // translate([0, 25, 0]){
                                    //     cube([50, 50, 50], center=true);
                                    // }
                                }
                            }
                            // adjustable shaft
                            translate([0, 0, 0]){ // 5 is the top of the travel -10 is the bottom
                                square_shaft();
                            }
                        }
                    }
                    
                    translate([ TABLE_SZ/2 - (FOOT_SZ/4), TABLE_SZ/2- (FOOT_SZ/4), -2.6]){
                        table_foot();
                    }
                    translate([ TABLE_SZ/2 - (FOOT_SZ/4), -TABLE_SZ/2+ (FOOT_SZ/4), -2.6]){
                        rotate([0, 0, -90]){
                            table_foot();
                        }
                    }
                    translate([ -TABLE_SZ/2 - (FOOT_SZ/4) + LEG_WD, -TABLE_SZ/2+ (FOOT_SZ/4), -2.6]){
                        rotate([0, 0, 180]){
                            table_foot();
                        }
                    }
                                
            
                    translate([0, 0, 7.4]){
                        hall_PCB_assy();
                    }
                    
                    translate([0, 0, 1.5]){
                        PCB_stanchion();
                    }
                }
            }
        }

        translate([0, 0, 1.4]){
            whole_box();
        }

        translate([SPRUNG_REEL_X+ X, SPRUNG_REEL_Y+Y, 48]){
            sprung_reel();
        }

    }
    // // for cross section view
    // translate([-20, 58, 0]){
    //     cube([80, 40,50 ], center=true);
    // }
}

//encoder_mount();