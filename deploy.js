/*afraid pulse ethics trim chaos inform right second turn artist size road*/ 
// 123@Lalallalalalla


const hdWalletProvider = require('truffle-hdwallet-provider');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const {interface, bytecode} = require('./compile');


	


const provider = new hdWalletProvider(
    'http://localhost:8545'
);
 
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const deploy = async () => {

    const account = await web3.eth.getAccounts();
    await web3.eth.personal.unlockAccount(account[0], '1234');
    console.log('Deploying from account' + account[0]);
    try{
        const result = await new web3.eth.Contract(JSON.parse(interface)).deploy({data: '0x' + bytecode, arguments:[]})
        .send({ gas: 4700000 , from: account[0]});
        console.log('deployed to the address : ', result.options.address);
        console.log(interface);

    } catch(error){
        console.log(error);  
    }
};

deploy();

