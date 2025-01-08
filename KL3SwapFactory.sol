// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./KL3SwapPair.sol";

contract KL3SwapFactory {
    address public feeTo;
    address public feeToSetter;
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) {
        feeToSetter = _feeToSetter;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, "KL3Swap: IDENTICAL_ADDRESSES");
        require(getPair[tokenA][tokenB] == address(0), "KL3Swap: PAIR_EXISTS");
        bytes memory bytecode = type(KL3SwapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(tokenA, tokenB));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        getPair[tokenA][tokenB] = pair;
        allPairs.push(pair);
        emit PairCreated(tokenA, tokenB, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "KL3Swap: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "KL3Swap: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
