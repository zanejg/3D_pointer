// Piece of plastic to grab hold of the T-shaped metal bit that is 
// attached to the sprung reel for the actual cable to attach to.

$fn=60;




difference(){
    
    cube([17, 20, 8], center=true);
        
    cavity();
    // remove this

    // translate([25, 0, 0]){
    //     cube([50, 50, 50], center=true);
    // }
}

translate([0, 14, 0]){
    difference(){
        cube([17, 8, 5], center=true);
        cylinder(h = 6, r = 2, center=true);
    }
}




module cavity(){
    // main slope
    difference(){
        union(){
            translate([0, -4, 0]){
                rotate([12, 0, 0]){
                    difference(){
                        cube([14.5, 15, 1.5], center=true);
                        //cube([8, 14, 3], center=true);
                    }
                }
            }
            // middle cavity
            cube([8, 14, 3], center=true);
            
            // 2 wing catches
            translate([4.7, 4.5, 0.5]){
                cube([5, 3, 4], center=true);
            }
            translate([-4.7, 4.5, 0.5]){
                cube([5, 3, 4], center=true);
            }
        }
        // middle center pushing area
        translate([0, 0, 2]){
            cube([4, 15, 3], center=true);
        }
    }
    // // make top of middle cavity printable
    // translate([0, -7.1, 0]){
    //     rotate([45, 0, 0]){
    //         cube([8, 2.3, 2], center=true);
    //     }
    // }
}
