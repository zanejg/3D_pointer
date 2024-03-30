$fn=60;

REEL_HT = 21.5;
RIM_HT = 1.0;

module sprung_reel(){
    
    difference(){
        union(){
            cylinder(h = REEL_HT, r = 44.5/2, center = true);
            
            translate([0, 0, REEL_HT/2 - RIM_HT/2]){
                cylinder(h = 1.0, r = 55/2, center = true);
            }
            
            translate([0, 0, -REEL_HT/2 + RIM_HT/2]){
                cylinder(h = 1.0, r = 55/2, center = true);
            }
        }
        translate([0, 0, -REEL_HT/1.9]){
            cylinder(h = REEL_HT + 1.1, r = 9.2/2);
        }
    }
    
}