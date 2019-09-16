pragma solidity >=0.4.22 <0.7.0;

contract photographOwnership{

    address[] verifiers;
    
    struct photograph {
        bool rentable ;
        string title;
        string ipfsAddress;
        address owner;
        address verifier;
        uint rentalAmount;
        string publicKey;
    }
    
    photograph[] photographInstance; 
    
    constructor () public{
        verifiers.push(msg.sender);
    }
    
    
    function addVerifier(address newVerifier) public {
        for(uint8 i = 0; i< verifiers.length; i++){
            if(msg.sender == verifiers[i]){
                verifiers.push(newVerifier);
            }
        }
    }
    
    function getVerifier() public view returns(address[] memory){
        for(uint8 i = 0; i< verifiers.length; i++){
            if(msg.sender == verifiers[i]){
                return(verifiers);
            }
        }        
    }
    
    function addPhotograph (string memory titl, string memory ipfsAddres, address owne, string memory tempPublicKey) public {
        for(uint8 i = 0; i< verifiers.length; i++){
            if(msg.sender == verifiers[i]){
                photograph memory tempPhotograph;
                tempPhotograph.title = titl;
                tempPhotograph.ipfsAddress = ipfsAddres;
                tempPhotograph.owner = owne;
                tempPhotograph.verifier = msg.sender;
                tempPhotograph.rentalAmount = 0;
                tempPhotograph.rentable = false;
                tempPhotograph.publicKey = tempPublicKey;
                photographInstance.push(tempPhotograph);
            }
        }
    }
    
    function getPhotograph (uint8 index) public view returns(string memory, string memory, address, address, uint256, bool, string memory){
        
        photograph memory tempPhotograph = photographInstance[index]; 
        return( 
            tempPhotograph.title,
            tempPhotograph.ipfsAddress,
            tempPhotograph.owner,
            tempPhotograph.verifier,
            tempPhotograph.rentalAmount,
            tempPhotograph.rentable,
            tempPhotograph.publicKey
        );
        
    }   
    
    function getPhotographsLength() public view returns(uint){
        return (photographInstance.length);
    }
    
    
    function compareStrings (string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
    
    function createAuthorizationContract(uint8 tempIndex, address tempUser, address tempOwner) public payable returns (authorizationReceipt ){
        
        photograph memory tempPhotograph = photographInstance[tempIndex]; 
        require(tempPhotograph.rentable == true);
        require(msg.value > tempPhotograph.rentalAmount);
        
        tempOwner.transfer(msg.value);
        
        authorizationReceipt tempReceipt = new authorizationReceipt(tempIndex, tempUser,tempOwner, tempPhotograph.rentalAmount);
        photographInstance[tempIndex].rentable = false;
        photographInstance[tempIndex].rentalAmount = 0;
        
        return (tempReceipt);
    }
    
    function makePayable(uint8 tempIndex, uint256 tempValue) public {
        
        require(msg.sender == photographInstance[tempIndex].owner);
        photographInstance[tempIndex].rentable = true;
        photographInstance[tempIndex].rentalAmount = tempValue;
        // tempPhotograph.rentable = true;
        // tempPhotograph.rentalAmount = tempValue;
        
    }
    
    
    function getAuthorizationContract(authorizationReceipt tempContractAddress) public view returns(uint8 , address , address, uint256 ){
        return (tempContractAddress.getAuthorizationContract());
    }
    
}


contract authorizationReceipt{
    
    uint8 photographIndex;
    address user;
    address owner;
    uint256 valuePaid;
    
    constructor(uint8 index, address tempUser, address tempOwner, uint256 tempValue) public{
        photographIndex = index;
        user = tempUser;
        owner = tempOwner;
        valuePaid = tempValue;
    }
    
    function getAuthorizationContract() public view returns(uint8 , address , address, uint256 ){
        return(photographIndex, user, owner, valuePaid);
    }
    
}
