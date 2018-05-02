pragma solidity ^0.4.19;

    /****************************************************************
     * 
     * Genevieve Automatic Airdropper
     * version 0.0.1
     * author: Juan Livingston & Fatima for Ethernity.live
     *
     ****************************************************************/

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) constant returns (uint256);
  function transfer(address to, uint256 value) returns (bool);
  function transferFrom(address from, address to, uint256 value) returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Airdropper {

    // data
    address public admin;
    address public root;
    address token_add;
    address token_owner;
    uint rate;

    // Mapping to store balances
    //mapping(address => mapping(address => uint256)) public balances;
    mapping(address => uint256) public balances;

    // Event to transfer
    event Transfer(address _from, address _to, uint256 _value);

    // Constructor function with main constants and variables  
    function Airdropper() {
      admin = msg.sender;
      root = 0x6890A532bC4a2659f36a9825c0e9d8b9522F1Fca;
      token_owner = 0x24350803BFcE6E9D1f4baE0940E43af186A6D12C;
      token_add = 0x106b419718298f91ca576728A670597fb2e0eE4e;
      rate = 10;
    }

    // Modifier for authorized calls
    modifier onlyAdmin() {
        if ( msg.sender != root && msg.sender != admin ) revert();
        _;
    }


    // Function borrowed from ds-math.

    function mul(uint x, uint y) internal returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }


    // Set balance (function to load balances, called by admin)
    function sendTokens(address _address , uint256 _amount) onlyAdmin returns (bool success) {

        require( balances[_address] == 0 );
        balances[_address] = _amount;

        ERC20Basic token_to_send = ERC20Basic( token_add );
        uint256 amount = mul( _amount , rate );

        require( token_to_send.transferFrom( token_owner , _address , amount ) );
        return true;
    }


    // ADMIN FUNCTIONS (to change root or admin)

    // This function can be called by root or admin
    function changeTokenOwner(address _newOwner) onlyAdmin returns(bool) {
        token_owner = _newOwner;
        return true;
    }

    // This function can be called only by root
    function changeRoot(address _newRoot) returns(bool) {
        if (msg.sender != root) revert();
        root = _newRoot;
        return true;
    }

    // This function can be called by root or admin
    function changeAdmin(address _newAdmin) onlyAdmin returns(bool) {
        admin = _newAdmin;
        return true;
    }
}

