pragma solidity >=0.4.22 <0.7.0;

contract photographOwnership{

    address[] verifiers;

    struct photograph {
        string title;
        string ipfsAddress;
        address owner;
        address verifier;
        uint8 rentalAmount;
    }

    photograph[] photographInstance;

    constructor () public{
        verifiers.push(msg.sender);
    }

   function addVerifier(address newVerifier) public {
        for(uint8 i = 0; i < verifiers.length ; i++){
            if(msg.sender == verifiers[i]){
                verifiers.push(newVerifier);
            }
        }
    }

    function getVerifier() public view returns(address[] memory){
        for(uint8 i = 0; i < verifiers.length ; i++){
            if(msg.sender == verifiers[i]){
                return(verifiers);
            }
        }
    }

    function addPhotograph (string memory titl, string memory ipfsAddres, address owne, uint8 rentalAmoun) public {
        for(uint8 i = 0; i < verifiers.length ; i++){
            if(msg.sender == verifiers[i]){
                photograph memory tempPhotograph;
                tempPhotograph.title = titl;
                tempPhotograph.ipfsAddress = ipfsAddres;
                tempPhotograph.owner = owne;
                tempPhotograph.verifier = msg.sender;
                tempPhotograph.rentalAmount = rentalAmoun;
                photographInstance.push(tempPhotograph);
            }
        }
    }

    function getPhotograph(string memory titl, string memory ipfsAddres, address owne)public view returns(string memory, string memory, address ,address ,uint8){
        for(uint8 i = 0; i < photographInstance.length ; i++){
            if(owne == photographInstance[i].owner || compareStrings(ipfsAddres,photographInstance[i].ipfsAddress) == true || compareStrings(titl,photographInstance[i].title) == true){
                    photograph memory tempPhotograph = photographInstance[i];
                    return(
                        tempPhotograph.title,
                        tempPhotograph.ipfsAddress,
                        tempPhotograph.owner,
                        tempPhotograph.verifier,
                        tempPhotograph.rentalAmount
                    );
            }
        }
    }

    function compareStrings (string memory a, string memory b) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))) );
    }
}
