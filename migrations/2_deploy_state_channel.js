const StateChannel = artifacts.require("StateChannel")

module.exports = function (deployer,network,accounts) {
    var Alice = accounts[0]
    var Bob = accounts[1]
    //Passing the Alice and Bob params ensures deployment of the contract to
    //Ganache works... but we won't be using this instance.
    deployer.deploy(StateChannel,Alice,Bob)
}
