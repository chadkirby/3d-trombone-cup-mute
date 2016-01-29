$fs = 1;
$fa = 6;
envelope = [5.9 * 25.4, 5.9 * 25.4, 5.9 * 25.4];

bottomD = 90;
topD = 35;

module flare(inflate = 0, zz = 6) {
    radius = 50;
    hull() {
        translate([0,0,zz]) cylinder(d=bottomD, h=2, center=false);
        for (xx=[-(envelope[0] + inflate)/2:(envelope[0] + inflate):(envelope[0] + inflate)/2]) {
            for (yy=[-(envelope[1] + inflate)/2:(envelope[1] + inflate):(envelope[1] + inflate)/2]) {
                translate([
                    xx - sign(xx) * radius,
                    yy - sign(yy) * radius ,
                    45 - inflate/2 + zz
                ]) cylinder(r = radius, h=1, center=false);
            }
        }
    }
}

module cup() {
    difference() {
        flare();
        translate([0,0,2]) flare(-4);
    }
}

module cone(inflate = 0) {
    hull() {
        cylinder(d=bottomD + inflate, h=6, center=false);
        intersection() {
            cylinder(d=bottomD + inflate, h=envelope[2] - 47, center=false);
            corksCone(inflate);
        }
    }
    corksCone(inflate);
    *cylinder(d1=bottomD + inflate, d2=topD + inflate, h=envelope[2], center=false);
}

module bell(inflate = 0, zz = 60) {
    rr = [
        106,
        76,
        60,
        49.5,
        42,
        37,
        33,
        30,
        27,
        25,
        23,
        21
    ];
    for (ii=[0:10]) {
        translate([0,0,zz + ii*10])
            cylinder(r1=rr[ii] + inflate/2, r2 = rr[ii+1] + inflate/2, h=10, center=false);
    }

}
module corksCone(inflate = 0) {
    intersection() {
        bell(-14 + inflate);
        translate([0,0,envelope[2] - 48])
            cylinder(r=100, h=48, center=false);

    }
}
module corks() {
    intersection() {
        difference() {
            bell(-2);
            bell(-14);
        }
        translate([0,0,envelope[2] - 24]) {
            for (angle=[0:120:240]) {
                rotate([0,0,angle]) translate([0,50]) cube(size=[11, 100, 48], center=true);
            }

        }

    }
}
difference() {
    union() {
        cup();
        cone();
    }
    difference() {
        cone(-4);
        cylinder(r=100, h=2, center=false);
    }
}
*corks();
%difference() {
    *bell();
    bell(-2);
}
