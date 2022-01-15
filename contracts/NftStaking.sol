// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

interface IERC20 {
    function whitelist_mint(address account, uint256 amount) external;
}

contract NftStaking is IERC721Receiver, Ownable, Pausable {
    using EnumerableSet for EnumerableSet.UintSet;

    IERC20 public erc20 = IERC20(0x2eC91e6941A1C0da8cB27B86168b1935dB0f1dCE);

    // pool ids
    uint256 public pidsLen;
    // struct replacement
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) depositBlocks;
    mapping(uint256 => mapping(address => EnumerableSet.UintSet)) _deposits;
    mapping(uint256 => mapping(uint256 => uint256)) tokenRarity;
    mapping(uint256 => uint256) EXPIRATION; // explain it
    mapping(uint256 => IERC721) depositToken;
    mapping(uint256 => uint256[7]) rewardRate;

    constructor() {
        addPoolToken(IERC721(0x4BD39d433bb884e28AA49402ED33479d0Cf720A1));
        addPoolToken(IERC721(0xDA95B6347602226f603869e1719a668440aC18aC));
    }

    function addPoolToken(IERC721 _depositToken) public onlyOwner {
        EXPIRATION[pidsLen] = 1000 ether;
        depositToken[pidsLen] = _depositToken;
        rewardRate[pidsLen++] = [10, 30, 40, 50, 60, 120, 0];
    }

    // get pid from token address
    function getPidOfToken(IERC721 token) external view returns (uint256) {
        for (uint256 i = 0; i < pidsLen; i++)
            if (depositToken[i] == token) return i;

        return type(uint256).max;
    }

    // constructor(
    //     address _erc20,
    //     address _depositToken,
    //     uint256 _expiration
    // ) {
    //     ERC20_CONTRACT = _erc20;
    //     ERC721_CONTRACT = _depositToken;
    //     EXPIRATION = block.number + _expiration;
    //     // number of tokens Per day
    //     rewardRate = [50, 60, 75, 100, 150, 500, 0];
    // }

    function setRate(
        uint256 pid,
        uint256 _rarity,
        uint256 _rate
    ) public onlyOwner {
        require(pid < pidsLen, "invalid pid");
        
        rewardRate[pid][_rarity] = _rate;
    }

    function setRarity(
        uint256 pid,
        uint256 _tokenId,
        uint256 _rarity
    ) public onlyOwner {
        require(pid < pidsLen, "invalid pid");

        tokenRarity[pid][_tokenId] = _rarity;
    }

    function setBatchRarity(
        uint256 pid,
        uint256[] memory _tokenIds,
        uint256 _rarity
    ) public onlyOwner {
        require(pid < pidsLen, "invalid pid");

        for (uint256 i; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            tokenRarity[pid][tokenId] = _rarity;
        }
    }

    function setExpiration(uint256 pid, uint256 _expiration) public onlyOwner {
        EXPIRATION[pid] = _expiration;
    }

    function setRewardTokenAddress(IERC20 _erc20) public onlyOwner {
        erc20 = _erc20;
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function depositsOf(uint256 pid, address account)
        external
        view
        returns (uint256[] memory)
    {
        EnumerableSet.UintSet storage depositSet = _deposits[pid][account];
        uint256[] memory tokenIds = new uint256[](depositSet.length());

        for (uint256 i; i < depositSet.length(); i++)
            tokenIds[i] = depositSet.at(i);

        return tokenIds;
    }

    function GetNFTsForAddress(
        address _owner,
        address _nftAddress,
        uint256 _tokenIdFrom,
        uint256 _tokenIdTo,
        uint256 _maxNfts
    ) external view returns (uint256[] memory) {
        uint256 selectedTokenIds = 0;
        uint256[] memory selectedTokenIdsList = new uint256[](_maxNfts);

        IERC721 nft = IERC721(_nftAddress);

        for (uint256 i = _tokenIdFrom; i <= _tokenIdTo; i++) {
            try nft.ownerOf(i) returns (address owner) {
                if (owner == _owner) {
                    selectedTokenIdsList[selectedTokenIds] = i;
                    selectedTokenIds++;
                    if (selectedTokenIds >= _maxNfts) break;
                }
            } catch {}
        }

        return selectedTokenIdsList;
    }

    // get a list of token ids to check they belong to an address or not
    // return list of token ids that belong to this address
    function GetNFTsForAddress(
        address _owner,
        address _nftAddress,
        uint256[] memory _tokenIds,
        uint256 _maxNfts
    ) external view returns (uint256[] memory) {
        uint256 selectedTokenIds = 0;
        uint256[] memory selectedTokenIdsList = new uint256[](_maxNfts);

        IERC721 nft = IERC721(_nftAddress);

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            try nft.ownerOf(_tokenIds[i]) returns (address owner) {
                if (owner == _owner) {
                    selectedTokenIdsList[selectedTokenIds] = _tokenIds[i];
                    selectedTokenIds++;
                    if (selectedTokenIds >= _maxNfts) break;
                }
            } catch {}
        }

        return selectedTokenIdsList;
    }

    function findRate(uint256 pid, uint256 tokenId)
        public
        view
        returns (uint256 rate)
    {
        uint256 rarity = tokenRarity[pid][tokenId];
        uint256 perDay = rewardRate[pid][rarity];

        // 6000 blocks per day, perDay / 6000 = reward per block

        rate = (perDay * 1e18) / 6000;
        return rate;
    }

    function pendingRewardToken(
        uint256 pid,
        address account,
        uint256[] memory tokenIds
    ) public view returns (uint256[] memory rewards) {
        rewards = new uint256[](tokenIds.length);

        for (uint256 i; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 rate = findRate(pid, tokenId);
            rewards[i] =
                rate *
                (_deposits[pid][account].contains(tokenId) ? 1 : 0) *
                (Math.min(block.number, EXPIRATION[pid]) -
                    depositBlocks[pid][account][tokenId]);
        }
    }

    function claimRewards(uint256 pid, uint256[] calldata tokenIds)
        public
        whenNotPaused
    {
        require(pid < pidsLen, "invalid pid");
        uint256 reward;
        uint256 curblock = Math.min(block.number, EXPIRATION[pid]);

        uint256[] memory rewards = pendingRewardToken(
            pid,
            msg.sender,
            tokenIds
        );

        for (uint256 i; i < tokenIds.length; i++) {
            reward += rewards[i];
            depositBlocks[pid][msg.sender][tokenIds[i]] = curblock;
        }

        if (reward > 0) erc20.whitelist_mint(msg.sender, reward);
    }

    struct Box {
        uint256 pid;
        uint256[] tokenIds;
    }

    function depositInManyPids(Box[] calldata __) external whenNotPaused {
        for (uint256 i = 0; i < __.length; i++)
            depositMany(__[i].pid, __[i].tokenIds);
    }

    function withdrawInManyPids(Box[] calldata __) external whenNotPaused {
        for (uint256 i = 0; i < __.length; i++)
            withdrawMany(__[i].pid, __[i].tokenIds);
    }

    function depositMany(uint256 pid, uint256[] calldata tokenIds)
        public
        whenNotPaused
    {
        require(pid < pidsLen, "invalid pid");

        claimRewards(pid, tokenIds);

        for (uint256 i; i < tokenIds.length; i++) {
            depositToken[pid].safeTransferFrom(
                msg.sender,
                address(this),
                tokenIds[i],
                ""
            );
            _deposits[pid][msg.sender].add(tokenIds[i]);
        }
    }

    function withdrawMany(uint256 pid, uint256[] calldata tokenIds)
        public
        whenNotPaused
    {
        require(pid < pidsLen, "invalid pid");
        claimRewards(pid, tokenIds);

        for (uint256 i; i < tokenIds.length; i++) {
            require(
                _deposits[pid][msg.sender].contains(tokenIds[i]),
                "Token not deposited"
            );

            _deposits[pid][msg.sender].remove(tokenIds[i]);

            depositToken[pid].safeTransferFrom(
                address(this),
                msg.sender,
                tokenIds[i],
                ""
            );
        }
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function paused() public view override returns (bool) {
        if (msg.sender == owner()) return false;

        return paused();
    }
}
