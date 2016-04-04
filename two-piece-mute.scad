use <mute-top.scad>;
$fs = 1;
$fa = 6;

height = 112.5;
segments = 6;
function inDiameter(d) = d  / cos(180/segments);
function sideLength(d) = d * sin(180/segments);

*translate([0,0,height + 0.5]) muteTop();
muteLower();

//wingTimes()
wing($fn = segments);

module wingTimes() {
    arc = 360 / segments;
    for (angle=[0 : arc : arc * (segments - 1)]) rotate([0,0,angle]) children();
}

module muteBase(inflate = 0) {
    dd = 100;
    rotSeg()
    cylinder(d=inDiameter(dd + inflate), $fn = segments, h=15, center=false);;
}
module rotSeg() {
    rotate([0,0, 0/segments])
    children();
}
module muteLower() {
    dd = 100;
    difference() {
        union() {
            muteBase();
            rotSeg()
            hull() {
                translate([0,0,15])
                cylinder(d=inDiameter(dd - 5), $fn = segments, h=1, center=false);

                translate([0,0,height - 1])
                cylinder(d=75, h=1, center=false);
            }
        }
        translate([0,0,-0.1])
        hull() {
            cylinder(d=inDiameter(85), $fn = segments, h=15, center=false);

            translate([0,0,height])
            cylinder(d=55, h=0.2, center=false);

        }
        wingTimes() wingScrew();
    }
    insertable(dd = 75, zz = height);

    difference() {
        hull() {
            muteBase();

            translate([0,0,45])
            cylinder(d=10, h=0.1, center=false);

        }
        cylinder(d=inDiameter(80), $fn = segments, h=12, center=false);

        translate([0,0,12])
        cylinder(d1=inDiameter(80), d2=inDiameter(3), $fn = segments, h=32, center=false);
        wingTimes() wingScrew();
    }

}

module insertable(dd, zz = height) {
    translate([0,0,zz])
    difference() {
        insert();
        cylinder(d=dd - 20, h=100, center=true);

        translate([0,0,0.5])
        topScrews();
    }
}
module curvedCyl(steps, height, topD, botD, exp = 1) {
    minZ = 0;
    maxZ = height;
    rangeZ = maxZ - minZ;
    rangeD = botD - topD;
    for (step=[ 0 : 1/steps : 1 - 1/steps]) {
        p2 = pow(step, exp);
        p1 = pow(step + 1/steps, exp);
        d1 = topD + rangeD * p1;
        d2 = topD + rangeD * p2;

        translate([0, 0, maxZ - step * rangeZ - rangeZ/steps])
        cylinder(d1=d1, d2=d2, h=rangeZ/steps, center=false);
    }
}

module topInsert() {
    difference() {
        insert();
        topCutout();
    }
}

module foldWing() {
    dd = 100 - 5;
    translate([0, dd/2 + 0.5, 15])
    rotate([38,0])
    translate([0, -dd/2, -15])
    children();
}

module wing() {
    dd = 100 - 5;

    //foldWing()
    intersection() {
        upperWing();
        // wedge(d=1000, h=1000, center=false, arc=arc);
        union() {
            translate([0, 500])
            cube(size=[sideLength(inDiameter(dd)), 1000, 1000], center=true);
        }
    }
}

module upperWing() {
    dd = 100 - 5;
    r1 = inDiameter(dd)/2 + 10.5;
    r2 = 225/2 + 5;
    offset = 130;
    arc = 360/segments - 1;
    difference() {
        union() {
            translate([0, 0, 15])
            curvedCyl(
                steps = 8,
                height = 60,
                botD = (r1 * 2),
                topD = (r2 * 2),
                exp = 0.7
            );

            difference() {
                union() {
                    cylinder(d = inDiameter(dd + 25), h=5, center=false);
                    cylinder(d = inDiameter(dd + 18), h=15, center=false);
                }
                muteBase();
            }
        }
        translate([0, 0, 15])
        curvedCyl(
            steps = 8,
            height = 60.1,
            botD = ((r1 * 2) - 20),
            topD = ((r2 * 2) - 10),
            exp = 0.7,
            $fn = segments
        );
        rotate([0,0,360/segments])
        wingScrew();
    }
}

module wingScrew() {
    $fn = 12;
    rotate([0,0,180/segments])
    for (xx=[-15 : 15 * 2 : 15]) {
        translate([54, xx, 8])

        rotate([0, 180])
        m4Screw(thru = 4, head = 10);
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
module _arcOfCyl(d, d1, d2, r, r1, r2, h, center=true, arc=90) {
    translate([0,0,h/2])
    if (arc > 180) {
        difference() {
            cylinder(d=d, d1=d1, d2=d2, r=r, r1=r1, r2=r2, h=h, center=center);
            wedge(d=(d2 ? d2 : r2 * 2), h=h + 1, center=center, arc=360 - arc);
        }
    } else {
        intersection() {
            cylinder(d=d, d1=d1, d2=d2, h=h, center=center);
            wedge(d=(d2 ? d2 : r2 * 2), h=h + 1, center=center, arc=arc);
        }
    }
}
