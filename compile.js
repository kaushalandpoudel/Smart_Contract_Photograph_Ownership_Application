const path = require('path');
const fs = require('fs');
const solc = require('solc');

const contractPath = path.resolve(__dirname,'contracts','photographOwnership.sol');
const sourceCode = fs.readFileSync(contractPath, 'utf8');

// console.log(solc.compile(sourceCode, 1).contracts[':photographOwnership']);

module.exports = solc.compile(sourceCode, 1).contracts[':photographOwnership'];
