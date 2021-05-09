pragma solidity >=0.5.0 <=0.6.2;


import "OpenZeppelin/openzeppelin-contracts@3.0.0/contracts/access/Ownable.sol";
import "./Interfaces.sol";

contract BlockchainMedia is Ownable {

  address tokenAddress;

    constructor(address _tokenAddress) public {
      tokenAddress = _tokenAddress;
     }

  function viewBlockNumber() public view returns (uint){
    return block.number;
  }

  struct ReceivedArticle {
      string article;
      address ownerAddress;
      uint block;
  }

  struct PublishedArticle {
      string article;
      address ownerAddress;
      uint block;
  }

  mapping (uint => ReceivedArticle) receivedArticle;
  mapping (uint => PublishedArticle) publishedArticle;
  event ArticleReceived(address ownerAddress, uint blockNumber);
  event ArticlePublished(address ownerAddress, uint blockNumber);

  function sendArticle(string memory _article) public returns (bool) {
    receivedArticle[block.number].article = _article;
    receivedArticle[block.number].block = block.number;
    receivedArticle[block.number].ownerAddress = msg.sender;

    emit ArticleReceived(msg.sender, block.number);

    return true;
  }

  function publishArticle(uint _block) public returns (bool) {
    publishedArticle[_block].article = receivedArticle[_block].article ;
    publishedArticle[_block].block = receivedArticle[_block].block;
    publishedArticle[_block].ownerAddress = receivedArticle[_block].ownerAddress;

    address _ownerAddress = receivedArticle[_block].ownerAddress;

    emit ArticlePublished(_ownerAddress, _block);

    // give article owners some tokens
    TokenInstance(tokenAddress).mint(_ownerAddress, 555555555555);

    return true;
  }

  function receiveLatestArticle(uint blockNumber) public view returns (string memory){
    return publishedArticle[blockNumber].article;
  }

  function receiveLatestArticleOwner(uint blockNumber) public view returns (address){
    return publishedArticle[blockNumber].ownerAddress;
  }

	function destroy() public onlyOwner {
	    selfdestruct(msg.sender);
	}
}
