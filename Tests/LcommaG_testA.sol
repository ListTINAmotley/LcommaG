

// Use to test the LcommaG contract from LcommaG.sol 
// immediately after it is deployed, before any aspect of its 
// state has changed. Note that tests will change state of the 
// LcommaG contract.

// Directions:
// After deploying LcommaG, deploy LcommaG_testA
// and LcommaG_testB, each with a bit of ether (1 ether
// is more than enough). Next set various 
// addresses with functions in the deployed LcommaG_testA
// contract: use setMainContractAddress(address _addr) to set
// the address of the deployed LcommaG contract; use
// setMainContractOwnerAddress(address _addr) to set the 
// owner of that contract; and use setTestB_Address(address _addr)
// to set the address of the deployed LcommaG_testB contract.
// In a similar manner, set the addresses for the LcommaG_testB
// contract. Then run in sequence testA1(), testB2(), testA3(). 
// All tests pass. Also feel free to run "fail" functions 
// (testA_fail1(), for example) to confirm expected throws.
// I used the Remix Solidity IDE to do the testing.

pragma solidity ^0.4.24;

contract LcommaGtestA{

    address public mainContractAddress;
    address public mainContractOwnerAddress;
    address public testB_Address;
    
    constructor() public payable {}
    
    function setMainContractAddress(address _addr) public returns (bool) {
        mainContractAddress = _addr;
        return true;
    }
    
    function setMainContractOwnerAddress(address _addr) public returns (bool) {
        mainContractOwnerAddress = _addr;
        return true;
    }

    function setTestB_Address(address _addr) public returns (bool) {
        testB_Address = _addr;
        return true;
    }
     
    function testA1() public returns(bool){

        uint256 _value;
        uint256 _index;
        address _from;
        address _to;
        bool _flag;
        
        LcommaG L_G = LcommaG(mainContractAddress);        

        // Take ownership of various list elements to work with.
        L_G.gift_ClaimTINAmotleyLine(2);
        L_G.gift_ClaimTINAmotleyLine(3);
        L_G.gift_ClaimTINAmotleyLine(4);
        L_G.gift_ClaimTINAmotleyLine(8);
        L_G.gift_ClaimTINAmotleyLine(9);
        L_G.gift_ClaimTINAmotleyLine(10);
        L_G.gift_CreateTINAmotleyLine("testA creates line 1");
        L_G.gift_CreateTINAmotleyLine("testA creates line 2"); 
        assert (L_G.info_TotalSupply() == 57);

        // Transfers
        assert (L_G.gift_Transfer(testB_Address, 2));
        assert (L_G.gift_Transfer(address(0),8));

        // DeclareForSale tests
        assert (L_G.market_DeclareForSale(3,1000));
        assert (L_G.market_DeclareForSaleToAddress(56,10000,testB_Address));
        assert (L_G.market_WithdrawForSale(56));
        assert (L_G.market_DeclareForSaleToAddress(56,3000,testB_Address));
        (_flag, _index, _from, _value, _to)
            = L_G.info_ForSaleInfoByIndex(56);
        assert (_to == testB_Address);
        assert (_value == 3000);
        assert (_from == address(this));

        // DecareBid tests, making sure that wei refunded correctly after higher
        // or withdrawn bids.
        assert (L_G.market_DeclareBid.value(500)(30));
        assert (L_G.info_PendingWithdrawals(this) == 0);
        assert (L_G.market_DeclareBid.value(700)(30));
        assert (L_G.info_PendingWithdrawals(this) == 500);
        assert (L_G.market_DeclareBid.value(600)(31));
        assert (L_G.market_WithdrawBid(31));
        assert (L_G.info_PendingWithdrawals(this) == 1100);

        // Confirm that with various transactions, numbers of list
        // elements come out right
        assert (L_G.info_BalanceOf(this) == 6);
        assert (L_G.info_BalanceOf(testB_Address) == 1);
        assert (L_G.info_BalanceOf(mainContractOwnerAddress) == 42);
        assert (L_G.info_BalanceOf(address(0)) == 8); 
        return true;
    }
    
    function testA3() public returns(bool){
        
        uint256 _value;
        uint256 _index;
        address _from;
        address _to;
        bool _flag;
        
        LcommaG L_G = LcommaG(mainContractAddress);

        // Check that for sale info resets correctly during transfer
        assert(L_G.market_DeclareForSale(9,800));
        (_flag, _index, _from, _value, _to) = L_G.info_ForSaleInfoByIndex(9);
        assert (_flag);
        assert (_value == 800);
        assert(L_G.gift_Transfer(testB_Address,9));
        (_flag, _index, _from, _value, _to) = L_G.info_ForSaleInfoByIndex(9);
        assert (!_flag);
        assert (_value == 0);
        
        // Check that BidInfo resets correctly during transfer
        (_flag, _index, _to, _value) = 
            L_G.info_BidInfoByIndex(10);
        assert(_flag);
        assert(_to == testB_Address);
        assert(L_G.gift_Transfer(testB_Address,10));
        (_flag, _index, _to, _value) = 
            L_G.info_BidInfoByIndex(10);
        // Since token 10 transferred, Bid should reset, and wei from Bid
        // should be placed in PendingWithdrawals for contract A.
        assert(!_flag);
        assert(_to == address(0));
        assert (L_G.info_PendingWithdrawals(testB_Address) == 2000);
        
        // Check that market_AcceptBid(_index) works
        (_flag, _index, _to, _value) = 
            L_G.info_BidInfoByIndex(55);
        assert (_flag);
        assert (L_G.info_OwnerTINAmotleyLine(55) == address(this));
        assert (L_G.market_AcceptBid(55,100));
        assert (L_G.info_OwnerTINAmotleyLine(55) == testB_Address);
        (_flag, _index, _to, _value) = 
            L_G.info_BidInfoByIndex(55);
        assert (!_flag);
        assert (L_G.info_PendingWithdrawals(testB_Address) == 2000);
        // Contract A gets 2000 more wei when bid accepted.
        assert (L_G.info_PendingWithdrawals(this) == 4800);
        
        // Final counts of tokens
        assert (L_G.info_BalanceOf(this) == 4);
        assert (L_G.info_BalanceOf(testB_Address) == 9 );
        assert (L_G.info_BalanceOf(mainContractOwnerAddress) == 42);
        assert (L_G.info_BalanceOf(address(0)) == 4);
        assert (L_G.info_TotalSupply() == 59);
       
        return true;
    }
    
    function testA_fail1() public returns(bool){

        LcommaG L_G = LcommaG(mainContractAddress);
        // TestA contract can't declare token 39 for sale since it doesn't own it.
        L_G.market_DeclareForSale(39, 100);
        return true;
    }
    
    function testA_fail2() public returns(bool){

        LcommaG L_G = LcommaG(mainContractAddress);
        // TestA contract can't transfer it either.
        L_G.gift_Transfer(testB_Address, 39);
        return true;
    }
    
    function testA_fail3() public returns(bool){

        LcommaG L_G = LcommaG(mainContractAddress);
        // TestA contract can't claim it either.
        L_G.gift_ClaimTINAmotleyLine(39);
        return true;
    }
    
    function testA_fail4() public returns(bool){

        LcommaG L_G = LcommaG(mainContractAddress);
        //index out of bounds
        L_G.market_DeclareBid.value(1000)(60);
        return true;
    }
    
    function testA_fail5() public returns(bool){

        LcommaG L_G = LcommaG(mainContractAddress);
        //For Sale only to mainContractOwnerAddress
        L_G.market_BuyForSale.value(5000)(8);
        return true;
    }
        
}



contract LcommaG{

   struct forSaleInfo {
        bool isForSale;
        uint256 tokenIndex;
        address seller;
        uint256 minValue;          //in wei.... everything in wei
        address onlySellTo;     // specify to sell only to a specific person
    }
    struct bidInfo {
        bool hasBid;
        uint256 tokenIndex;
        address bidder;
        uint256 value;
    }
    mapping (uint256 => forSaleInfo) public info_ForSaleInfoByIndex;
    mapping (uint256 => bidInfo) public info_BidInfoByIndex;
    mapping (address => uint256) public info_PendingWithdrawals;
    function info_TotalSupply() public view returns (uint256 total);
    function info_BalanceOf(address _owner) public view 
        returns (uint256 balance);
    function info_SeeTINAmotleyLine(uint256 _tokenId) external view 
        returns(string);
    function info_OwnerTINAmotleyLine(uint256 _tokenId) external 
     	  view returns (address owner);
    function info_CanBeClaimed(uint256 _tokenId) external view returns(bool);
    function gift_ClaimTINAmotleyLine(uint256 _tokenId) external returns(bool);
    function gift_CreateTINAmotleyLine(string _text) external returns(bool); 
    function gift_Transfer(address _to, uint256 _tokenId) public returns(bool);
    function market_DeclareForSale(uint256 _tokenId, uint256 _minPriceInWei) 
         external returns (bool);
    function market_DeclareForSaleToAddress(uint256 _tokenId, uint256 
         _minPriceInWei, address _to) external returns(bool);
    function market_WithdrawForSale(uint256 _tokenId) public returns(bool);
    function market_BuyForSale(uint256 _tokenId) payable external returns(bool);
    function market_DeclareBid(uint256 _tokenId) payable external returns(bool);
    function market_WithdrawBid(uint256 _tokenId) external returns(bool);
    function market_AcceptBid(uint256 _tokenId, uint256 minPrice) 
         external returns(bool);
    function market_WithdrawWei() external returns(bool);

}


