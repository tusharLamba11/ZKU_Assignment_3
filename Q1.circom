pragma circom 2.0.0;

include "./circomlib/circuits/poseidon.circom";

function isTriangle(a0, a1, b0, b1, c0, c1) {
    // check all pairs of points do not lie on the same line

    if(a0 == b0){
        // defines a non-double-point
        assert(a1 != b1);

        // defines a third point
        assert(c0 != a0); // => c0 != b0
        assert(c1 != a1); 
        assert(c1 != b1);
    }

    if(a0 == c0){
        assert(a1 != c1);
        assert(b0 != a0);
        assert(b1 != c1);
        assert(b1 != a1);
    }

    if(b0 == c0){
        assert(b1 != c1);
        assert(a0 != b0);
        assert(a1 != b1);
        assert(a1 != c1);
    }

    if(a1 == b1){
        assert(a0 != b0);
        assert(c1 != a1); 
        assert(c0 != a0); 
        assert(c0 != b0);
    }

    if(a1 == c1){
        assert(a0 != c0);
        assert(b1 != a1);
        assert(b0 != c0);
        assert(b0 != a0);
    }

    if(b1 == c1){
        assert(b0 != c0);
        assert(a1 != b1);
        assert(a0 != b0);
        assert(a0 != c0);
    }   

    return 1;
}

template Move () {
    signal input x[2];
    signal input y[2];
    signal input z[2];

    // hash position
    signal output out[6];

    // make sure the move is on a triangle
    assert(isTriangle(x[0], x[1], y[0], y[1], z[0], z[1]));
    
    // make sure the move is energy-legal
    var distXYx = x[0]*x[0] - y[0]*y[0];
    var distXYy = x[1]*x[1] - y[1]*y[1];
    var distYZx = y[0]*y[0] - z[0]*z[0];
    var distYZy = y[1]*y[1] - z[1]*z[1];
    var distZXx = z[0]*z[0] - y[0]*y[0];
    var distZXy = z[1]*z[1] - y[1]*y[1];
    assert(distXYx*distXYx +  distXYy*distXYy < 100);
    assert(distYZx*distYZx +  distYZy*distYZy < 100);
    assert(distZXx*distZXx +  distZXy*distZXy < 100);

    component hash0 = Poseidon(1);
    component hash1 = Poseidon(1);
    component hash2 = Poseidon(1);
    component hash3 = Poseidon(1);
    component hash4 = Poseidon(1);
    component hash5 = Poseidon(1);
    hash0.inputs[0] <== x[0];
    hash1.inputs[0] <== x[1];
    hash2.inputs[0] <== x[0];
    hash3.inputs[0] <== x[1];
    hash4.inputs[0] <== x[0];
    hash5.inputs[0] <== x[1];

    out[0] <== hash0.out;
    out[1] <== hash1.out;
    out[2] <== hash2.out;
    out[3] <== hash3.out;
    out[4] <== hash4.out;
    out[5] <== hash5.out;
}

component main = Move();