use <../OpenSCAD/MCAD/involute_gears.scad>

pi = 3.14159;

TOOTH_CNT = 10;
TEETH__PER_MM = 0.2; // Diametral pitch = 5mm
GEAR_WIDTH = 30; // Circular pitch: 10mm
//	Clearance: Radial distance between top of tooth on one gear to bottom of gap on another.
CLEARANCE = 0.1; // 0.1mm
// gear(TOOTH_CNT, 
//         circular_pitch=GEAR_WIDTH, 
//         diametral_pitch=TEETH__PER_MM,
// 		pressure_angle=28, 
//         clearance = 0.12);


// PITCH_RADIUS =  30;//(TOOTH_CNT / (2 * PI)) * TEETH__PER_MM;
// TOOTH_HT = 5;
// ROOT_RADIUS = PITCH_RADIUS - (GEAR_WIDTH / 2);
// BASE_RADIUS = PITCH_RADIUS - (GEAR_WIDTH / 2) + (CLEARANCE / 2.0);
// OUTER_RADIUS = PITCH_RADIUS + GEAR_WIDTH / 2;
// HALF_THICK_ANGLE = 180 / TOOTH_CNT;



// involute_gear_tooth(
// 					pitch_radius = PITCH_RADIUS,
// 					root_radius = ROOT_RADIUS,
// 					base_radius = BASE_RADIUS,
// 					outer_radius = OUTER_RADIUS,
// 					half_thick_angle = HALF_THICK_ANGLE
// 					);

GEAR_TN = 10;

translate([0, -47, 0]){
    rotate([0, 0, 30]){
        gear (number_of_teeth=6,
                    circular_pitch=700*pi/180,
                    gear_thickness=GEAR_TN,
                    rim_thickness=GEAR_TN,
                    hub_thickness=GEAR_TN,
                    hub_diameter=10,
                    circles=0); 
    }
}

gear (number_of_teeth=18,
            circular_pitch=700*pi/180,
            gear_thickness=GEAR_TN,
            rim_thickness=GEAR_TN,
            hub_thickness=GEAR_TN,
            hub_diameter=10,
            circles=0);

// test_gears();
