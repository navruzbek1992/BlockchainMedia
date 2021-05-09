pragma solidity >=0.4.22 <=0.6.2;

abstract contract TokenInstance {
  function  mint(address account, uint256 value) virtual public returns (bool);
}
