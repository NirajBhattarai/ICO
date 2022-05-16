// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Q2Sale {
  address admin;
  IERC20 public q2token;
  IERC20 public busd;
  uint256 public tokenPrice;
  uint256 public tokensSold;

  event Sell(address _buyer, uint256 _amount);

  constructor(
    IERC20 _q2token,
    IERC20 _busd,
    uint256 _tokenPrice
  ) {
    admin = msg.sender;
    q2token = _q2token;
    busd = _busd;
    tokenPrice = _tokenPrice;
  }

  function changePrice(uint256 newTokenPrice) public {
    require(msg.sender == admin, "Only the admin can call this function");
    tokenPrice = newTokenPrice;
  }

  function buyTokens(uint256 _numberOfTokens) public payable {
    require(
      q2token.balanceOf(address(this)) >= _numberOfTokens,
      "Contact does not have enough tokens"
    );
    q2token.transfer(msg.sender, _numberOfTokens);

    uint256 amount = _numberOfTokens * tokenPrice;
    busd.transferFrom(msg.sender, address(this), amount);
    tokensSold += _numberOfTokens;
    emit Sell(msg.sender, _numberOfTokens);
  }

  function withBUSD() public {
    require(msg.sender == admin, "Only the admin can call this function");
    busd.transfer(msg.sender, busd.balanceOf(address(this)));
  }

  function endSale() public {
    require(msg.sender == admin, "Only the admin can call this function");
    q2token.transfer(msg.sender, q2token.balanceOf(address(this)));
  }
}
