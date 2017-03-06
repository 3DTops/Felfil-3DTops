//Constants

$fn = 50;
r= 5;

x = 69.85;
y = 119;
z = 150+70; //LCD PCB width plus motor approx.

wall = 2;

x_c1 = 42;
z_c1 = 4+wall;
r_c1 = 4;

r_c2 = 37/2;
z_c2 = 61;

r_hole = 15/2;

x_a = (x-2*r)/2;
y_a = (y-2*r)/2;

y_base = 8;
x_base = 2*x_a;
z_base = z-2*r_hole;

tor_x = [-x_a,+x_a];

tor_y = [-y_a,-y_a+2*x_a,y_a];
//tor_y = [-y_a,0,y_a];

//LCD

r_knob = 4;
dx_knob = 133 + r_knob;
dy_knob = 21 + r_knob;

x_LCD = 98;
y_LCD = 42;

dx_LCD = 14.5;
dy_LCD = 2;

x_PCB = 150;
y_PCB = 55;

x_PCB2 = 100;
y_PCB2 = 60;

dx_PCB2 = 13.5;
dy_PCB2 = -9;


r_PCBScrew = 3/2;
dr_screw = 1+r_PCBScrew;

x_PCBScrew = [dr_screw,x_PCB-dr_screw] ;
y_PCBScrew = [dr_screw,y_PCB-dr_screw] ;

x_SD = 28.5;
y_SD = 45;
z_SD = 4;

dx_SD = 96;
dy_SD = 26;
dz_SD = x/2-z_SD-wall-7;

h = 50;

x_button = 22;
z_button = 29;

x_connector = 50;
r_connector = 6;

//Ventilation

y_vent = y/4;
x_vent = z-x;

r_fan = 50/2;
r_fanScrew = 2;
x_fanScrew = 40;

//Modules

module pillars(h,r){
	for (i = tor_x){
		for (j = tor_y){
			translate([i,j,0])
				cylinder(r=r,h=h);
		}}
}

module vent(x,y,r,w,h){
	l = 2*r+w;

	n = round(x/l);
	p = round(y/l);
	
	translate([-(n-1)*l/2,-(p-1)*l*cos(30)/2,-h/2])
	union(){
	for (j = [0:p-1]){
		for (i = [0:n-1]){
			translate([l*(i+(j%2)*sin(30)),l*j*cos(30),0])
			cylinder(r=r,h=h);
	}}}

}

module base(r,w){
	rn = r-w;
	translate([0,-y/2+2*w,z/2])
	rotate([90,0,0])
	hull(){
		for (i = [-1,1]){
		for (j = [-1,1]){
			translate([i*(-r+x_base/2),j*(-r+z/2),0])
			cylinder(r=rn,h=y_base+w);
	}}}
}


//Structure

difference(){

union(){
difference(){
hull(){
	pillars(z,r);
}
translate([0,0,wall])hull(){
	pillars(z*2,r-wall);
}}

base(r,0);

translate([0,0,z])pillars(10,5/2);
pillars(z,r);
}

translate([0,y/2-r_c2,wall]){
	translate([0,0,z-z_c2])
	cylinder(r=r_c2,h=z_c2);
	//translate([0,0,-5])cylinder(r=r_hole,h=10);
	translate([0,r_c2-r_c1,z-z_c1])
	hull(){
		for (k = [-.5,.5]){
		for (j = [0,-x_c1]){
			translate([k*x_c1,j,0])cylinder(r=r_c1,h=z_c1);
		}}
	}
}

/*
translate([0,-y/2+10,z])
rotate([90,0,0])
cylinder(r=r_hole,h=20);
*/

//}


translate([0,0,2*wall])
rotate([0,-90,0])
union(){
	for (i = x_PCBScrew){
	for (j = y_PCBScrew){
		translate([i,j,0])
		cylinder(r=r_PCBScrew,h=h);
	}}
	translate([dx_LCD,dy_LCD,0])
	cube([x_LCD,y_LCD,h]);
	translate([dx_knob,dy_knob,0])
	cylinder(r=r_knob,h=h);

	cube([x_PCB,y_PCB,x/2-wall]);
	translate([dx_PCB2,dy_PCB2,0])
	cube([x_PCB2,y_PCB2,x/2-wall]);

	translate([dx_SD,dy_SD,dz_SD])
	cube([x_SD,y_SD,z_SD]);
}

translate([0,-y/4,z/2])
rotate([0,90,0])
vent(x_vent,y_vent,3,3,2*x);

for (i = [-1,1]){
	translate([0,i*r_fan,-wall])
	union(){
	cylinder(r=r_fan-1,h=3*wall);
	for (j = [-1,1]){
	for (k = [-1,1]){
		translate([j*x_fanScrew/2,k*x_fanScrew/2,0])
		cylinder(r=r_fanScrew,h=3*wall);

}}
}
}

translate([-x_button/2,y/2-2*wall,z/4-z_button/2])
cube([x_button,3*wall,z_button]);


translate([0,y/4-r_connector,(x_connector+z/2)/2])
rotate([0,90,0])
hull(){
translate([x_connector,0,0])cylinder(r=r_connector,h=h);
cylinder(r=r_connector,h=h);
}

base(r,wall);

translate([-x_base/4,-(y/2+y_base/2+wall),-5])
cube([x_base/2,y_base/2+wall,z+10]);

}
