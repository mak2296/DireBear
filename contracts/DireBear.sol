// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./utils/Context.sol";
import "./ERC721.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor ()  {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


contract DIREBEAR is Ownable, ERC721 {
    
  
    address payable public bearWallet;
    
    uint256 public bearLength;
    
    uint256 public constant MAX_BEAR = 999;
    
    
    function changeBearWallet(address payable wallet) external onlyOwner() returns(bool){
        bearWallet = wallet;
        return true;
    }

    constructor(string memory _name, string memory _symbol,address payable wallet) ERC721(_name,_symbol)  {
        bearWallet = wallet;
    }
    
    function _getCurrentEthAmount() internal view returns(uint256 ethAmount){
        if(bearLength <= 100){
            return 0.2 ether;
        }else if(bearLength <= 200){
            return 0.4 ether;
        }else if(bearLength <= 300){
            return 0.6 ether;
        }else if(bearLength <= 400){
            return 0.8 ether;
        }else if(bearLength <= 500){
            return 1 ether;
        }else if(bearLength <= 600){
            return 1.5 ether;
        }else if(bearLength <= 700){
            return 2 ether;
        }else if(bearLength <= 800){
            return 2.5 ether;
        }else if(bearLength <= 900){
            return 3 ether;
        }else if(bearLength <= 975){
            return 4 ether;
        }else if(bearLength <= 999){
            return 5 ether;
        }
    }
    
    function getCurrentEthAmount() external view returns(uint256){
        return _getCurrentEthAmount();
    }
    
    function _genrateBearToken() internal returns(bool){
        bearLength+=1;
        require(MAX_BEAR >= bearLength,"max limit reach");
        require(msg.value >= _getCurrentEthAmount(),"eth amount error");
        _mint(msg.sender,bearLength);
        bearWallet.transfer(msg.value);
        return true;
    } 
    
    function genrateBearToken() external payable returns(bool){
        return _genrateBearToken();
    }
    
    fallback() external payable{
        _genrateBearToken();
    }
    
    receive() external payable{
        _genrateBearToken();
    }
    
 

}