// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Base64.sol";

contract NFTonchainPetra is ERC721Enumerable, Ownable {
  using Strings for uint256;
  
string[] public wordsValues = ["!cryptoanarchism!", "!civil disobedience!", "!digital autonomy!", "!technological sovereignty!", "!decentralized economy!", "!sovereign identity!", "!financial privacy!", "!digital currency!", "!smart contracts!", "!financial counterculture!", "!distributed governance!", "!trusted networks!", "!financial resistance!", "!decentralized identity!", "!freedom in web3!", "!interoperability!", "!private transactions!", "!cryptographic resistance!", "!privacy protection!", "!data control!", "!digital property rights!", "!protection against surveillance!", "!financial protest!", "!financial revolution!", "!global financial freedom!", "!decentralized collaboration!", "!decentralized applications!", "!distributed voting systems!", "!autonomous identity!", "!decentralized exchange!", "!proof of stake!", "!transparent voting systems!", "!trustless contracts!", "!freedom of expression protection!", "!financial anonymity!", "!freedom of choice!", "!tokenized rewards!", "!web3 governance!", "!blockchain for justice!", "!open economy!", "!decentralized communities!", "!digital human rights!", "!intellectual property protection!", "!resistance to spying!", "!feminist crypto activism!", "!social resistance!", "!decentralized markets!", "!decentralized organization!", "!distributed cybersecurity!", "!online privacy protection!", "!freedom of press protection!", "!content control resistance!", "!internet of things privacy!", "!economic democracy!", "!internet of things privacy protection!", "!sovereign identity in internet of things!", "!online discrimination resistance!", "!autonomy in internet of things!", "!citizen surveillance!", "!internet of things privacy control!", "!LGBTQ+ crypto activism!", "!anti-racist crypto activism!", "!crypto activism for peace!", "!crypto activism for climate justice!", "!crypto activism for animal rights!", "!crypto activism for religious freedom!", "!crypto activism for open education!"];
  
   struct Word { 
      string name;
      string description;
      string bgHue;
      string textHue;
      string value;
   }
  
  mapping (uint256 => Word) public words;
  
  constructor() ERC721("NFTonchainPetra", "NFTP") {}

  function mint() public payable {
    uint256 supply = totalSupply();
    require(supply + 1 <= 100);
    
    Word memory newWord = Word(
        string(abi.encodePacked('NFTP #', uint256(supply + 1).toString())), 
        "This smart contract allows users to express their disagreement with a cause by sending a transaction with a protest message on the blockchain.",
        randomNum(361, block.prevrandao, supply).toString(),
        randomNum(361, block.timestamp, supply).toString(),
        wordsValues[randomNum(wordsValues.length, block.prevrandao, supply)]);
    
    if (msg.sender != owner()) {
      require(msg.value >= 0.005 ether);
    }
    
    words[supply + 1] = newWord;
    _safeMint(msg.sender, supply + 1);
  }

  function randomNum(uint256 _mod, uint256 _seed, uint _salt) public view returns(uint256) {
      uint256 num = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, _seed, _salt))) % _mod;
      return num;
  }
  
  function buildImage(uint256 _tokenId) public view returns(string memory) {
      Word memory currentWord = words[_tokenId];
      return Base64.encode(bytes(
          abi.encodePacked(
              '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg">',
              '<rect height="500" width="500" fill="hsl(',currentWord.bgHue,', 50%, 25%)"/>',
              '<text x="50%" y="50%" dominant-baseline="middle" fill="hsl(',currentWord.textHue,', 100%, 50%)" text-anchor="middle" font-size="30">',currentWord.value,'</text>',
              '</svg>'
          )
      ));
  }
  
  function buildMetadata(uint256 _tokenId) public view returns(string memory) {
      Word memory currentWord = words[_tokenId];
      return string(abi.encodePacked(
              'data:application/json;base64,', Base64.encode(bytes(abi.encodePacked(
                          '{"name":"', 
                          currentWord.name,
                          '", "description":"', 
                          currentWord.description,
                          '", "image": "', 
                          'data:image/svg+xml;base64,', 
                          buildImage(_tokenId),
                          '"}')))));
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
      require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
      return buildMetadata(_tokenId);
  }
}
