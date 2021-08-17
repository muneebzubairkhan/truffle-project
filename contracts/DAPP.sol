pragma solidity ^0.8.4;

contract DAPP {
    function setItemDetail(string memory _itemID) public {
        require(
            msg.sender == admin,
            "Only  Admin 0x230e03d56C51E41ca256b6BB106AEd57AACC36b4"
        );
        ItemDetail storage item = ItemDetails[_itemID];
        item.itemQR = _itemID;
        item.owner = msg.sender;
    }

    function settransactionHash(
        string memory _itemID,
        string memory _transactionHash
    ) public {
        require(
            msg.sender == admin,
            "Only  Admin  0x230e03d56C51E41ca256b6BB106AEd57AACC36b4"
        );
        ItemDetail storage item = itemDetail[_itemID];
        item.transactionHash = _transactionHash;
    }

    function getItemDetails(string memory _itemID)
        public
        view
        returns (
            string memory,
            address,
            string memory
        )
    {
        ItemDetail storage item = itemDetails[_itemID];
        return (item.itemQR, item.owner, item.transactionHash);
    }
}
