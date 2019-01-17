pragma solidity ^0.5.2;

import "./Ownable.sol";

contract ProofOfExistence3 is Ownable{

    struct NotarizedInfo {
        bool isNotarized;//是否公证过
        uint blockNum;//公证时的区块号
    }
    mapping (bytes32 => NotarizedInfo) private proofs;

    // 在合约状态中存储文档公证的证明
    function storeProof(bytes32 proof) private {
        NotarizedInfo memory info;
        info.isNotarized = true;
        info.blockNum = block.number;
        proofs[proof] = info;
    }

    // 计算和存储文档的证明
    function notarize(string memory document) onlyOwner public {
        bytes32 proof = proofFor(document);
        if (proofs[proof].isNotarized == false) {//如果已经公证过不再进行公证
            storeProof(proof);
        }
    }

    // 获取文档的哈希值
    function proofFor(string memory document) private pure returns (bytes32) {
        return sha256(abi.encodePacked(document));
    }

    // 检查文档是否被公证过
    function checkDocument(string memory document) public view returns (bool, uint) {
        bytes32 proof = proofFor(document);
        return hasProof(proof);
    }
    
    // 返回存储的公证信息
    function hasProof(bytes32 proof) internal view returns(bool, uint) {
        return (proofs[proof].isNotarized, proofs[proof].blockNum);
    }
}