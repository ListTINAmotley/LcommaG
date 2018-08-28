# LcommaG

// List elements in listTINAmotley contain text snippets from 
// Margaret Thatcher, Donna Haraway (A Cyborg Manfesto), Francois 
// Rabelias (Gargantua and Pantagruel), Walt Whitman (Germs), and 
// Miguel de Cervantes (Don Quixote).

// A list element associated with \_index can be claimed if 
// gift_CanBeClaimed(\_index) returns true. For inquiries
// about receiving lines owned by info_ownerOfContract for free, 
// email ListTINAmotley@gmail.com. 

// In general, the functions that begin with "gift_" are used for 
// claiming, transferring, and creating script lines without cost beyond 
// the transaction fee. For example, to claim an available list element 
// associated with \_index, execute the gift_ClaimTINAmotleyLine(\_index) 
// function.

// The functions that begin with "info_" are used to obtain information 
// about aspects of the program state, including the address that owns 
// a list element, and the "for sale" or "bid" status of a list element. 

// The functions that begin with "market_" are used for buying, selling, and
// placing bids on a list element. For example, to bid on the list element
// associated with _index, send the bid (in wei, not ether) along with
// the function execution of market_DeclareBid(_index).

// Note that if there's a transaction involving ether (successful sale, 
// accepted bid, etc..), the ether (in units of wei) is not
// automatically credited to an account; it has to be withdrawn by
// calling market_WithdrawWei().

// Source code and code used to test the contract are available at 
// https://github.com/ListTINAmotley/LcommaG

// EVERYTHING IS IN UNITS OF WEI, NOT ETHER!

// Contract is deployed at  on the 
// mainnet.


The elements of the array listTINAmotley (in LcommaG.sol) can be claimed, 
transferred, bought, and sold on the Ethereum network. 
Users can also add to the original array.

The elements in listTINAmotley below are recited in a video
by Greg Smith. Both the video and this program will be part of
exhibitions at the John Michael Kohler Art Center in
Sheboygan, WI, and at Susan Inglett Gallery in New York, NY.

Code is based on CryptoPunks, by Larva Labs.

List elements in listTINAmotley contain text snippets from 
Margaret Thatcher, Donna Haraway (A Cyborg Manfesto), Francois 
Rabelias (Gargantua and Pantagruel), Walt Whitman (Germs), and 
Miguel de Cervantes (Don Quixote).

A list element associated with \_index can be claimed if 
gift_CanBeClaimed (\_index) returns true. For inquiries
about receiving lines owned by info_ownerOfContract for free, 
email ListTINAmotley@gmail.com. 

In general, the functions in LcommaG.sol that begin with "gift_" are used for 
claiming, transferring, and creating script lines without cost beyond 
the transaction fee. For example, to claim an available list element 
associated with \_index, execute the gift_ClaimTINAmotleyLine(\_index) 
function.

The functions that begin with "info_" are used to obtain information 
about aspects of the program state, including the address that owns 
a list element, and the "for sale" or "bid" status of a list element. 

The functions that begin with "market_" are used for buying, selling, and
placing bids on a list element. For example, to bid on the list element
associated with \_index, send the bid (in wei, not ether) along with
the function execution of market_DeclareBid(\_index).

Note that if there's a transaction involving ether (successful sale, 
accepted bid, etc..), the ether (in units of wei) is not
automatically credited to an account; it has to be withdrawn by
calling market_WithdrawWei().

Source code and code used to test the contract are available at 
https://github.com/ListTINAmotley/LcommaG

EVERYTHING IS IN UNITS OF WEI, NOT ETHER!

The contract is deployed on the mainnet 
at 
