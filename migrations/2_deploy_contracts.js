const Bank = artifacts.require("Bank");
//var setpassword = artifacts.require("./setpassword.sol");
//var settestamentary = artifacts.require("./settestamentary.sol");


module.exports = async function(deployer) {
  const bank = await Bank.deployed()
  deployer.deploy(Bank);
  // deployer.deploy(setpassword);
  // deployer.deploy(settestamentary);
};
