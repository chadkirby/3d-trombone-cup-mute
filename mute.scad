use <../BezierScad/BezierScad.scad>
// $fs = 1;
// $fa = 6;
envelope = [165, 145, 165];

bottomD = 70;
topD = 35;

module bezMute() {
rotate_extrude()
{
    BezLine( [
      [bottomD/2, envelope[2] * 0.2],
      [(bottomD - topD) * 0.41, envelope[2] * 0.4],
      [topD/2 - 1, envelope[2]],
    ] , width = [5, 3], showCtls = false );
    BezLine( [
      [1, 6],
      [bottomD/2 * 1, 1],
      [bottomD/2 * 1.15, envelope[2] * 0.15],
      [bottomD/2, envelope[2] * 0.2],
    ] , width = [3, 5], showCtls = true );
    BezLine( [
      [25, 9],
      [envelope[0] * 0.3, 10],
      [envelope[0] * 0.45, 30],
      [envelope[0] * 0.5, 55],
    ] , width = [4, 2], center=true );
}
}
module wedge(d, h, center, arc) {
    hull() {
        cylinder(d=0.1, h=h, center=center);
        rotate([0,0,arc/2]) translate([0, d*2]) cylinder(d=0.1, h=h, center=center);
        rotate([0,0,-arc/2]) translate([0, d*2]) cylinder(d=0.1, h=h, center=center);
        translate([0, d*2]) cylinder(d=0.1, h=h, center=center);
    }
}
module _arcOfCyl(d, h, center=true, arc=90) {
    if (arc > 180) {
        difference() {
            cylinder(d=d, h=h, center=center);
            wedge(d=d, h=h + 1, center=center, arc=360 - arc);
        }
    } else {
        intersection() {
            cylinder(d=d, h=h, center=center);
            wedge(d=d, h=h + 1, center=center, arc=arc);
        }
    }
}

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
            cylinder(d=topD + inflate, h=envelope[2], center=false);
        }
    }
    *corksCone(inflate);
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

if (false) {
    rotate([0,0,45]) rotate([0, 90]) rotate([0,0,30])
    translate([0,-20,-envelope[2]/2 + 7])
    intersection() {
        bezMute();
        _arcOfCyl(d=200, h = 200, arc = 60, center=false);
    }
    %cube(size=[145, 145, 150], center=true);
} else {
    !bezMute();
    %bell(-1);
}
