use <../OpenSCAD/MCAD/involute_gears.scad>
$fn=40;
pi = 3.14159;
GEAR_TN = 10;

//the encoder hole
module encoder_hole(len){
    HOLE_RD = 6.3/2; //encoder hole radius HARD WON DATA!
    NOTCH_OS = 1.2; //notch offset

    
    translate([0, 0, -0.5]){
        intersection() {
            cylinder(h = len, r = HOLE_RD);

            translate([0, NOTCH_OS, len/2]){
                cube([HOLE_RD*2,HOLE_RD*2,len], center = true);
            }
        }
    }
}


module encoder_gear(){
    
    difference(){
        gear (number_of_teeth=6,
                circular_pitch=700*pi/180,
                gear_thickness=GEAR_TN,
                rim_thickness=GEAR_TN,
                hub_thickness=GEAR_TN,
                hub_diameter=10,
                circles=0); 
        encoder_hole(GEAR_TN*1.2);
        
        
    }
}

encoder_gear();