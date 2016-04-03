$fs = 1;
$fa = 6;
height = 140;
topOD = 40;
topID = topOD - 5;
botOD = 75;
botID = botOD - 20;
run = (botOD - topOD);
slope = run/height;

module _ry(ii = 1) {
    rotate([ii * 90,0]) children();
}
module _rx(ii = 1) {
    rotate([0,ii * 90]) children();
}

module muteTop() {
    difference() {
        cylinder(d1=botOD, d2=topOD, h=height, center=false);
        topCutout();
        insert(0.5);
        corks();
        topScrews();
    }
}

module topCutout() {
    cylinder(d1=botID, d2=topID, h=height + 0.1, center=false);
}

module insert(inflate = 0) {
    hh = 11 + inflate;
    d1 = inflate + (botOD + botID)/2;
    d2 = inflate + botID - slope * 5;
    cylinder(d=d1, h=hh, center=false);
    translate([0,0,hh]) cylinder(d1=d1, d2=d2, h=(d1-d2)/2, center=false);
}

module wingTimes() {
    for (angle=[0:72:72*4]) rotate([0,0,angle]) children();
}

module topScrews() {
    wingTimes()
    translate([-botOD/2 + 3.5, 0, 5.5])
    rotate([0, 90 - atan(height/(run/2))])
    m4Screw(thru = 1.5);
}
module m4Screw(thru = 4) {
    _rx() {
        // screw head
        translate([0,0,-4]) cylinder(d=10, h=4, center=false);
        // through
        cylinder(d=5.5, h=thru, center=false);
        // thread
        cylinder(d=4, h=20, center=false);
    }
}

module corks() {
    voffset = 5;
    hoffset = voffset * slope/2;
    for (angle=[0:120:240]) {
        rotate([0,0,angle])
        translate([0, 3 + topOD/2 + hoffset, height - voffset])
        rotate([ 90-atan(height/(run/2)), 0, 0])
        _ry()
        hull() {
            translate([0,-5]) cylinder(d=10, h=4, center=false);
            translate([0,-60]) cylinder(d=10, h=4, center=false);
        }
    }

}
muteTop();
