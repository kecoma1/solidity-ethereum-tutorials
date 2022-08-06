// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
pragma experimental ABIEncoderV2;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract KToken is IERC20 {

    string public constant name = "KToken";
    string public constant symbol = "KTKN";
    uint8 public constant decimals = 6;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint256 totalSupply_;


    constructor (uint256 initialSupply) {
        totalSupply_ = initialSupply;
        balances[msg.sender] =totalSupply_;
    }

    modifier EnoughBalance(address wallet, uint256 amount) {
        require(amount <= balances[wallet], "The wallet doesn't have enough tokens");
        _;
    }

    modifier EnoughAllowance(address wallet, address spender, uint amount) {
        require(amount <= allowed[wallet][spender], "You do not have enough allowance");
        _;
    }

    function totalSupply() external view override returns (uint256) {
        return totalSupply_;
    }

    function increaseTotalSupply(uint amount) public {
        totalSupply_ += amount;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return balances[account];
    }

    function allowance(address owner, address spender) external view override returns (uint256) {
        return allowed[owner][spender];
    }

    function transfer(address recipient, uint256 amount) external override EnoughBalance(msg.sender, amount) returns (bool) {
        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function approve(address spender, uint256 amount) external override EnoughBalance(msg.sender, amount) returns (bool) {
        allowed[msg.sender][spender] += amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(address owner, address recipient, uint256 amount) external override EnoughBalance(owner, amount) EnoughAllowance(owner, msg.sender, amount) returns (bool) {
        balances[owner] -= amount;
        allowed[owner][msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(owner, recipient, amount);

        return true;
    }
}

//                                              1st 2nd 3rd     4th
// 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 - 100 80  80      100
// 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 - 0   20  *0(20)  0
// 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db - 0   0   *20     0
