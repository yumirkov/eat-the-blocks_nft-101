// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.2;

contract ERC721 {
    mapping(address => uint256) internal _balances;
    mapping(uint256 => address) internal _owners;
    mapping(address => mapping(address => bool)) internal _operatorApprovals;
    mapping(uint256 => address) _tokenApprovals;

    constructor() {}

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    // Count all NFTs assigned to an owner
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "Address is zero");
        return _balances[_owner];
    }

    // Find the owner of an NFT
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _owners[_tokenId];
        require(owner != address(0), "TokenID does not exist");
        return owner;
    }

    // Transfers the ownership of an NFT from one address to another address
    // prettier-ignore
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public {
        transferFrom(_from, _to, _tokenId);
        require(_checkOnERC721Received(), "Receiver not implemented");
    }

    // Transfers the ownership of an NFT from one address to another address
    // prettier-ignore
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    // Transfer ownership of an NFT
    // prettier-ignore
    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        
        require(owner == _from, "From address is not the owner");
        require(_to != address(0), "To address is zero");
        require(
            msg.sender == owner // caller is the owner
            || getApproved(_tokenId) == msg.sender // caller is approved for particular token
            || isApprovedForAll(owner, msg.sender), // caller is approved for all collection
            "Msg.sender is not the owner or approved for a transfer"
        );

        approve(address(0), _tokenId);

        _balances[_from] -= 1;
        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    // Change or reaffirm the approved address for an NFT
    function approve(address _approved, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "Msg.sender is not the owner or an approved operator"
        );
        _tokenApprovals[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    // Enable or disable approval for a third party ("operator") to manage all of `msg.sender`'s assets
    function setApprovalForAll(address _operator, bool _approved) public {
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    // Get the approved address for a single NFT
    function getApproved(uint256 _tokenId) public view returns (address) {
        require(ownerOf(_tokenId) != address(0), "TokenID does not exist");
        return _tokenApprovals[_tokenId];
    }

    // Query if an address is an authorized operator for another address
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    // Overdimplified
    function _checkOnERC721Received() private pure returns (bool) {
        return true;
    }

    // EIP165: Query if a contract implements another interface
    function supportsInterface(bytes4 interfaceId) public pure virtual returns (bool) {
        return interfaceId == 0x80ac58cd;
    }
}
