/*
    Sliding Puzzle Generator
    ------------------------

    by Christian Leroch
    www.Leroch.net
    
    License: Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
    https://creativecommons.org/licenses/by-nc/4.0/

    You may remix, adapt, and build upon this work non-commercially, as long as you credit the original creator.
    
*/
// preview[view:south, tilt:top]

/* [Sliding Puzzle] */

//Tolerance between the pieces (mm)
tolerance = 0.3; //[0.05:0.01:2]

//Size of the entire puzzle (mm)
size = 70; //[30:1:500]

//Number of pieces
number = 3; //[2,3,4,5,6]

//Depth of the text (mm)
depth = 0.2; //[0.01:0.01:1]

/* [Option] */

//Text on the back
custom = false;
text = "CUSTOM:)";

//of the numbers
font = "Arial:style=Bold"; //["Liberation Sans", "Liberation Sans:style=Bold", "Liberation Sans:style=Italic", "Liberation Mono", "Liberation Serif", "Arial:style=Bold"]

/* [Hidden] */

// Derived

tile_size   = (size - size/5) / number;
spacing     = tile_size + tolerance;
rail_size   = tile_size * 0.125;
height      = tile_size * 0.375;
text_size   = tile_size / 1.6;

function reverse(list, n) =
    [ for (seg = [0 : n : len(list)-1])
        for (i = [min(seg+n-1, len(list)-1) : -1 : seg])
            list[i]
    ];

texts = [
    ["1","3","2"],
    ["8","4","2","3","6","5","7","1"],
    ["3","7","2","10","1","15","14","5","4","13","9","6","12","8","11"],
    ["5","4","2","12","6","14","3","11","17","13","15","9","10","18","7","8","20","23","1","22","24","19","21","16"],
    ["6","10","4","20","11","13","23","12","3","17","7","2","35","18","21","27","16","8","22","5","15","14","9","19","29","24","28","33","1","32","30","34","31","26","25"]
];

text_array = [ for (i = [0 : len(text)-1]) text[i] ];
text_r     = reverse(text_array, number);

frame();

for (x = [-(number-1)/2 : (number-1)/2]) {
    for (y = [-(number-1)/2 : (number-1)/2]) {
        if (x + y < (number-1)) {
            idx = (y + (number-1)/2)*number + (x + (number-1)/2);
            segment(str(idx+1), x, y, idx);
        }
    }
}

module segment(sn, x, y, idx) {
    translate([x*spacing, -y*spacing, 0])
        difference() {
            union() {
                segmentbase();
                rotate([180,0,270])
                    translate([-tile_size/2, size/(100*number), 0])
                    scale([1,0.7,1])
                        segmentrail();
                rotate([180,0,180])
                    translate([ tile_size/2, size/(100*number), 0])
                    scale([1,0.7,1])
                        segmentrail();
                segmentrailcorner(1,1,1);
                rotate([0,0,90])
                    translate([ tile_size/2.6 - tile_size*0.35 + size/(100*number), 0, 0])
                        segmentrailcorner(1.75/number,1,1);
                rotate([0,0,270])
                    translate([0, -tile_size/2.6 + tile_size*0.35 - size/(100*number), 0])
                        segmentrailcorner(1,1.75/number,1);
            }
            translate([tile_size/2, 0, 0])
                scale([1,1.2,1])
                segmentrail();
            rotate([0,0,270])
                translate([tile_size/2, 0, 0])
                scale([1,1.2,1])
                    segmentrail();
            number(sn);
            rotate([0,180,0])
                number(get_text(idx));
        }
}

module number(n) {
    translate([0,0,height/2 - depth])
        linear_extrude(height = depth+0.01)
            text(n, size = text_size, font = font, halign = "center", valign = "center", $fn=16);
}

function get_text(idx) =
    custom ? text_r[idx] :
    number == 2 ? texts[0][idx] :
    number == 3 ? texts[1][idx] :
    number == 4 ? texts[2][idx] :
    number == 5 ? texts[3][idx] :
    number == 6 ? texts[4][idx] : "";

module segmentbase() {
    union() {
        for (x1 = [-1:1])
            for (y1 = [-1:1])
                translate([x1*tile_size/2.6675, y1*tile_size/2.6675, -height/2])
                    cylinder(height, tile_size/8, tile_size/8, $fn=60);
        cube([tile_size, tile_size/1.3, height], center=true);
        cube([tile_size/1.3, tile_size, height], center=true);
    }
}

module segmentrail() {
    rotate([90,45,0])
        cube([rail_size, rail_size, tile_size], center=true);
}

module segmentrailcorner(sx, sy, sz) {
    translate([-tile_size/2.6675, tile_size/2.6675, rail_size/0.71/4])
        scale([sx, sy, sz])
            union() {
                cylinder(rail_size/0.71/2, tile_size/4.75, tile_size/8, center=true, $fn=60);
                translate([0,0,-rail_size/0.71/2])
                    cylinder(rail_size/0.71/2, tile_size/8, tile_size/4.75, center=true, $fn=60);
            }
}

module frame() {
    union() {
        difference() {
            difference() {
                union() {
                    for (a = [0,90,180,270])
                        rotate([0,0,a]) wall();
                }
                cube(size - size/5 + (number+1)*tolerance, center=true);
            }
            rotate([0,0,90]) rail();
            rotate([0,0,180]) rail();
        }
        rail();
        rotate([180,0,270]) rail();
    }
}

module wall() {
    union() {
        translate([-(tile_size*number)/2-tile_size/5, tile_size*number/2, -height/2])
            cube([tile_size*number+tile_size/2.5, height/2, height]);
        translate([-(tile_size*number)/2-tile_size/5, tile_size*number/2 + height/2, 0])
            rotate([0,90,0])
                cylinder(tile_size*number+tile_size/2.5, height/2, height/2, $fn=60);
        translate([ tile_size*number/2+tile_size/5.35, tile_size*number/2+tile_size/5.35, 0])
            sphere(height/2, $fn=60);
    }
}

module rail() {
    translate([size/2 - size/10 + (number+1)/2*tolerance, 0, 0])
        union() {
            rotate([90,45,0])
                cube([rail_size, rail_size, size - size/5 + (number+1)*tolerance], center=true);
            translate([0, (size - size/5 + (number+1)*tolerance)/2, -rail_size/0.715/2])
                rotate([0,0,45])
                    cylinder(rail_size/0.71/2, 0, rail_size, $fn=4);
            translate([0, (size - size/5 + (number+1)*tolerance)/2, 0])
                rotate([0,0,45])
                    cylinder(rail_size/0.71/2, rail_size, 0, $fn=4);
        }
}
