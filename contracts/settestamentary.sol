contract settestamentary{
    //mapping(address=>uint) balances;
    string owneremail; 
    
    struct Beneficiary{
        string beneficiaryemail;
        uint portion;
        bool execute;
    }
    mapping(uint=>Beneficiary) beneficiaryinfo;
    uint[] public beneficiaryids;
    
    //簽立遺囑人信箱
    function submitEmail(string memory _email) public {
       owneremail = _email;
    }
    function getEmail() public view returns (string memory) {
        return owneremail;
    }
    //添加入受益人
    function addbene(uint id,string memory _benemail,uint _distriburate) public{
       Beneficiary storage newbene= beneficiaryinfo[id];
       newbene.beneficiaryemail = _benemail;
       newbene.portion=_distriburate;
       newbene.execute=false;
       beneficiaryids.push(id);
    }
    //查看受益人資訊
    function getBeneficiary(uint id) public view returns (string memory,uint,bool){
        Beneficiary storage s = beneficiaryinfo[id];
        return (s.beneficiaryemail,s.portion,s.execute);
    }
    
}