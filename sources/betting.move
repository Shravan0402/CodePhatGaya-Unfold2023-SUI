module my_first_package::betting{

    use sui::sui::SUI;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::coin::{Self, Coin};
    use sui::tx_context::{Self, TxContext};

    struct OwnerCall has key {id: UID}

    struct Bet has key { //main stucture to store bet for any team 
        id: UID,
        randomKey: u64,
        teamid: u8,
        won:bool,
        amount: Coin<SUI>
    }

    struct BetID has key {
        id: UID,
        parentrandom: u64,
        teamVoted: u8,
        amount: u64
    }

    struct WonBet has key {
        id: UID,
        amount: Coin<SUI>
    }

    fun init(ctx: &mut TxContext) {
        transfer::transfer(OwnerCall {
            id: object::new(ctx)
        }, tx_context::sender(ctx));
    }

    // Creating two bets structure for both the team 
    public entry fun createBet(random: u64, ctx: &mut TxContext){
        transfer::share_object(Bet {
            id: object::new(ctx),
            randomKey:random,
            teamid: 0,
            won:false,
            amount: coin::zero(ctx)
        });
        transfer::share_object(Bet {
            id: object::new(ctx),
            randomKey:random,
            teamid: 1,
            won:false,
            amount: coin::zero(ctx)
        });
    }

    public entry fun updateWinner(_: &OwnerCall, details: &mut Bet){
        details.won = true;
    }

    //We are merging the previous coins to the updated amount
    //Will be giving betid objects
    public entry fun justBet(payment: Coin<SUI>, details: &mut Bet, ctx: &mut TxContext){
        transfer::transfer(BetID {
            id: object::new(ctx),
            parentrandom: details.randomKey,
            teamVoted: details.teamid,
            amount: coin::value(&mut payment)
        }, tx_context::sender(ctx));
        coin::join(&mut details.amount, payment);
    }

    public entry fun redeemBet(myBet: &mut BetID, details: &mut Bet, loseDetails: &mut Bet, ctx: &mut TxContext){
        if(details.won == true && loseDetails.won == false && details.randomKey == myBet.parentrandom && loseDetails.randomKey == myBet.parentrandom && details.teamid == myBet.teamVoted){
            let win = ((myBet.amount/coin::value(&mut details.amount))*coin::value(&mut loseDetails.amount));
            transfer::transfer(WonBet {
                id: object::new(ctx),
                amount: coin::split(&mut details.amount, myBet.amount, ctx)
            }, tx_context::sender(ctx));
            transfer::transfer(WonBet {
                id: object::new(ctx),
                amount: coin::split(&mut loseDetails.amount, win, ctx)
            }, tx_context::sender(ctx));
        }
    }

}

// #[test]
// public fun test_sword_create() {
//     use sui::tx_context;
//     use sui::coin::{Self, Coin};
//     // Create a dummy TxContext for testing
//     let ctx = tx_context::dummy();
//     struct LOCKED_COIN has drop {}
//     let (treasury_cap, metadata) = coin::create_currency<LOCKED_COIN>(otw, 8, b"LOCKED COIN", b"LOCK", b"", option::none(), ctx);
//     // Create a sword
//     let bet = Bet {
//         id: object::new(&mut ctx),
//         randomKey: 8,
//         teamid:0,
//         won:0
//         amount:coin::mint(treasury_cap, 1000, ctx);
//     };

//     // Check if accessor functions return correct values
//     // assert!(magic(&sword) == 42 && strength(&sword) == 7, 1);
// }