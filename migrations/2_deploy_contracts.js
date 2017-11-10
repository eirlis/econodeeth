//
//core
//
var Dispatcher = artifacts.require("./Dispatcher.sol");

//
//security
//
var AccessManager = artifacts.require("./security/AccessManager.sol");

//
//storage
//
var DataStorage = artifacts.require("./storage/DataStorage.sol");
var TrashRequestDAO = artifacts.require("./storage/TrashRequestDAO.sol");

//
//token
//
var EcoCoin = artifacts.require("./token/EcoCoin.sol");
var TrashToken = artifacts.require("./token/TrashToken.sol");
var BatteriesToken = artifacts.require("./BatteriesToken.sol");
var CeramicsToken = artifacts.require("./CeramicsToken.sol");
var ChemicalsToken = artifacts.require("./ChemicalsToken.sol");
var ElectronicsToken = artifacts.require("./ElectronicsToken.sol");
var GlassToken = artifacts.require("./GlassToken.sol");
var MetalToken = artifacts.require("./MetalToken.sol");
var MixedToken = artifacts.require("./MixedToken.sol");
var OrganicalToken = artifacts.require("./OrganicalToken.sol");
var PaperToken = artifacts.require("./PaperToken.sol");
var PlasticsToken = artifacts.require("./PlasticsToken.sol");
var TextilesToken = artifacts.require("./TextilesToken.sol");

//
//market
//
var Exchange = artifacts.require("./market/Exchange.sol");
var Warehouse = artifacts.require("./market/Warehouse.sol");


module.exports = function(deployer) {
    deployer.deploy(Dispatcher).then(function() {
        console.log("1. Dispatcher deployed success");

        deployer.deploy(AccessManager, Dispatcher.address).then(function() {
            console.log("2. AccessManager deployed success");
            Dispatcher.deployed().then(function(instance) {
                instance.setContract("AccessManager", AccessManager.address).then(function(result) {
                    console.log("3. AccessManager set to Dispatcher success");
                    
                    deployer.deploy(DataStorage, Dispatcher.address).then(function() {
                        console.log("4. DataStorage deployed success");

                        Dispatcher.deployed().then(function(instance) {
                            instance.setContract("DataStorage", DataStorage.address).then(function(result) {
                                console.log("5. DataStorage set to Dispatcher success");

                                //20 coins issue
                                deployer.deploy(EcoCoin, 20000000000000000000, Dispatcher.address).then(function() {
                                    console.log("6. EcoCoin deployed success");

                                    Dispatcher.deployed().then(function(instance) {
                                        instance.setContract("EcoCoin", EcoCoin.address).then(function(result) {
                                            console.log("7. EcoCoin set to Dispatcher success");

                                            deployer.deploy(TrashRequestDAO).then(function() {
                                                console.log("8. TrashRequestDAO deployed success");

                                                deployer.link(TrashRequestDAO, Warehouse);
                                                
                                                deployer.deploy(Warehouse, Dispatcher.address).then(function() {
                                                    console.log("9. Warehouse deployed success");

                                                    Dispatcher.deployed().then(function(instance) {
                                                        instance.setContract("Warehouse", Warehouse.address).then(function
                                                        (result) {
                                                            console.log("10. Warehouse set to Dispatcher success");

                                                            deployer.deploy(Exchange, Dispatcher.address).then(function() {
                                                                    console.log("12. Exchange deployed success");
                                                                    Dispatcher.deployed().then(function(instance) {
                                                                        instance.setContract("Exchange", Exchange.address).then
                                                                        (function(result) {
                                                                            console.log("13. Exchange set to Dispatcher success");
                                                                        }).catch(function(e) {
                                                                            console.log("13. Exchange not set to Dispatcher!!! " + e
                                                                            .message);
                                                                        });
                                                                    });
                                                                }).catch(function(e) {
                                                                    console.log("12. Exchange not deployed!!! " + e.message);
                                                                });

                                                        }).catch(function(e) {
                                                            console.log("10. Warehouse not set to Dispatcher!!! " + e.message);
                                                        });
                                                    });
                                                }).catch(function(e) {
                                                    console.log("9. Warehouse not deployed!!! " + e.message);
                                                });
                                            }).catch(function(e) {
                                                console.log("8. TrashRequestDAO and Warehouse not deployed!!! " + e.message);
                                            });
                                        }).catch(function(e) {
                                            console.log("7. EcoCoin not set to Dispatcher!!! " + e.message);
                                        });
                                    });
                                }).catch(function(e) {
                                    console.log("6. EcoCoin not deployed!!! " + e.message);
                                });
                            }).catch(function(e) {
                                console.log("5. DataStorage not set to Dispatcher!!! " + e.message);
                            });
                        });
                    }).catch(function(e) {
                        console.log("4. DataStorage not deployed!!! " + e.message);
                    });
                }).catch(function(e) {
                    console.log("3. AccessManager not set to Dispatcher!!! " + e.message);
                });
            });
        }).catch(function(e) {
            console.log("2. AccessManager not deployed!!! " + e.message);
        });
    }).catch(function(e) {
        console.log("1. Dispatcher and other not deployed!!! " + e.message);
    });
};
