const EventLottery = artifacts.require("EventLottery");

module.exports = function(deployer) {
  deployer.deploy(EventLottery);
};
