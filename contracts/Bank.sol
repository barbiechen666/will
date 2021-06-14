// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.7.0;

contract Bank{
    address[] owners;
    address mainowner;
    mapping(address => bool) isOwner;
    mapping(address => uint) balances;
    bool activated;

    modifier checkSameOwner (address addr){
        require(mainowner == addr, "not contract owner");
        _; //執行
    }

    //存錢進合約
    /*function deposit() public payable{
        balances[msg.sender]+=msg.value;
    }*/

    constructor () public{
        owners = [msg.sender];
        mainowner = msg.sender;
        isOwner[msg.sender] = true;
        activated = false;
    }
    
    //領錢出來
    function withdraw(uint amount) public payable checkSameOwner(msg.sender){
        require((amount*1000000000000000000) <= address(this).balance, "not enough funds");
        (bool sent, ) = msg.sender.call.value(amount*1000000000000000000)("");
        require(sent, "Failed to send Ether");
    }

    mapping(address=>uint) balances;
    //address owner;
    //string owneremail; 
    /*struct Owner{
        address addr;
        string owneremail;
        mapping(address=>mapping(uint=>Beneficiary)) beneficiarylist;
    }*/
    /*struct Beneficiary{
        string beneficiaryemail;
        uint portion;
        bool execute;
    }*/
    //mapping(uint=>Beneficiary) beneficiaryinfo;
    //uint[] public beneficiaryids;
 
    /*constructor() public{
        owner=msg.sender;
    }
    modifier checksameowner(address addr){
        require(owner==addr,"not owner");
        _;
    }*/
    
    event Deposit(address user,uint deamount);
    event Withdraw(address user,uint wiamount);
    
    //存錢進合約
    /*function deposit() public payable{
        balances[msg.sender]+=msg.value;
        emit Deposit(msg.sender,msg.value);
    }*/
    function deposit() public payable{
        emit Deposit(msg.sender,msg.value);
    }
    //領錢出來
    /*function withdraw(uint amount) payable public{
        if(balances[msg.sender]>=amount){
            balances[msg.sender]-=amount;
            msg.sender.transfer(amount);
            emit Withdraw(msg.sender,amount);
        }
    }*/
    /*function withdraw(uint amount) payable public checksameowner(msg.sender){
      require(amount*10*18<=address(this).balance,"exceed!");
      (bool sent, )=msg.sender.call.value(amount*10**18)("");
      require(sent, "Falied to send Ether");
      emit Withdraw(msg.sender,amount*10**18);
        }*/
    
    
    //查看合約的錢
    function getBankBalance() public view returns(uint){
        return this.balance;
    }
}
//contract testamentaryset{

//}
//contract settestamentary{
    //mapping(address=>uint) balances;
    string owneremail; 
    uint id;
    address _to;
    /*struct Owner{
        address addr;
        string owneremail;
        mapping(address=>mapping(uint=>Beneficiary)) beneficiarylist;
    }*/
    struct Beneficiary{
        string beneficiaryemail;
        uint portion;
        bool execute;
    }
    mapping(uint=>Beneficiary) beneficiaryinfo;
    uint[]  beneficiaryids;
    mapping(string=>Beneficiary) beneficiaryinfo2;
    string[] beneficiarymails;
    mapping(string=>bool) mailexist;
    mapping(string=>uint) portions;
    mapping(address=>uint) transferamount;
    address[] toadds;
    //mapping()
    
    //Bank bank;
    /*function settestamentary(address _contractadd) public{
        bank=Bank(_contractadd);
    }*/

    //簽立遺囑人信箱
    /*function submitEmail(string memory _email) public {
       owneremail = _email;
    }*/
    function submitEmail(string memory _email) public {
       owneremail = _email;
    }
    function getEmail() public view returns (string memory) {
        return owneremail;
    }
    //添加入受益人
    function addbene(string memory _benemail,uint _distriburate) public checksameowner(msg.sender){
       require(balances[msg.sender]>0);
       id=beneficiaryids.length+1;
       Beneficiary storage newbene= beneficiaryinfo[id];
       newbene.beneficiaryemail = _benemail;
       newbene.portion=_distriburate;
       newbene.execute=false;
       beneficiaryids.push(id);
       beneficiarymails.push(_benemail);
       mailexist[_benemail]=true;
       portions[_benemail]=_distriburate;
    }
    //for test
    function returnlen()public view returns(uint){
        return beneficiarymails.length;
    }
    //查看受益人資訊
    function getBeneficiary(uint id) public view returns (string memory,uint,bool){
        Beneficiary storage s = beneficiaryinfo[id];
        return (s.beneficiaryemail,s.portion,s.execute);
    }

    function getbeneficiarybymail(string memory _mail) public view returns(bool){
        return mailexist[_mail];
    }
    function getportion(string memory _mail) public view returns(uint){
        return portions[_mail];
    }
    //修改受益人分配比例
    function modifybene(uint _id,string memory _mail,uint _portion)public checksameowner(msg.sender){
        Beneficiary storage  s =beneficiaryinfo[_id];
        s.portion=_portion;
        portions[_mail]=_portion;
    }
    function submitTransaction(address _to,uint _portion) payable public {
        toadds.push(_to);
        transferamount[_to]=address(this).balance/100*_portion;
        if(toadds.length==beneficiarymails.length){
           for(uint i=0;i<toadds.length;i++){
             toadds[i].transfer(transferamount[toadds[i]]);  
           }
        }
        //_to.transfer(address(this).balance/100*_portion);}
    }

contract setpassword{
     Bank bank;
     uint password;
     uint portion;
     uint hashdigits=8;
     uint hashmoduls=10**hashdigits;
     mapping(address=>uint) beneficiarypass;
     mapping(uint=>uint) beneficiaryportion;
     mapping(string=>uint)portions;
     mapping(address=>string)mail;
     
    function setpassword(address _contractadd) public{
        bank=Bank(_contractadd);
    }
     /*function checkvalid(string memory _emaill)public view returns(string) {
        string memory i;
        if(bank.getbeneficiarybymail(_emaill)==true){
        i="valid";}
        else{i="invalid";}
        return i;
     }*/
     function passset(string memory _mail,string memory _password) public{
         //password=uint((keccak256(abi.encodePacked(_password)))%hashmoduls);
         require(bank.getbeneficiarybymail(_mail)==true);
         password=uint((keccak256(_password)));
         //password=_password;
         beneficiarypass[msg.sender]=password;
         mail[msg.sender]=_mail;
         //beneficiaryportion[password]=bank.getportion(_mail);
     }
     function getmail()public view returns(string memory){
         return mail[msg.sender];
     }

     function getpassword() public view returns(uint){
         return beneficiarypass[msg.sender];
     }

    function getmypo()public view returns(uint){
        return bank.getportion(mail[msg.sender]);
    }

    function execute(string memory _password)public payable{
         require(uint(keccak256(_password))==beneficiarypass[msg.sender]);
         //portion=beneficiaryportion[uint(keccak256(_password))];
         portion=bank.getportion(mail[msg.sender]);
         bank.submitTransaction(msg.sender,portion);
         //msg.sender.transfer(bank.getBankBalance()/100*beneficiaryportion[uint(keccak256(_password))]);
     }


}
