// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/*
A skeleton for a simple off-chain payment channel implemented in Solidity.
There are many optimizations that could be applied to this contract to reduce
execution cost further, but this isn't a program optimization course; the point
is to illustrate the principle of off-chain scaling.
*/
contract StateChannel {
    struct OffChainLedger {
	uint nonce;
	//Amount owed by Alice to Bob. Note this is a signed number!
	int balanceDelta;
    }
    struct Signature {
	bytes32 r;
	bytes32 s;
	uint8 v;
    }
    
    
    address payable immutable public Alice;
    address payable immutable public Bob;
    int public AliceBalance;
    int public BobBalance;
    //How long time parties have to contest withdrawals, in seconds.
    //For debugging, a short period of time is convenient; for real use, a
    //longer one is required for security.
    uint immutable WARNING_PERIOD = 30;  

    //The nonce of the off-chain ledger uploaded for withdrawal.
    //If a withdrawal without signature is done before any signed withdrawal
    //has been performed, nonce will be 0.
    uint public nonce;
    //The amount that will be transferred from Alice to Bob if withdrawal
    //completes. Note it may be negative.
    int public tentativeBalanceDelta;
    //The last time that the withdrawal attempt can be appealed.
    //ETH time is UNIX time in seconds
    //(i.e. seconds since January 1, 1970 00:00:00 UTC)
    //A zero deadline indicates no withdrawal attempt is in progress.
    uint public deadline;

    //Helper functions
    //Returns the public key of the private key used to sign the message.
    function recover(Signature calldata sig, bytes32 message) internal pure
	returns (address) {
	return ecrecover(message, sig.v, sig.r, sig.s);
    }

    //Verifies a signature of an off-chain ledger; returns the address
    //(public key) of the signatory.
    function verifySignature(Signature calldata sig, OffChainLedger calldata ol)
	internal pure returns (address) {
	bytes32 hash = keccak256(abi.encode(ol.nonce,ol.balanceDelta));
        return recover(sig,hash);
    }
    function counterparty() internal view returns (address) {
	if(msg.sender == Alice) return Bob;
	if(msg.sender == Bob) return Alice;
	revert("Only Alice or Bob may interact with this channel!");
    }
			     
    
    //Creates a new state channel
    constructor(address payable bob) payable {
	Alice = payable(msg.sender);
	AliceBalance = int(msg.value);
	Bob = bob;
    }
    //Deposits money to either Alice or Bob.
    function deposit() public payable {
	//Your code goes here
    }

    //This eliminates the need for the parties to exchange ledgers with
    //delta=0 when the payment channel is established or withdrawn from before
    //they can safely deposit to it.
    function withdrawWithoutSignature() public {
	require(msg.sender == Alice || msg.sender == Bob,"No DoS pls");
	require(deadline == 0,"A withdrawal is already in progress!");
	deadline = block.timestamp + WARNING_PERIOD;
	tentativeBalanceDelta = 0;
    }

    //Given a signed off-chain ledger state, attempts to upload it.
    //If it's newer than the last uploaded state (i.e. its nonce is higher),
    //it should start a withdrawal attempt.
    //Within WARNING_PERIOD seconds, the state should become final.
    function startWithdrawal(Signature calldata sig,
			     OffChainLedger calldata L) public {
	//Your code goes here
    }
    //Sends the entire balance of the state channel to Alice and Bob;
    //one could support withdrawing only part of the funds but I don't for now.
    //If nonce is currently N, the next valid nonce to use in a signed
    //message is N+1.
    function completeWithdrawal() public {
	//Your code goes here
    }
}
