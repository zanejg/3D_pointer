// Piece of plastic to grab hold of the T-shaped metal bit that is 
// attached to the sprung reel for the actual cable to attach to.

$fn=60;

RING_HT = 16;


difference(){
    cylinder(h = RING_HT, r = 48/2, center = true);
    cylinder(h = RING_HT + 0.5, r = 45/2, center = true);

    translate([0, -10, 0]){
        cube([50, 50,20 ], center=true);
    }
    // #translate([18, 18, 0]){
    //     cube([15,10 , 10], center=true);
    // }

    translate([-18, 15, 0]){
        cube([30, 30,20 ], center=true);
    }
}



difference(){
    translate([17.8, 16.5, 0]){
        cube([2,3 ,RING_HT ], center=true);
        translate([-0.4, 1.8, 0]){
            rotate([0, 0, 30]){
                cube([2,2 ,RING_HT ], center=true);
            }
        }
    }
    translate([14, 18, 0]){
        cube([15,10 , 10], center=true);
    }
}


translate([-6.5, 0.5, 0]){
    rotate([0, 0, -10]){
        translate([0, 23, 0]){
            difference(){
                rotate([0, 45, 0]){
                    difference(){
                        cube([RING_HT * 1/sqrt(2), 1.5,RING_HT * 1/sqrt(2) ], center=true);
                        cube([RING_HT * 1/sqrt(2)-4, 1.6,RING_HT * 1/sqrt(2) -4], center=true);
                    }
                }
                translate([8,0,0]){
                    cube([RING_HT,2 ,RING_HT ], center=true);
                }
            }
        }
    }
    
}