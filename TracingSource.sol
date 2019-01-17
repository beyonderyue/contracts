pragma solidity ^0.5.2;

contract TracingSource {
    
    struct PathInfo {//路径信息
        uint prevBNumber;//上一个路径上链时的区块号
        uint onchainBNumber;//最近一次路径上链时的区块号 
        string details;//路径的详细信息
    }
    
    mapping (bytes32 => PathInfo) private sources;
    
    function storeInfo(string memory productcode, string memory details) public {
        bytes32 hashcode = sha256(abi.encodePacked(productcode));
        PathInfo memory info = sources[hashcode];
        info.prevBNumber = info.onchainBNumber;
        info.onchainBNumber = block.number;
        info.details = details;        
        sources[hashcode] = info;
    }
    
    function getInfo(string memory productcode) public view returns (uint, uint, string memory) {
        bytes32 hashcode = sha256(abi.encodePacked(productcode));
        return (sources[hashcode].prevBNumber, sources[hashcode].onchainBNumber, sources[hashcode].details);
    }
}