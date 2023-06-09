// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "Erc1155/IERC1155Receiver.sol";
import "Erc1155/Erc1155Storage.sol";

interface IERC1155 {
    function balanceOf(address _owner, uint256 _id)
        external
        view
        returns (uint256);

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
        external
        view
        returns (uint256[] memory);

    function setApprovalForAll(address _operator, bool _approved) external;

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external;

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external;

    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _value
    );
    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );
    event URI(string _value, uint256 indexed _id);
}

contract Erc1155 is IERC1155, IERC1155Receiver, Erc1155Storage {
    string public name;
    string public symbol;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) {
        require(
            bytes(_name).length != 0 &&
                bytes(_symbol).length != 0 &&
                bytes(_symbol).length != 0,
            "Erc1155: fill all the fields"
        );
        name = _name;
        symbol = _symbol;
        setBaseURI(_baseURI);
    }

    mapping(uint256 => mapping(address => uint256)) private _balances;
    mapping(address => mapping(address => bool)) private _operatorAvailability;
    mapping(uint256 => uint256) public totalSupply;
    mapping(uint256 => address) private tokenCreater;

    function balanceOf(address _owner, uint256 _id)
        public
        view
        returns (uint256)
    {
        require(_owner != address(0), "Erc1155:zero is not a valid address");
        return _balances[_id][_owner];
    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids)
        external
        view
        returns (uint256[] memory)
    {
        require(
            _owners.length == _ids.length,
            "Erc1155: accounts and ids length mismatch"
        );
        uint256[] memory batachBalance = new uint256[](_owners.length);
        for (uint256 i = 0; i < _ids.length; i++) {
            batachBalance[i] = balanceOf(_owners[i], _ids[i]);
        }
        return batachBalance;
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(_operator != msg.sender, "Erc1155: setting approval for self");
        _operatorAvailability[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator)
        public
        view
        returns (bool)
    {
        return _operatorAvailability[_owner][_operator];
    }

    function _safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) private {
        if (_to.code.length == 0) {
            require(
                IERC1155Receiver(_to).onERC1155Received(
                    msg.sender,
                    _from,
                    _id,
                    _value,
                    _data
                ) == IERC1155Receiver.onERC1155Received.selector,
                "Erc1155:unsafe recipient"
            );
        }

        _balances[_id][_from] -= _value;
        _balances[_id][_to] += _value;
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external {
        require(_from != address(0), "Erc1155: transfer to the zero address");
        require(_to != address(0), "Erc1155: transfer to the zero address");
        require(
            isApprovedForAll(_from, msg.sender) || _from == msg.sender,
            "Erc1155: you are not allowed"
        );

        require(_value != 0, "Erc1155: enter more than zero");

        require(
            _balances[_id][_from] >= _value,
            "Erc1155:Insufficient balance"
        );
        _safeTransferFrom(_from, _to, _id, _value, _data);
        emit TransferSingle(msg.sender, _from, _to, _id, _value);
    }

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external {
        require(_from != address(0), "Erc1155: transfer to the zero address");
        require(_to != address(0), "Erc1155: transfer to the zero address");
        require(
            _ids.length == _values.length,
            "Erc1155: accounts and ids length mismatch"
        );

        for (uint256 i = 0; i < _values.length; i++) {
            require(
                _balances[_ids[i]][_from] >= _values[i],
                "Erc1155: insufficient balance"
            );
            _safeTransferFrom(_from, _to, _ids[i], _values[i], _data);
        }
    }

    function _mint(
        address _to,
        uint256 _id,
        uint256 _amount
    ) private {
        setTokenURI(_id);
        tokenCreater[_id] = msg.sender;
        totalSupply[_id] += _amount;
        _balances[_id][_to] += _amount;

        emit URI(tokenURI(_id), _id);
    }

    function mint(
        address _to,
        uint256 _id,
        uint256 _amount
    ) external {
        require(
            tokenCreater[_id] == address(0) || tokenCreater[_id] == msg.sender,
            "Erc1155:invalid owner"
        );
        require(_to != address(0), "Erc1155: mint to the zero address");
        require(_amount != 0, "Erc1155: enter more than zero ");
        _mint(_to, _id, _amount);
        emit TransferSingle(msg.sender, address(0), _to, _id, _amount);
    }

    function mintBatch(
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _amounts
    ) external {
        require(_to != address(0), "Erc1155: mint to the zero address");
        require(
            _ids.length == _amounts.length,
            "Erc1155: accounts and ids length mismatch"
        );

        for (uint256 i = 0; i < _ids.length; i++) {
            require(
                tokenCreater[_ids[i]] == address(0) ||
                    tokenCreater[_ids[i]] == msg.sender,
                "Erc1155:invalid owner"
            );
            _mint(_to, _ids[i], _amounts[i]);
        }

        emit TransferBatch(msg.sender, address(0), _to, _ids, _amounts);
    }

    function _burn(
        address _account,
        uint256 _id,
        uint256 _amount
    ) private {
        totalSupply[_id] -= _amount;
        _balances[_id][_account] -= _amount;
    }

    function burn(
        address _account,
        uint256 _id,
        uint256 _amount
    ) external {
        require(_account != address(0), "Erc1155: mint to the zero address");
        require(_amount != 0, "Erc1155: enter more than zero");
        require(
            _balances[_id][msg.sender] >= _amount,
            "Erc1155: Insufficient balance"
        );

        _burn(_account, _id, _amount);
        emit TransferSingle(msg.sender, _account, address(0), _id, _amount);
    }

    function burnBatch(
        address _account,
        uint256[] calldata _ids,
        uint256[] calldata _amounts
    ) public {
        require(
            _ids.length == _amounts.length,
            "Erc1155: accounts and ids length mismatch"
        );
        for (uint256 i = 0; i < _ids.length; i++) {
            require(
                _balances[_ids[i]][msg.sender] >= _amounts[i],
                "Erc1155: insufficient balance"
            );
            _burn(_account, _ids[i], _amounts[i]);
        }
        emit TransferBatch(msg.sender, _account, address(0), _ids, _amounts);
    }

    function getTokenURI(uint256 _id) external view returns (string memory) {
        return tokenURI(_id);
    }

    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) external pure returns (bytes4) {
        return
            bytes4(
                keccak256(
                    "onERC1155Received(address,address,uint256,uint256,bytes)"
                )
            );
    }
}
