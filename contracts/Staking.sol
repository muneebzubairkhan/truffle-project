//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract StakeNft is IERC721Receiver, Ownable {
    using EnumerableSet for EnumerableSet.UintSet;

    address public ERC20_CONTRACT;
    address public ERC721_CONTRACT;
    uint256 public EXPIRATION; // expiry block number (avg 15s per block)

    mapping(address => EnumerableSet.UintSet) private _deposits;
    mapping(address => mapping(uint256 => uint256)) public depositBlocks;
    mapping(uint256 => uint256) public tokenRarity;
    uint256[7] public rewardRate;
    bool started;

    constructor(
        address _erc20,
        address _erc721,
        uint256 _expiration
    ) {
        ERC20_CONTRACT = _erc20;
        ERC721_CONTRACT = _erc721;
        EXPIRATION = block.number + _expiration;

        // number of tokens Per day
        rewardRate = [50, 60, 75, 100, 150, 500, 0];
        started = false;
    }

    function setRate(uint256 _rarity, uint256 _rate) public onlyOwner {
        rewardRate[_rarity] = _rate;
    }

    function setRarity(uint256 _tokenId, uint256 _rarity) public onlyOwner {
        tokenRarity[_tokenId] = _rarity;
    }

    function setBatchRarity(uint256[] memory _tokenIds, uint256 _rarity) public onlyOwner {
        for (uint256 i; i < _tokenIds.length; i++) tokenRarity[_tokenIds[i]] = _rarity;
    }

    function setExpiration(uint256 _expiration) public onlyOwner {
        EXPIRATION = _expiration;
    }

    function toggleStart() public onlyOwner {
        started = !started;
    }

    function setTokenAddress(address _tokenAddress) public onlyOwner {
        // Used to change rewards token if needed
        ERC20_CONTRACT = _tokenAddress;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        // uint256 _tokenId,
        // deposit([_tokenId]);
        return IERC721Receiver.onERC721Received.selector;
    }

    function depositsOf(address account) external view returns (uint256[] memory) {
        EnumerableSet.UintSet storage depositSet = _deposits[account];
        uint256[] memory tokenIds = new uint256[](depositSet.length());

        for (uint256 i; i < depositSet.length(); i++) {
            tokenIds[i] = depositSet.at(i);
        }

        return tokenIds;
    }

    function findRate(uint256 tokenId) public view returns (uint256 rate) {
        uint256 rarity = tokenRarity[tokenId];
        uint256 perDay = rewardRate[rarity];

        // 6000 blocks per day
        // perDay / 6000 = reward per block

        rate = (perDay * 1e18) / 6000;

        return rate;
    }

    function calculateRewards(address account, uint256[] memory tokenIds) public view returns (uint256[] memory rewards) {
        rewards = new uint256[](tokenIds.length);

        for (uint256 i; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 rate = findRate(tokenId);
            rewards[i] =
                rate *
                (_deposits[account].contains(tokenId) ? 1 : 0) *
                (Math.min(block.number, EXPIRATION) - depositBlocks[account][tokenId]);
        }
    }

    function claimRewards(uint256[] calldata tokenIds) public {
        uint256 reward;
        uint256 curblock = Math.min(block.number, EXPIRATION);

        uint256[] memory rewards = calculateRewards(msg.sender, tokenIds);

        for (uint256 i; i < tokenIds.length; i++) {
            reward += rewards[i];
            depositBlocks[msg.sender][tokenIds[i]] = curblock;
        }

        if (reward > 0) {
            IERC20(ERC20_CONTRACT).transferFrom(address(this), msg.sender, reward);
        }
    }

    function deposit(uint256[] calldata tokenIds) external {
        require(started, "Staking contract not started yet");

        claimRewards(tokenIds);

        for (uint256 i; i < tokenIds.length; i++) {
            IERC721(ERC721_CONTRACT).safeTransferFrom(msg.sender, address(this), tokenIds[i], "");
            _deposits[msg.sender].add(tokenIds[i]);
        }
    }

    function admin_deposit(uint256[] calldata tokenIds) external onlyOwner {
        claimRewards(tokenIds);

        for (uint256 i; i < tokenIds.length; i++) {
            IERC721(ERC721_CONTRACT).safeTransferFrom(msg.sender, address(this), tokenIds[i], "");
            _deposits[msg.sender].add(tokenIds[i]);
        }
    }

    function withdraw(uint256[] calldata tokenIds) external {
        claimRewards(tokenIds);

        for (uint256 i; i < tokenIds.length; i++) {
            require(_deposits[msg.sender].contains(tokenIds[i]), "Token not deposited");

            _deposits[msg.sender].remove(tokenIds[i]);

            IERC721(ERC721_CONTRACT).safeTransferFrom(address(this), msg.sender, tokenIds[i], "");
        }
    }

    function claimTheRewards(uint256[] calldata tokenIds) external {
        claimRewards(tokenIds);
    }
}
