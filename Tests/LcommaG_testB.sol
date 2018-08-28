

// Used to test the LcommaG contract from LcommaG.sol 
// immediately after it is deployed, before any aspect of its 
// state has changed. Note that tests will change state of the 
// LcommaG contract.

// Directions:
// After deploying LcommaG, deploy LcommaG_testA
// and LcommaG_testB, each with a bit of ether (1 ether
// is more than enough). Next set various 
// addresses with functions in the deployed LcommaG_testB
// contract: use setMainContractAddress(address _addr) to set
// the address of the deployed LcommaG contract; use
// setMainContractOwnerAddress(address _addr) to set the 
// owner of that contract; and use setTestA_Address(address _addr)
// to set the address of the deployed LcommaG_testA contract.
// In a similar manner, set the addresses for the LcommaG_testA
// contract. Then run in sequence testA1(), testB2(), testA3(). 
// All tests pass. Also feel free to run "fail" functions 
// (testA_fail1(), for example) to confirm expected throws.
// I used the Remix Solidity IDE to do the testing.


pragma solidity ^0.4.24;

contract LcommaG_testB{

    address public mainContractAddress;
    address public mainContractOwnerAddress;
    address public testA_Address;
    
    constructor() public payable {}
    
    function setMainContractAddress(address _addr) public returns (bool) {
        mainContractAddress = _addr;
        return true;
    }
    
    function setMainContractOwnerAddress(address _addr) public returns (bool) {
        mainContractOwnerAddress = _addr;
        return true;
    }

    function setTestA_Address(address _addr) public returns (bool) {
        testA_Address = _addr;
        return true;
    }
     
    function testB2() public returns(uint256){
        
        uint256 _value;
        uint256 _index;
        address _from;
        address _to;
        bool _flag;

        LcommaG L_G = LcommaG(mainContractAddress);        

        // Associate various list elements with testB contract for tests
        L_G.gift_ClaimTINAmotleyLine(5);
        L_G.gift_ClaimTINAmotleyLine(6);
        L_G.gift_ClaimTINAmotleyLine(7);
        L_G.gift_ClaimTINAmotleyLine(8);
        L_G.gift_CreateTINAmotleyLine("testB creates line 1");
        L_G.gift_CreateTINAmotleyLine("testB creates line 2"); 
        assert (L_G.info_TotalSupply() == 59);
        
        // Check Transfer
        assert (L_G.gift_Transfer(testA_Address, 7));
        assert (L_G.info_OwnerTINAmotleyLine(6) == address(this));
        assert (L_G.gift_Transfer(testA_Address, 6));
        assert (L_G.info_OwnerTINAmotleyLine(6) == testA_Address);
 
        // Check DecareForSale, and BuyForSale
        assert (L_G.market_DeclareForSaleToAddress(8,5000,
            mainContractOwnerAddress));
        assert (L_G.info_OwnerTINAmotleyLine(3) == testA_Address);
        (_flag, _index, _from, _value, _to) = L_G.info_ForSaleInfoByIndex(3);
        assert (_flag);
        assert (_value == 1000);
        assert (L_G.market_BuyForSale.value(1000)(3));
        (_flag, _index, _from, _value, _to) = L_G.info_ForSaleInfoByIndex(3);
        assert (!_flag);
        assert (_value == 0);
        assert (L_G.info_OwnerTINAmotleyLine(3) == address(this));
        // Check that wei from sale of item 3 is correctly given to 
        // testA contract
        assert (L_G.info_PendingWithdrawals(testA_Address) == 2100);


        // Check that bids behave correctly
        (_flag, _index, _to, _value) =
            L_G.info_BidInfoByIndex(30);
        assert (_flag);
        assert (_to == testA_Address);
        assert (_value == 700);
        // The following outbids the testA contract. Check that new bid 
        // overwrites old one, and that wei are refunded.
        assert (L_G.market_DeclareBid.value(1500)(30));
        (_flag, _index, _to, _value) =
            L_G.info_BidInfoByIndex(30);
        assert (_flag);
        assert (_to == address(this));
        assert (_value == 1500);
        assert (L_G.info_PendingWithdrawals(testA_Address) == 2800);

        // The following are used in testA3
        assert (L_G.market_DeclareBid.value(2000)(55));
        assert (L_G.market_DeclareBid.value(2000)(10));

        // Check various balances
        assert (L_G.info_PendingWithdrawals(this) == 0);
        assert (L_G.info_BalanceOf(this) == 6);
        assert (L_G.info_BalanceOf(testA_Address) == 7);
        assert (L_G.info_BalanceOf(mainContractOwnerAddress) == 42);
        assert (L_G.info_BalanceOf(address(0)) == 4); 

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
    function info_OwnerTINAmotleyLine(uint256 _tokenId) external view 
        returns (address owner);
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


