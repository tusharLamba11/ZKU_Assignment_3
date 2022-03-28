pragma circom 2.0.3;

include "circomlib/circuits/mimcsponge.circom";

template suiteVerify () {
    
    signal input newCard;
    signal input newCardSuite;

    
    signal output cardHash;
    signal output cardSuite;

    
    component hash0 = MiMCSponge(2, 0, 1);
    hash0.ins[0] <== newCard;
    hash0.ins[1] <== newCardSuite;

    component hash1 = MiMCSponge(1, 0, 1);
    hash1.ins[0] <== hash0.outs[0];

    
    cardHash <== hash1.outs[0];
    cardSuite <== newCardSuite % 4;
}

component main = suiteVerify();