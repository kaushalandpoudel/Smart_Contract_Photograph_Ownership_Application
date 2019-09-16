const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const web3 = new Web3(ganache.provider());
const {interface, bytecode} = require('../compile');

let fetchedAccounts;
let contract;
beforeEach( async()=>{
    fetchedAccounts = await web3.eth.getAccounts();
    contract = await new web3.eth.Contract(JSON.parse(interface)).deploy({data: bytecode, arguments:[]})
    .send({from: fetchedAccounts[0], gas: '1000000'});
});

describe('contract test', () =>{
    it('deployed',()=>{
        assert.ok(contract.options.address);
        console.log(fetchedAccounts[0]);

    });

    it('check constructor', async() =>{
        const value = await contract.methods.getVerifier().call();
        assert.equal(value, fetchedAccounts[0]);
        console.log(fetchedAccounts[0]);
        
    });

    // it('change iphash', async() =>{

    //     const hash = await contract.methods.setAddress('There is a car.').send({from: fetchedAccounts[0]});
    //     const iphashValue = await contract.methods.getAddress().call();
    //     assert.equal(iphashValue,'There is a car.');
    //     console.log(hash);
        
    // });
})