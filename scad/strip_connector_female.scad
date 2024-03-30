sq_size = 2.5;
plastic_height=8.4;
size_mod = 0.05; // to ensure the shapes actually overlap not 
                // exactly touch

module one_connector(){
    translate([0,0,3.3]){
        difference(){
            linear_extrude(height=plastic_height){
                square(sq_size+size_mod,center=true);
            }
            translate([0,0,1]){
                linear_extrude(height=plastic_height+1){
                    square(0.9,center=true);
                }
            }
            translate([0,0,plastic_height-0.5]){
                linear_extrude(height=0.6,scale=1.5){
                    square(1.0,center=true);
                }
            }
        }
    }
    linear_extrude(height=3.4){
        square([0.7,0.3],center=true);
    }
}

//one_connector();

module multi_female_connector(conn_count){
    for (cc=[0 : conn_count-1] ){
        translate([((cc*sq_size)),0,0]){
            one_connector();
        }
    }

}

multi_female_connector(5);
