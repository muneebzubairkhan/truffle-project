// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

// todo add weight for merged penguins
// done: depositMany nfts

// Have fun reading it. Hopefully it's bug-free. God bless.

/// @title Farming service for pool tokens
/// @author BP
/// @notice You can use this contract to deposit pool tokens and get rewards
/// @dev Admin can add a new Pool, users can deposit pool tokens, harvestReward, withdraw pool tokens
contract NftStaking is Ownable, IERC721Receiver {
    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many pool tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        uint256 reward; // Reward to be given to user
        //
        // We do some fancy math here. Basically, any point in time, the amount of REWARD_TOKENs
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accRewardTokenPerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws pool tokens to a pool. Here's what happens:
        //   1. The pool's `accRewardTokenPerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }

    // Info of each pool.
    struct PoolInfo {
        IERC721 poolToken; // Address of pool token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. REWARD_TOKENs to distribute per block.
        uint256 lastRewardBlock; // Last block number that REWARD_TOKENs distribution occurs.
        uint256 accRewardTokenPerShare; // Accumulated REWARD_TOKENs per share, times 1e12. See below.
    }

    /// @dev The REWARD_TOKEN TOKEN!
    IERC20 public rewardToken =
        IERC20(0xEf44f26371BF874b5D4c8b49914af169336bc957);

    /// @dev Block number when bonus REWARD_TOKEN period ends.
    uint256 public bonusEndBlock = 0;

    /// @notice REWARD_TOKEN tokens created per block.
    /// @dev its equal to approx 1000 reward tokens per day
    uint256 public rewardPerBlock = 0.15 ether;

    // Bonus muliplier for early rewardToken makers.
    uint256 private constant BONUS_MULTIPLIER = 10;

    /// @dev Info of each pool.
    PoolInfo[] public poolInfo;

    /// @dev Info of each user that stakes pool tokens.
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    mapping(IERC721 => mapping(uint256 => address)) public nftOwnerOf;

    /// @dev Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint = 0;

    /// @dev The block number when REWARD_TOKEN mining starts.
    uint256 public startBlock = 0;

    /// @dev The block number when REWARD_TOKEN mining ends.
    uint256 public endBlock = 0;

    /// @notice user can get reward and unstake after this time only.
    /// @dev No unstake froze time initially, if needed it can be added and informed to community.
    uint256 public usersCanUnstakeAtTime = 0 seconds;

    /// @dev No reward froze time initially, if needed it can be added and informed to community.
    uint256 public usersCanHarvestAtTime = 0 seconds;

    mapping(IERC721 => bool) private uniqueTokenInPool;

    // penguin weights, merged penguins gets more reward than ordinary penguin
    // todo try test uint8 vs uint256 in gas vs bool, vs read gas in tx
    mapping(uint256 => uint8) private penguinsWeights;

    function setPenguinsWeights(
        uint256[] calldata _tokenIds,
        uint8[] calldata _weights
    ) external onlyOwner {
        for (uint256 i; i < _tokenIds.length; i++)
            penguinsWeights[_tokenIds[i]] = _weights[i];
    }

    /// @dev when some one deposits pool tokens to contract
    event Deposit(
        address indexed user,
        uint256 indexed pid,
        uint256[] tokenIds
    );

    event Deposit(address indexed user, uint256 indexed pid, uint256 tokenId);

    /// @dev when some one withdraws pool tokens from contract
    event Withdraw(
        address indexed user,
        uint256 indexed pid,
        uint256[] tokenIds
    );

    event Withdraw(address indexed user, uint256 indexed pid, uint256 tokenIds);

    /// @dev when some one harvests reward tokens from contract
    event Harvest(address indexed user, uint256 indexed pid, uint256 amount);

    constructor() {
        add(10000, IERC721(0x4BD39d433bb884e28AA49402ED33479d0Cf720A1), true);
    }

    /// @notice gets total number of pools
    /// @return total number of pools
    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

    /// @notice This adds a new pool. Can only be called by the owner.
    /// @dev Only adds unique pool token
    /// @param _allocPoint The weight of this pool. The more it is the more percentage of reward per block it will get for its users with respect to other pools. But the total reward per block remains same.
    /// @param _poolToken The Liquidity Pool Token of this pool
    /// @param _withUpdate if true then it updates the reward tokens to be given for each of the tokens staked
    function add(
        uint256 _allocPoint,
        IERC721 _poolToken,
        bool _withUpdate
    ) public onlyOwner {
        require(!uniqueTokenInPool[_poolToken], "Token already added");
        uniqueTokenInPool[_poolToken] = true;

        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 lastRewardBlock = block.number > startBlock
            ? block.number
            : startBlock;
        totalAllocPoint = totalAllocPoint + _allocPoint;
        poolInfo.push(
            PoolInfo({
                poolToken: _poolToken,
                allocPoint: _allocPoint,
                lastRewardBlock: lastRewardBlock,
                accRewardTokenPerShare: 0
            })
        );
    }

    /// @notice Update the given pool's REWARD_TOKEN pool weight. Can only be called by the owner.
    /// @dev it can change alloc point (weight of pool) with repect to other pools
    /// @param _pid pool id
    /// @param _allocPoint The weight of this pool. The more it is the more percentage of reward per block it will get for its users with respect to other pools. But the total reward per block remains same.
    /// @param _withUpdate if true then it updates the reward tokens to be given for each of the tokens staked
    function setAllocPoint(
        uint256 _pid,
        uint256 _allocPoint,
        bool _withUpdate
    ) external onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        totalAllocPoint =
            totalAllocPoint -
            (poolInfo[_pid].allocPoint + _allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
    }

    // Return number of blocks between _from to _to block which are applicable for reward tokens. if multiplier returns 10 blocks then 10 * reward per block = 50 coins to be given as reward. equally to community. with repect to pool weight.
    function getMultiplier(uint256 _from, uint256 _to)
        internal
        view
        returns (uint256)
    {
        uint256 from = _from;
        uint256 to = _to;
        if (endBlock < from) from = endBlock;
        if (endBlock < to) to = endBlock;
        if (to < startBlock) return 0;
        if (from < startBlock && startBlock < to) from = startBlock;

        if (to <= bonusEndBlock) {
            return (to - from) * (BONUS_MULTIPLIER);
        } else if (from >= bonusEndBlock) {
            return to - from;
        } else {
            return
                (bonusEndBlock - from) *
                BONUS_MULTIPLIER +
                (to - bonusEndBlock);
        }
    }

    // get pid from token address
    function getPidOfToken(address _token) external view returns (uint256) {
        for (uint256 index = 0; index < poolInfo.length; index++) {
            if (address(poolInfo[index].poolToken) == _token) {
                return index;
            }
        }

        return type(uint256).max;
    }

    /// @notice get reward tokens to show on UI
    /// @dev calculates reward tokens of a user with repect to pool id
    /// @param _pid the pool id
    /// @param _user the user who is calls this function
    /// @return pending reward tokens of a user
    function pendingRewardToken(uint256 _pid, address _user)
        external
        view
        returns (uint256)
    {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accRewardTokenPerShare = pool.accRewardTokenPerShare;
        uint256 poolSupply = pool.poolToken.balanceOf(address(this));
        if (block.number > pool.lastRewardBlock && poolSupply != 0) {
            uint256 multiplier = getMultiplier(
                pool.lastRewardBlock,
                block.number
            );
            uint256 rewardTokenReward = (multiplier *
                (rewardPerBlock) *
                (pool.allocPoint)) / (totalAllocPoint);
            accRewardTokenPerShare =
                accRewardTokenPerShare +
                ((rewardTokenReward * 1e12) / (poolSupply));
        }
        return
            user.reward +
            (((user.amount * accRewardTokenPerShare) / 1e12) -
                (user.rewardDebt));
    }

    /// @notice Update reward vairables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) updatePool(pid);
    }

    uint256 private stakedTokens = 0;

    /// @notice Update reward variables of the given pool to be up-to-date.
    /// @param _pid the pool id
    function updatePool(uint256 _pid) public {
        if (stakedTokens == 0) configTheEndRewardBlock(); // to stop making reward when reward tokens are empty in NftStaking

        PoolInfo storage pool = poolInfo[_pid];

        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        uint256 poolSupply = pool.poolToken.balanceOf(address(this));
        if (poolSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }

        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 rewardTokenReward = (multiplier *
            (rewardPerBlock) *
            (pool.allocPoint)) / (totalAllocPoint);
        pool.accRewardTokenPerShare =
            pool.accRewardTokenPerShare +
            ((rewardTokenReward * (1e12)) / (poolSupply));
        pool.lastRewardBlock = block.number;
    }

    /// @notice deposit tokens to get rewards
    /// @dev deposit pool tokens to NftStaking for reward tokens allocation.
    /// @param _pid pool id
    /// @param _tokenId how many tokens you want to stake
    function deposit(uint256 _pid, uint256 _tokenId) public {
        uint256 _amount = 1;
        _amount += penguinsWeights[_tokenId];
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        nftOwnerOf[pool.poolToken][_tokenId] = msg.sender;

        updatePool(_pid);

        uint256 pending = (user.amount * (pool.accRewardTokenPerShare)) /
            1e12 -
            user.rewardDebt;
        user.reward += pending;

        stakedTokens += 1; // deposit single token
        user.amount = user.amount + (_amount);
        user.rewardDebt =
            (user.amount * (pool.accRewardTokenPerShare)) /
            (1e12);
        // addToList(msg.sender, _tokenId);
        pool.poolToken.transferFrom(
            address(msg.sender),
            address(this),
            _tokenId
        );
        emit Deposit(msg.sender, _pid, _tokenId);
    }

    function depositMany(uint256 _pid, uint256[] memory _tokenIds) public {
        require(_tokenIds.length > 0, "minimum 1 tokenId");

        uint256 _amount = _tokenIds.length;

        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            nftOwnerOf[pool.poolToken][_tokenIds[i]] = msg.sender;
            _amount += penguinsWeights[_tokenIds[i]];
        }

        updatePool(_pid);

        uint256 pending = (user.amount * (pool.accRewardTokenPerShare)) /
            1e12 -
            user.rewardDebt;
        user.reward += pending;

        stakedTokens += _tokenIds.length;
        user.amount = user.amount + _amount;
        user.rewardDebt =
            (user.amount * (pool.accRewardTokenPerShare)) /
            (1e12);
        // addToList(msg.sender, _tokenId); // only for ui not for computation

        for (uint256 i = 0; i < _tokenIds.length; i++)
            pool.poolToken.transferFrom(
                address(msg.sender),
                address(this),
                _tokenIds[i]
            );
        emit Deposit(msg.sender, _pid, _tokenIds);
    }

    /// @notice get the tokens back from BardFarm
    /// @dev withdraw or unstake pool tokens from BidFarm
    /// @param _pid pool id
    /// @param  _tokenId how many pool tokens you want to unstake
    function withdraw(uint256 _pid, uint256 _tokenId) public {
        uint256 _amount = 1;
        _amount += penguinsWeights[_tokenId];
        require(
            block.timestamp > usersCanUnstakeAtTime,
            "Can not withdraw/unstake at this time."
        );
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        require(
            nftOwnerOf[pool.poolToken][_tokenId] == msg.sender,
            "you are not owner"
        );

        nftOwnerOf[pool.poolToken][_tokenId] = address(0);
        require(
            user.amount >= _amount,
            "You do not have enough pool tokens staked."
        );
        updatePool(_pid);
        uint256 pending = (user.amount * (pool.accRewardTokenPerShare)) /
            1e12 -
            user.rewardDebt;

        user.reward += pending;

        stakedTokens -= 1; // withdraw single token
        user.amount = user.amount - (_amount);
        user.rewardDebt =
            (user.amount * (pool.accRewardTokenPerShare)) /
            (1e12);

        // harvest reward
        require(
            block.timestamp > usersCanHarvestAtTime,
            "Can not harvest at this time."
        );
        pending =
            (user.amount * pool.accRewardTokenPerShare) /
            1e12 -
            user.rewardDebt;

        user.reward += pending;
        uint256 rewardToGiveNow = user.reward;
        user.reward = 0;

        user.rewardDebt = (user.amount * pool.accRewardTokenPerShare) / 1e12;

        rewardToken.transfer(msg.sender, rewardToGiveNow);
        pool.poolToken.transferFrom(
            address(this),
            address(msg.sender),
            _tokenId
        );

        emit Harvest(msg.sender, _pid, pending);
        emit Withdraw(msg.sender, _pid, _tokenId);
    }

    function withdrawMany(uint256 _pid, uint256[] memory _tokenIds) public {
        require(_tokenIds.length > 0, "minimum 1 tokenId");
        uint256 _amount = _tokenIds.length;
        require(
            block.timestamp > usersCanUnstakeAtTime,
            "Can not withdraw/unstake at this time."
        );
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            require(
                nftOwnerOf[pool.poolToken][_tokenIds[i]] == msg.sender,
                "you are not owner"
            );
            nftOwnerOf[pool.poolToken][_tokenIds[i]] = address(0);
            _amount += penguinsWeights[_tokenIds[i]];
        }

        updatePool(_pid);
        uint256 pending = (user.amount * (pool.accRewardTokenPerShare)) /
            1e12 -
            user.rewardDebt;

        user.reward += pending;

        stakedTokens -= _tokenIds.length;
        user.amount = user.amount - _amount;
        user.rewardDebt = (user.amount * (pool.accRewardTokenPerShare)) / 1e12;

        // harvest
        require(
            block.timestamp > usersCanHarvestAtTime,
            "Can not harvest at this time."
        );
        pending =
            (user.amount * pool.accRewardTokenPerShare) /
            1e12 -
            user.rewardDebt;

        user.reward += pending;
        uint256 rewardToGiveNow = user.reward;
        user.reward = 0;

        user.rewardDebt = (user.amount * (pool.accRewardTokenPerShare)) / 1e12;

        rewardToken.transfer(msg.sender, rewardToGiveNow);

        for (uint256 i = 0; i < _tokenIds.length; i++)
            pool.poolToken.transferFrom(
                address(this),
                address(msg.sender),
                _tokenIds[i]
            );

        emit Harvest(msg.sender, _pid, pending);
        emit Withdraw(msg.sender, _pid, _tokenIds);
    }

    function depositWithdrawMany(
        uint256 _pidD,
        uint256[] memory _tokenIdsD,
        uint256 _pidW,
        uint256[] memory _tokenIdsW
    ) external {
        depositMany(_pidD, _tokenIdsD);
        withdrawMany(_pidW, _tokenIdsW);
    }

    function depositManyDifferentTokens(
        uint256 _pidD1,
        uint256[] memory _tokenIdsD1,
        uint256 _pidD2,
        uint256[] memory _tokenIdsD2,
        uint256 _pidD3,
        uint256[] memory _tokenIdsD3,
        uint256 _pidD4,
        uint256[] memory _tokenIdsD4,
        uint256 _pidD5,
        uint256[] memory _tokenIdsD5
    ) external {
        if (_tokenIdsD1.length > 0) depositMany(_pidD1, _tokenIdsD1);
        if (_tokenIdsD2.length > 0) depositMany(_pidD2, _tokenIdsD2);
        if (_tokenIdsD3.length > 0) depositMany(_pidD3, _tokenIdsD3);
        if (_tokenIdsD4.length > 0) depositMany(_pidD4, _tokenIdsD4);
        if (_tokenIdsD5.length > 0) depositMany(_pidD5, _tokenIdsD5);
    }

    struct Box {
        uint256 _pid1;
        uint256[] _tokenIds1;
        uint256 _pid2;
        uint256[] _tokenIds2;
        uint256 _pid3;
        uint256[] _tokenIds3;
        uint256 _pid4;
        uint256[] _tokenIds4;
        uint256 _pid5;
        uint256[] _tokenIds5;
        uint256 _pidD1;
        uint256[] _tokenIdsD1;
        uint256 _pidD2;
        uint256[] _tokenIdsD2;
        uint256 _pidD3;
        uint256[] _tokenIdsD3;
        uint256 _pidD4;
        uint256[] _tokenIdsD4;
        uint256 _pidD5;
        uint256[] _tokenIdsD5;
    }

    function depositWithdrawManyDifferentTokens(Box memory __) external {
        if (__._tokenIdsD1.length > 0) depositMany(__._pidD1, __._tokenIdsD1);
        if (__._tokenIdsD2.length > 0) depositMany(__._pidD2, __._tokenIdsD2);
        if (__._tokenIdsD3.length > 0) depositMany(__._pidD3, __._tokenIdsD3);
        if (__._tokenIdsD4.length > 0) depositMany(__._pidD4, __._tokenIdsD4);
        if (__._tokenIdsD5.length > 0) depositMany(__._pidD5, __._tokenIdsD5);

        if (__._tokenIds1.length > 0) withdrawMany(__._pid1, __._tokenIds1);
        if (__._tokenIds2.length > 0) withdrawMany(__._pid2, __._tokenIds2);
        if (__._tokenIds3.length > 0) withdrawMany(__._pid3, __._tokenIds3);
        if (__._tokenIds4.length > 0) withdrawMany(__._pid4, __._tokenIds4);
        if (__._tokenIds5.length > 0) withdrawMany(__._pid5, __._tokenIds5);
    }

    function withdrawManyDifferentTokens(
        uint256 _pid1,
        uint256[] memory _tokenIds1,
        uint256 _pid2,
        uint256[] memory _tokenIds2,
        uint256 _pid3,
        uint256[] memory _tokenIds3,
        uint256 _pid4,
        uint256[] memory _tokenIds4,
        uint256 _pid5,
        uint256[] memory _tokenIds5
    ) external {
        if (_tokenIds1.length > 0) withdrawMany(_pid1, _tokenIds1);
        if (_tokenIds2.length > 0) withdrawMany(_pid2, _tokenIds2);
        if (_tokenIds3.length > 0) withdrawMany(_pid3, _tokenIds3);
        if (_tokenIds4.length > 0) withdrawMany(_pid4, _tokenIds4);
        if (_tokenIds5.length > 0) withdrawMany(_pid5, _tokenIds5);
    }

    /// @notice harvest reward tokens from BardFarm
    /// @dev harvest reward tokens from BidFarm and update pool variables
    /// @param _pid pool id
    function harvest(uint256 _pid) external {
        require(
            block.timestamp > usersCanHarvestAtTime,
            "Can not harvest at this time."
        );
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid);
        uint256 pending = (user.amount * (pool.accRewardTokenPerShare)) /
            1e12 -
            user.rewardDebt;

        user.reward += pending;
        uint256 rewardToGiveNow = user.reward;
        user.reward = 0;

        user.rewardDebt =
            (user.amount * (pool.accRewardTokenPerShare)) /
            (1e12);

        rewardToken.transfer(msg.sender, rewardToGiveNow);
        emit Harvest(msg.sender, _pid, pending);
    }

    function configTheEndRewardBlock() internal {
        endBlock =
            block.number +
            ((rewardToken.balanceOf(address(this)) / (rewardPerBlock)));
    }

    /// @notice owner puts reward tokens in contract
    /// @dev owner can add reward token to contract so that it can be distributed to users
    /// @param _amount amount of reward tokens
    function addRewardTokensToContract(uint256 _amount) external onlyOwner {
        uint256 rewardEndsInBlocks = _amount / (rewardPerBlock);

        uint256 lastEndBlock = endBlock == 0 ? block.number : endBlock;
        endBlock = lastEndBlock + rewardEndsInBlocks;

        require(
            rewardToken.transferFrom(msg.sender, address(this), _amount),
            "Error in adding reward tokens in contract."
        );
        emit EndRewardBlockChanged(endBlock);
    }

    event AddedRewardTokensToContract(uint256 amount);

    /// @notice owner takes out any tokens in contract
    /// @dev owner can take out any locked tokens in contract
    /// @param _token the token owner wants to take out from contract
    /// @param _amount amount of tokens
    function withdrawAnyTokenFromContract(IERC20 _token, uint256 _amount)
        external
        onlyOwner
    {
        _token.transfer(msg.sender, _amount);
        emit OwnerWithdraw(_token, _amount);
    }

    event OwnerWithdraw(IERC20 token, uint256 amount);

    /// @notice owner can change reward token
    /// @dev owner can set reward token
    /// @param _rewardToken the token in which rewards are given
    function setRewardToken(IERC20 _rewardToken) external onlyOwner {
        rewardToken = _rewardToken;
        emit RewardTokenChanged(_rewardToken);
    }

    /// @dev When reward token changes
    /// @param rewardToken the token in which rewards are given
    event RewardTokenChanged(IERC20 rewardToken);

    /// @notice owner can change unstake frozen time
    /// @dev owner can set unstake frozen time
    /// @param _usersCanUnstakeAtTime the block at which user can unstake
    function setUnstakeFrozenTime(uint256 _usersCanUnstakeAtTime)
        external
        onlyOwner
    {
        usersCanUnstakeAtTime = _usersCanUnstakeAtTime;
        emit UnstakeFrozenTimeChanged(_usersCanUnstakeAtTime);
    }

    /// @dev When Unstake Frozen Time Changed
    /// @param usersCanUnstakeAtTime after this time users can unstake
    event UnstakeFrozenTimeChanged(uint256 usersCanUnstakeAtTime);

    /// @notice owner can change reward frozen time
    /// @dev owner can set reward frozen time
    /// @param _usersCanHarvestAtTime the block at which user can harvest reward
    function setRewardFrozenTime(uint256 _usersCanHarvestAtTime)
        external
        onlyOwner
    {
        usersCanHarvestAtTime = _usersCanHarvestAtTime;
        emit RewardFrozenTimeChanged(_usersCanHarvestAtTime);
    }

    /// @dev When Reward Frozen Time Changed
    /// @param usersCanHarvestAtTime after this time users can harvest
    event RewardFrozenTimeChanged(uint256 usersCanHarvestAtTime);

    /// @notice owner can change reward token per block
    /// @dev owner can set reward token per block
    /// @param _rewardPerBlock rewards distributed per block to community or users
    function setRewardTokenPerBlock(uint256 _rewardPerBlock)
        external
        onlyOwner
    {
        rewardPerBlock = _rewardPerBlock;
        emit RewardTokenPerBlockChanged(_rewardPerBlock);
    }

    /// @dev When Reward Token Per Block is changed
    /// @param rewardPerBlock reward tokens made in each block
    event RewardTokenPerBlockChanged(uint256 rewardPerBlock);

    /// @notice owner can change start reward block
    /// @dev owner can set start reward block
    /// @param _startBlock the block at which reward token distribution starts
    function setStartRewardBlock(uint256 _startBlock) external onlyOwner {
        require(
            _startBlock <= endBlock,
            "Start block must be less or equal to end reward block."
        );
        startBlock = _startBlock;
        emit StartRewardBlockChanged(_startBlock);
    }

    /// @dev Start Reward Block Changed
    /// @param startRewardBlock block when rewards are distributed per block to community or users
    event StartRewardBlockChanged(uint256 startRewardBlock);

    /// @notice owner can change end reward block
    /// @dev owner can set end reward block
    /// @param _endBlock the block at which reward token distribution ends
    function setEndRewardBlock(uint256 _endBlock) external onlyOwner {
        require(
            startBlock <= _endBlock,
            "End reward block must be greater or equal to start reward block."
        );
        endBlock = _endBlock;
        emit EndRewardBlockChanged(_endBlock);
    }

    /// @dev End Reward Block Changed
    /// @param endBlock block when rewards are ended to be distributed per block to community or users
    event EndRewardBlockChanged(uint256 endBlock);

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
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

    // get from a list, got from events in penguins
    function GetNFTsStakedForAddress(
        address _owner,
        uint256 _pid,
        uint256[] memory _tokenIds,
        uint256 _maxNfts
    ) external view returns (uint256[] memory) {
        PoolInfo storage pool = poolInfo[_pid];

        uint256 selectedTokenIds = 0;
        uint256[] memory selectedTokenIdsList = new uint256[](_maxNfts);

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            if (nftOwnerOf[pool.poolToken][_tokenIds[i]] == _owner) {
                selectedTokenIdsList[selectedTokenIds] = _tokenIds[i];
                selectedTokenIds++;
                if (selectedTokenIds >= _maxNfts) break;
            }
        }

        return selectedTokenIdsList;
    }

    function GetNFTsStakedForAddress(
        address _owner,
        uint256 _pid,
        uint256 _tokenIdFrom,
        uint256 _tokenIdTo,
        uint256 _maxNfts
    ) external view returns (uint256[] memory) {
        PoolInfo storage pool = poolInfo[_pid];

        uint256 selectedTokenIds = 0;
        uint256[] memory selectedTokenIdsList = new uint256[](_maxNfts);

        for (uint256 i = _tokenIdFrom; i <= _tokenIdTo; i++) {
            if (nftOwnerOf[pool.poolToken][i] == _owner) {
                selectedTokenIdsList[selectedTokenIds] = i;
                selectedTokenIds++;
                if (selectedTokenIds >= _maxNfts) break;
            }
        }

        return selectedTokenIdsList;
    }
}
