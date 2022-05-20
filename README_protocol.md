# HOW TO ADJUST THIRD-PART POOL SOFTWARE TO Neoxa

## The theory

Neoxa has a feature of remaining 10% of coins for community develpoment according to the [Whitepaper](https://www.neoxa.net/whitepaper), to implement this, Neoxa add 2 additional value when submit new block to the main network:

    "CommunityAutonomousAddress": "HCAo9dVTEo8EE1UASQ9cSW1DuU5aDo39Ph",
    "CommunityAutonomousValue": 50000000000,

These 2 values are in the RPC data when the pool request block template, and when the pool generate a new block and add it to the chain, the request data also must contain these 2 values:

    strCommunityAutonomousAddressHash
    CommunityAutonomousValue

When the blockchain receive a new block it will check those 2 values, note that "strCommunityAutonomousAddressHash" is Base58 of "CommunityAutonomousAddress", if the values are missing or wrong then the network will reject new block request, therefor if any third-part pool wants to implement Neoxa must do some tweak with their rpc data.

## For NOMP based systems

Many pools are NOMP based systems, NOMP is a nodejs based system witch has separate stratum protocol as a different project, you simply need to replace stratum lib in dependency, located in packages.json

    "dependencies": {
        "stratum-pool": "git+https://github.com/tweetyf/kawpow-stratum-pool.git",
    }

This project already has implementation of the values in protocol.

## For other pool systems

We haven't try other systems, but due to json-rpc can be implement in any program language, you only need follow the block template.

The main modification in nodejs project [https://github.com/tweetyf/kawpow-stratum-pool/blob/master/lib/transactions.js](https://github.com/tweetyf/kawpow-stratum-pool/blob/master/lib/transactions.js) line 90:

    //strCommunityAutonomousAddress 10% of coinbase
    var strCommunityAutonomousAddress           = rpcData.CommunityAutonomousAddress;
    var strCommunityAutonomousAddressHash       = bitcoin.address.fromBase58Check(strCommunityAutonomousAddress).hash;
    tx.addOutput(
        scriptCompile(strCommunityAutonomousAddressHash),
        Math.floor(rpcData.CommunityAutonomousValue)
    );

Other platform can use the code as reference.
