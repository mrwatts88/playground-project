// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library HitchensUnorderedKeySetLib {

    struct Set {
        mapping(address => uint) keyPointers;
        address[] keyList;
    }

    function insert(Set storage self, address key) internal {
        require(key != address(0), "UnorderedKeySet(100) - Key cannot be 0x0");
        require(!exists(self, key), "UnorderedAddressSet(101) - Address (key) already exists in the set.");
        self.keyList.push(key);
        self.keyPointers[key] = self.keyList.length - 1;
    }

    function remove(Set storage self, address key) internal {
        require(exists(self, key), "UnorderedKeySet(102) - Address (key) does not exist in the set.");
        address keyToMove = self.keyList[count(self)-1];
        uint rowToReplace = self.keyPointers[key];
        self.keyPointers[keyToMove] = rowToReplace;
        self.keyList[rowToReplace] = keyToMove;
        delete self.keyPointers[key];
        self.keyList.pop();
    }

    function count(Set storage self) internal view returns(uint) {
        return(self.keyList.length);
    }

    function exists(Set storage self, address key) internal view returns(bool) {
        if(self.keyList.length == 0) return false;
        return self.keyList[self.keyPointers[key]] == key;
    }

    function keyAtIndex(Set storage self, uint index) internal view returns(address) {
        return self.keyList[index];
    }
}

contract HitchensUnorderedKeySet {

    using HitchensUnorderedKeySetLib for HitchensUnorderedKeySetLib.Set;
    HitchensUnorderedKeySetLib.Set set;

    event LogUpdate(address sender, string action, address key);

    function exists(address key) public view returns(bool) {
        return set.exists(key);
    }

    function insert(address key) public {
        set.insert(key);
        emit LogUpdate(msg.sender, "insert", key);
    }

    function remove(address key) public {
        set.remove(key);
        emit LogUpdate(msg.sender, "remove", key);
    }

    function count() public view returns(uint) {
        return set.count();
    }

    function keyAtIndex(uint index) public view returns(address) {
        return set.keyAtIndex(index);
    }
}
