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
        address user;
        authorizationReceipt receipt;
        
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
    
    function getIndex(string memory tempIPFSHash) public view returns(uint8){
        for(uint8 i=0; i<photographInstance.length; i++){
            photograph memory tempPhotograph = photographInstance[i];
            if(compareStrings(tempPhotograph.ipfsAddress, tempIPFSHash)){
                return i;
            }
        }
    }
    
    function compareStrings (string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
    
    function createAuthorizationContract(string memory tempIPFSHash, address tempOwner) public payable returns (authorizationReceipt ){
        
        for(uint8 i=0; i<photographInstance.length; i++){
            photograph memory tempPhotograph = photographInstance[i];
            if(compareStrings(tempPhotograph.ipfsAddress, tempIPFSHash)){
                require(tempPhotograph.rentable == true);
                require(msg.value > tempPhotograph.rentalAmount);
                require(msg.sender == tempPhotograph.user);
                
                tempOwner.transfer(msg.value);
                
                authorizationReceipt tempReceipt = new authorizationReceipt(tempIPFSHash, msg.sender,tempOwner, tempPhotograph.rentalAmount);
                photographInstance[i].receipt = tempReceipt;
                photographInstance[i].rentable = false;
                photographInstance[i].rentalAmount = 0;
            }
        }
        

        
        return (tempReceipt);
    }
    
    function makePayable(string memory tempIPFSHash, uint256 tempValue, address tempUser) public {
        
        for(uint8 i=0; i<photographInstance.length; i++){
            photograph memory tempPhotograph = photographInstance[i];
            if(compareStrings(tempPhotograph.ipfsAddress, tempIPFSHash)){
                if(tempPhotograph.owner == msg.sender){
                    photographInstance[i].rentable = true;
                    photographInstance[i].rentalAmount = tempValue;
                    photographInstance[i].user = tempUser;
                }
            }
        }
        
        // require(msg.sender == photographInstance[tempIndex].owner);
        // photographInstance[tempIndex].rentable = true;
        // photographInstance[tempIndex].rentalAmount = tempValue;
        // photographInstance[tempIndex].user = tempUser;
        // tempPhotograph.rentable = true;
        // tempPhotograph.rentalAmount = tempValue;
        
    }
    
    function getAuthorizationReceipt(string memory tempIPFSHash) public view returns(authorizationReceipt){
        for(uint8 i=0; i<photographInstance.length; i++){
            photograph memory tempPhotograph = photographInstance[i];
            if(compareStrings(tempPhotograph.ipfsAddress, tempIPFSHash)){
                authorizationReceipt tempReceipt = tempPhotograph.receipt;
                return tempReceipt;
            }
            
        }
    }
    
    
    function getAuthorizationContract(authorizationReceipt tempContractAddress) public view  returns(string , address , address, uint256 ){
        return (tempContractAddress.getAuthorizationContract());
    }
    
}


contract authorizationReceipt{
    
    string photographIPFSHash;
    address user;
    address owner;
    uint256 valuePaid;
    
    constructor(string memory tempIPFSHash, address tempUser, address tempOwner, uint256 tempValue) public{
        photographIPFSHash = tempIPFSHash;
        user = tempUser;
        owner = tempOwner;
        valuePaid = tempValue;
    }
    
    function getAuthorizationContract() public view returns(string , address , address, uint256 ){
        return(photographIPFSHash, user, owner, valuePaid);
    }
    
}
