$fs = 1;
$fa = 6;
envelope = [145, 145, 160];

bottomD = 90;
topD = 35;

module flare(id = bottomD, od = envelope[1], zz = 6) {
    radius = 50;
    hull() {
        translate([0,0,zz]) cylinder(d=id, h=2, center=false);
        for (xx=[-od/2:od:od/2]) {
            for (yy=[-od/2:od:od/2]) {
                translate([
                    xx - sign(xx) * radius,
                    yy - sign(yy) * radius ,
                    45 + zz
                ]) cylinder(r = radius, h=1, center=false);
            }
        }
    }
}

module cup() {
    difference() {
        flare(bottomD, envelope[1]);
        translate([0,0,2]) flare(bottomD - 6, envelope[1] - 2);
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
    2.11,
    1.5,
    1.25,
    0.97,
    0.88,
    0.73,
    0.66,
    0.61,
    0.56,
    0.52,
    0.48,
    0.45,
    0.42,
    0.395,
    0.38,
    0.36
    ];
    for (ii=[0:14]) {
        translate([0,0,zz + ii*10])
            cylinder(d1=rr[ii] * 100 + inflate, d2 = rr[ii+1] * 100 + inflate, h=10, center=false);
    }
}
module bell0(inflate = 0, zz = 60) {
    rr = [
        106,
        76,
        60,
        49,
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
        bell(-11 + inflate);
        translate([0,0,envelope[2] - 48])
            cylinder(r=100, h=48, center=false);

    }
}
module corks() {
    intersection() {
        difference() {
            bell(-1);
            bell(-11);
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
        cone(-8);
        cylinder(r=100, h=2, center=false);
    }
}
*corks();
*difference() {
    *bell();
    bell(-1);
}
%bell(-1);
