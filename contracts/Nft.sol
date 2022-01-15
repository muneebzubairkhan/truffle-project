// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

interface IglooToken {
    function whitelist_mint(address account, uint256 amount) external;
}

contract NftStaking is IERC721Receiver, Ownable {
    using EnumerableSet for EnumerableSet.UintSet;

    address public ERC20_CONTRACT = address(0);
    address public ERC721_CONTRACT = address(0);
    uint256 public EXPIRATION = 1000 ether; //expiry block number (avg 15s per block)
    
    mapping(address => EnumerableSet.UintSet) private _deposits;
    mapping(address => mapping(uint256 => uint256)) public depositBlocks;
    mapping (uint256 => uint256) public tokenRarity;
    uint256[7] public rewardRate = [50, 60, 75, 100, 150, 500, 0];   
    bool started = false;

    // constructor(
    //     address _erc20,
    //     address _erc721,
    //     uint256 _expiration
    // ) {
    //     ERC20_CONTRACT = _erc20;
    //     ERC721_CONTRACT = _erc721;
    //     EXPIRATION = block.number + _expiration;
    //     // number of tokens Per day
    //     rewardRate = [50, 60, 75, 100, 150, 500, 0];
    //     started = false;
    // }

    function setRate(uint256 _rarity, uint256 _rate) public onlyOwner() {
        rewardRate[_rarity] = _rate;
    }

    function setRarity(uint256 _tokenId, uint256 _rarity) public onlyOwner() {
        tokenRarity[_tokenId] = _rarity;
    }

    function setBatchRarity(uint256[] memory _tokenIds, uint256 _rarity) public onlyOwner() {
        for (uint256 i; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            tokenRarity[tokenId] = _rarity;
        }
    }

    function setExpiration(uint256 _expiration) public onlyOwner() {
        EXPIRATION = _expiration;
    }

    
    function toggleStart() public onlyOwner() {
        started = !started;
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner() {
        // Used to change rewards token if needed
        ERC20_CONTRACT = _tokenAddress;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function depositsOf(address account)
        external
        view
        returns (uint256[] memory)
    {
        EnumerableSet.UintSet storage depositSet = _deposits[account];
        uint256[] memory tokenIds = new uint256[](depositSet.length());

        for (uint256 i; i < depositSet.length(); i++) {
            tokenIds[i] = depositSet.at(i);
        }

        return tokenIds;
    }

    function findRate(uint256 tokenId)
        public
        view
        returns (uint256 rate) 
    {
        uint256 rarity = tokenRarity[tokenId];
        uint256 perDay = rewardRate[rarity];
        
        // 6000 blocks per day
        // perDay / 6000 = reward per block

        rate = (perDay * 1e18) / 6000;
        
        return rate;
    }

    function pendingRewardToken(uint pid, address account, uint256[] memory tokenIds)
        public
        view
        returns (uint256[] memory rewards)
    {
        rewards = new uint256[](tokenIds.length);

        for (uint256 i; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 rate = findRate(tokenId);
            rewards[i] =
                rate *
                (_deposits[account].contains(tokenId) ? 1 : 0) *
                (Math.min(block.number, EXPIRATION) -
                    depositBlocks[account][tokenId]);
        }
    }

    // // pool ids
    // uint public pids;

    // function addPoolToken

    // get pid from token address
    function getPidOfToken(address token) external view returns (uint256) {
      return 0;
        // for (uint256 index = 0; index < poolInfo.length; index++) {
        //     if (address(poolInfo[index].poolToken) == _token) {
        //         return index;
        //     }
        // }

        // return type(uint256).max;
    }

    function claimRewards(uint pid, uint256[] calldata tokenIds) public {
        uint256 reward;
        uint256 curblock = Math.min(block.number, EXPIRATION);

        uint256[] memory rewards = pendingRewardToken(pid, msg.sender, tokenIds);

        for (uint256 i; i < tokenIds.length; i++) {
            reward += rewards[i];
            depositBlocks[msg.sender][tokenIds[i]] = curblock;
        }

        if (reward > 0) {
            IglooToken(ERC20_CONTRACT).whitelist_mint(msg.sender, reward);
        }
    }

    function depositMany(uint pid, uint256[] calldata tokenIds) external {
        require(started, 'StakeSeals: Staking contract not started yet');

        claimRewards(pid, tokenIds);
        
        for (uint256 i; i < tokenIds.length; i++) {
            IERC721(ERC721_CONTRACT).safeTransferFrom(
                msg.sender,
                address(this),
                tokenIds[i],
                ''
            );
            _deposits[msg.sender].add(tokenIds[i]);
        }
    }

    function admin_deposit(uint pid, uint256[] calldata tokenIds) onlyOwner() external {
        claimRewards(pid, tokenIds);
        

        for (uint256 i; i < tokenIds.length; i++) {
            IERC721(ERC721_CONTRACT).safeTransferFrom(
                msg.sender,
                address(this),
                tokenIds[i],
                ''
            );
            _deposits[msg.sender].add(tokenIds[i]);
        }
    }

    function withdrawMany(uint pid, uint256[] calldata tokenIds) external {
        claimRewards(pid, tokenIds);

        for (uint256 i; i < tokenIds.length; i++) {
            require(
                _deposits[msg.sender].contains(tokenIds[i]),
                'StakeSeals: Token not deposited'
            );

            _deposits[msg.sender].remove(tokenIds[i]);

            IERC721(ERC721_CONTRACT).safeTransferFrom(
                address(this),
                msg.sender,
                tokenIds[i],
                ''
            );
        }
    }
}