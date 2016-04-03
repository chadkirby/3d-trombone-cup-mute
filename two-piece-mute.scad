use <mute-top.scad>;
$fs = 1;
$fa = 6;

height = 125;

translate([0,0,height + 0.5]) muteTop();
*muteMid();
muteLower();

//wingTimes()
wing();
segments = 6;
module muteLower() {
    dd = 75 / cos(180/segments);
    difference() {
        hull() {
            rotate([0,0, 0/segments])
            cylinder(d=dd, $fn = segments, h=25, center=false);
            translate([0,0,height - 1])
            cylinder(d=75, h=1, center=false);
        }
        translate([0,0,-0.1])
        cylinder(d=55, h=height + 1, center=false);

        translate([0,0,20])
        rotate_extrude($fn = segments)
        translate([dd/2, 0])
        hull() {
            translate([-1,0])
            circle(d=3, $fn=12);

            translate([5,0])
            circle(d=12, $fn=12);
        }
    }
    insertable(dd = 75, zz = height);
}

module muteBase() {
    difference() {
        cylinder(d1=90, d2=140, h=35, center=false);

        translate([0,0,-0.1])
        cylinder(d1=70, d2=120, h=35.2, center=false);

        wingTimes()
        wingScrews();
    }
}

module muteMid() {
    steps = 8;
    minZ = 35;
    maxZ = height;
    topD = 75;
    botD = 140;
    exp = 1.3;
    curvedCyl(
        steps = steps,
        minZ = minZ,
        maxZ = maxZ,
        topD = topD,
        botD = botD,
        exp = exp
    );
    insertable(dd = topD, zz = height);
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
module curvedCyl(steps, minZ, maxZ, topD, botD, exp = 1) {
    maxZ = maxZ;
    rangeZ = maxZ - minZ;
    rangeD = botD - topD;
    for (step=[ 0 : 1/steps : 1 - 1/steps]) {
        d2 = topD + rangeD * pow(step, exp);
        d1 = topD + rangeD * pow(step + 1/steps, exp);

        translate([0, 0, maxZ - step * rangeZ - rangeZ/steps])
        difference() {
            cylinder(d1=d1, d2=d2, h=rangeZ/steps, center=false);

            translate([0,0,-0.1])
            cylinder(d1=d1 - 20, d2=d2 - 20, h=rangeZ/steps + 0.2, center=false);
        }
    }
}

*rotate([0,0,90-72])
wingTimes() wing();

module topInsert() {
    difference() {
        insert();
        topCutout();
    }
}

module wing() {
    r1 = 90/2 + 10.5;
    r2 = 140/2 + 6;
    offset = 130;
    arc = 360/segments - 1;
    rotate([0,0,-90 + arc/2])
    difference() {
        union() {
            difference() {
                _arcOfCyl(d1=r1 * 2, d2=r2 * 2, h=35, arc = arc);
                cylinder(r1=r1 - 10, r2=r2 - 10, h=35);
            }

            intersection() {
                curvedCyl(
                    steps = 8,
                    minZ = 35,
                    maxZ = 75,
                    botD = (r2 * 2),
                    topD = (r2 * 2) + 100,
                    exp = 0.77
                );
                wedge(d=1000, h=100, center=false, arc=arc);
            }
        }

        hull() {
            translate([0,0,0.5])
            muteMid();

            muteBase();
        }


        wingScrews();
    }
}

module wingScrews() {
    rotate([0,0,72])
    for (aa=[0 : 72/2 : 72/2]) {
        rotate([0, 0, aa])
        translate([61, 0, 15])

        rotate([0, 180 + atan((25)/(100/2))])
        m4Screw(thru = 4);
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
