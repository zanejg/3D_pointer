$fn = 60;
include <strip_connector_male.scad>

CNR_RD = 3;
PCB_TN = 1.3;
PCB_WD = 30;
PCB_LN = 65;
SCREWHOLE_RD = 3/2;
SCREWHOLE_OS = 3.5;


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

//##############################################################################
// Side connectors
module connector(upper_connector_wd,
                lower_connector_wd,
                connector_rd,
                connector_ht,
                connector_dp){
    upper_cyl_wd = upper_connector_wd - connector_rd*2;
    lower_cyl_wd = lower_connector_wd - connector_rd*2;
    cyl_vert_os = connector_ht/2 - connector_rd*2;
    
    hull(){
        translate([cyl_vert_os, upper_cyl_wd/2, 0]){
            cylinder(h = connector_dp, r = connector_rd, center = true);
        }
        translate([cyl_vert_os,-upper_cyl_wd/2,0]){
            cylinder(h = connector_dp, r = connector_rd, center = true);
        }
        
        translate([-cyl_vert_os, lower_cyl_wd/2, 0]){
            cylinder(h =connector_dp, r = connector_rd, center = true);
        }
        translate([-cyl_vert_os,-lower_cyl_wd/2,0]){
            cylinder(h = connector_dp, r = connector_rd, center = true);
        }
        
    }
}



module raspberrypi_zero_model(gpio_reversed = false){
    
    
    
    //##############################################################################
    // PCB
    PCB_rect = rect(PCB_WD - CNR_RD*2, PCB_LN - CNR_RD*2);
    difference(){
        // PCB body
        hull(){
            for(i = [0:3])
                translate([PCB_rect[i][0],PCB_rect[i][1],0])
                    cylinder(h= PCB_TN, r=CNR_RD, center=true);
        
        }
    
        // screwholes
        for(i = [0:3]){
            translate([(PCB_rect[i][0] + (CNR_RD * RECT_MATRIX[i][0])) - (SCREWHOLE_OS * RECT_MATRIX[i][0]),
                        (PCB_rect[i][1]  + (CNR_RD* RECT_MATRIX[i][1]))- (SCREWHOLE_OS * RECT_MATRIX[i][1]),
                        0]){
                cylinder(h= PCB_TN * 1.5, r=SCREWHOLE_RD, center=true);
            }
        }
    }
    
    
    // HDMI
    upper_hdmi_wd = 11.5;
    lower_hdmi_wd = 9.5;
    hdmi_rd = 1.2;
    hdmi_ht = 3.7;
    hdmi_dp = 8;
    translate([PCB_WD/2 -  hdmi_dp/2 + 0.7, -(PCB_LN/2 - 13.5), hdmi_ht - 1.5]){
        rotate([0, 90, 0]){
            connector(upper_hdmi_wd,lower_hdmi_wd,hdmi_rd,hdmi_ht,hdmi_dp);
        }
    }
    // two USB connectors
    upper_usb_wd = 7.5;
    lower_usb_wd = 6;
    usb_rd = 0.8;
    usb_ht = 2.8;
    usb_dp = 5.7;
    
    translate([PCB_WD/2 -  usb_dp/2 + 1.4, (PCB_LN/2 - 11), usb_ht - 1.5]){
        rotate([0, 90, 0]){
            connector(upper_usb_wd,lower_usb_wd,usb_rd,usb_ht,usb_dp);
        }
    }
    translate([PCB_WD/2 -  usb_dp/2 + 1.4, (PCB_LN/2 - 23.5), usb_ht - 1.5]){
        rotate([0, 90, 0]){
            connector(upper_usb_wd,lower_usb_wd,usb_rd,usb_ht,usb_dp);
        }
    }
    
    //##############################################################################
    // camera connector
    translate([0, PCB_LN/2 - (4.4/2 - 0.9), PCB_TN/2 + 0.6]){
        cube([17, 4.4, 1.2], center=true);
    }
    
    //##############################################################################
    // SD card and holder
    trd =30;
    translate([0, -PCB_LN/2 + 8 - 2.2, PCB_TN/2 + 0.7]){
        cube([12, 16, 1.6], center=true);
    
        translate([0, -7, 0.8]){
            intersection(){
                translate([0, -trd + 0.8 , 0]){
                    cylinder(h = 0.5, r = trd , center = true, $fn = 200);
                }
                cube([12, 1.7, 1.6], center=true);
            }
        }
    }
    
    //##############################################################################
    // CPU
    translate([0, -5, 0.8]){
        cube([15, 15, 1.5], center=true);
    }
    // radio module 27.5
    translate([0, (PCB_LN/2 - (27.5-6)), 0.8]){
        cube([12, 12, 1.5], center=true);
    }
    
    
    // ##############################################################################
    // GPIO
    if(gpio_reversed){
        translate([-PCB_WD/2 + 4.5, -PCB_LN/2 +9, 0]){
            rotate([0, 180, 0]){
                matrix_male_connector(2,20);
            }
        }
    }else{
        translate([-PCB_WD/2 + 2, -PCB_LN/2 +9, 0.6]){
            matrix_male_connector(2,20);
        }
    }
}


