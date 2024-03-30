$fn = 60;
DISPLAY_PCB_WD = 80;
DISPLAY_PCB_HT = 36;
DISPLAY_PCB_TN = 1;
DISPLAY_TN = 7.5;
DISPLAY_WD = 71;
DISPLAY_HT = 24;
SCREWHOLE_RD = 3/2;


// screwholes
screwhole_inset = (SCREWHOLE_RD + 0.3);
display_screwhole_coords = [
    [-DISPLAY_PCB_WD/2 + screwhole_inset, DISPLAY_PCB_HT/2 - screwhole_inset],
    [DISPLAY_PCB_WD/2 - screwhole_inset, DISPLAY_PCB_HT/2 - screwhole_inset],
    [DISPLAY_PCB_WD/2 - screwhole_inset, -DISPLAY_PCB_HT/2 + screwhole_inset],
    [-DISPLAY_PCB_WD/2 + screwhole_inset, -DISPLAY_PCB_HT/2 + screwhole_inset]
];

module display_model_1602(){
    // Main PCB
    difference(){
        cube([DISPLAY_PCB_WD,DISPLAY_PCB_HT,DISPLAY_PCB_TN],center=true);
        
        for (xy =display_screwhole_coords){
            translate([xy[0],xy[1],-1]){
                cylinder(h = 3, r = SCREWHOLE_RD);
            } 
        }
    }

    // LCD Display Unit

    translate([-0.5,-1,DISPLAY_TN/2 + 0.5]){ 
        difference() {
            cube([DISPLAY_WD, DISPLAY_HT, DISPLAY_TN],center=true);

            translate([0,0,4]){
                cube([64,15,1.5], center=true);
            }
        } 
    }


    // control bus pins
    PIN_LN = 11;
    translate([-(DISPLAY_PCB_WD/2 - 8 ),
                DISPLAY_PCB_HT/2 - 2,
                -(PIN_LN -2)]){ 
        PIN_DIST = 2.5;
        for(pinx = [0:PIN_DIST:(PIN_DIST * 15)]){
            translate([pinx,0,0]){
                cube([0.5,0.5,PIN_LN]);
            } 
        }
    }

    // Backlight LED outcrop


    translate([DISPLAY_WD / 2 + 0.7,
                0,
                1.5]){
        difference() {
            Y_OS = 5.5;
            cube([3.5,13,2],center=true);
            translate([1.5, Y_OS, 0]){
                rotate([0,0,40]){
                    cube([4,7,3], center=true);
                } 
            }
            translate([1.5, -Y_OS, 0]){
                rotate([0,0,-40]){
                    cube([4,7,3], center=true);
                } 
            } 
        }
    }


    // ########################################
    // ## Control PCB Assy
    CDISPLAY_PCB_WD = 41;
    CDISPLAY_PCB_HT = 18;
    CDISPLAY_PCB_TN = 1;
    translate([-(DISPLAY_PCB_WD/2-CDISPLAY_PCB_WD/2 - 6.5),
            (DISPLAY_PCB_HT/2-CDISPLAY_PCB_HT/2),
            -7]){

        
        // PCB
        cube([CDISPLAY_PCB_WD,CDISPLAY_PCB_HT,CDISPLAY_PCB_TN], center=true);
        // I2C PCB mount
        translate([-CDISPLAY_PCB_WD/2 + 1,0,-2.5]){ 
            cube([1.8,10,4.5],center=true);
        }
        // I2C connector
        translate([-CDISPLAY_PCB_WD/2 -7,0,-4]){ 
            cube([16,10,2],center=true);
        }

        // Jumper PCB mount
        translate([CDISPLAY_PCB_WD/2 - 1,0,-2.5]){ 
            cube([1.8,4.5,4.5],center=true);
        }
        // Jumper connector
        translate([CDISPLAY_PCB_WD/2 + 3,0,-4]){ 
            cube([7,4.5,2],center=true);
        }
        // PCB printed support
        translate([0,-CDISPLAY_PCB_HT/2,1.5]){ 
            cube([40,5,10],center=true);
        }

        // pot
        translate([-CDISPLAY_PCB_WD/2 + 3.1 +4.5 ,0,-2]){
            cube([6.2, 6.2, 4], center=true);
        }

    } 
}

//display_model_1602();




