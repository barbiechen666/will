import './settestamentary.sol';

contract setpassword{
     settestamentary testamentary;
     uint password;
     uint hashdigits=8;
     uint hashmoduls=10**hashdigits;
     mapping(address=>uint) beneficiarypass;
     function _setpassword(address _contractadd) public{
        testamentary=settestamentary(_contractadd);
    }
     function passwordset(string memory _password) public{
         //password=uint((keccak256(abi.encodePacked(_password)))%hashmoduls);
         //password=uint((keccak256(_password)));
         //password=_password;
         beneficiarypass[msg.sender]=password;
     }
     function getpassword() public view returns(uint){
         return beneficiarypass[msg.sender];
     }
}   