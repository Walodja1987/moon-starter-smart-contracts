const { expect } = require("chai");
const { ethers } = require("hardhat");
// Chai/Waffle documentation: https://ethereum-waffle.readthedocs.io/en/latest/matchers.html

describe('Whitelist', () => {
  let Whitelist, whitelist;

  beforeEach(async () => {
      [owner, datafeedProviderAddr1, datafeedProviderAddr2, otherAddr, ...addrs] = await ethers.getSigners(); // addrs[0].address is the fifth address in the list
      Whitelist = await ethers.getContractFactory('Whitelist');
      whitelist = await Whitelist.deploy();  
    });

  it('Adds/removes addresses to/from the whitelist', async () => {
      // ******* Add addresses to the whitelist ******* 
      await whitelist.addToWhitelist([datafeedProviderAddr1.address, datafeedProviderAddr2.address]);
      whitelistedAddr1 = await whitelist.isWhitelisted(datafeedProviderAddr1.address);
      whitelistedAddr2 = await whitelist.isWhitelisted(datafeedProviderAddr2.address);
      whitelistedAddr3 = await whitelist.isWhitelisted(otherAddr.address);
      expect(whitelistedAddr1).is.true;
      expect(whitelistedAddr2).is.true;
      expect(whitelistedAddr3).is.false;

      // ******* Remove address from whitelist ******* 
      await whitelist.removeFromWhitelist([datafeedProviderAddr1.address, datafeedProviderAddr2.address]);
      whitelistedAddr1 = await whitelist.isWhitelisted(datafeedProviderAddr1.address);
      whitelistedAddr2 = await whitelist.isWhitelisted(datafeedProviderAddr2.address);
      expect(whitelistedAddr1).is.false;
      expect(whitelistedAddr2).is.false;
    });

  it('Adds/deactivates/activates datafeeds', async () => {
    // ******* Add to whitelist ******* 
    await whitelist.addToWhitelist([datafeedProviderAddr1.address, datafeedProviderAddr2.address]);
    const arr = ["ETH/USD", "BTC/USD", "ADA/USD", "XBT-USD"];

    // ******* Add datafeeds ******* 
    // Should throw an error if called by an account other than the owner
    await expect(whitelist.connect(datafeedProviderAddr1).addDatafeeds(datafeedProviderAddr1.address, arr)).to.be.revertedWith("Only owner.");
    await expect(whitelist.connect(otherAddr).addDatafeeds(datafeedProviderAddr1.address, arr)).to.be.revertedWith("Only owner.");
    // Should work if called by owner
    await whitelist.addDatafeeds(datafeedProviderAddr1.address, arr);

    // ******* Get datafeeds ******* 
    datafeeds = await whitelist.getDatafeeds(datafeedProviderAddr1.address);
    console.log("Datafeeds struct array output format: " + datafeeds); // ETH/USD,true,BTC/USD,true,ADA/USD,true,XBT-USD,true
    console.log("Datafeeds struct array 1st element output format: " + datafeeds[0]);
    for (i=0; i < datafeeds.length; i++) {
      expect(datafeeds[i].underlying).to.equal(arr[i]);
      expect(datafeeds[i].isActive).is.true;
    }

    // ******* Deactivate datafeeds ******* 
    // Should throw an error if called by an account other than the owner or the datafeed provider
    await expect(whitelist.connect(otherAddr).deactivateDatafeeds(datafeedProviderAddr1.address, [0, 2], ["ETH/USD", "ADA/USD"])).to.be.revertedWith("Only owner or datafeed provider.");
    // Should work if called by owner or data feed provider
    // await whitelist.deactivateDatafeeds(datafeedProviderAddr1.address, [0, 2], ["ETH/USD", "ADA/USD"]);
    await whitelist.deactivateDatafeeds(datafeedProviderAddr1.address, [0], ["ETH/USD"]);
    await whitelist.connect(datafeedProviderAddr1).deactivateDatafeeds(datafeedProviderAddr1.address, [2], ["ADA/USD"]); 
    console.log("I was here")

    // Should throw if datafeed is already deactivated 
    await expect(whitelist.deactivateDatafeeds(datafeedProviderAddr1.address, [0], ["ETH/USD"])).to.be.revertedWith("Datafeed is already deactivated."); 
    datafeedsAfterDeactivation = await whitelist.getDatafeeds(owner.address);
    for (i=0; i < datafeedsAfterDeactivation.length; i++) {
      expect(datafeedsAfterDeactivation[i].underlying).to.equal(arr[i]);
      if (datafeedsAfterDeactivation[i].underlying === "ETH/USD" || datafeedsAfterDeactivation[i].underlying === "ADA/USD") {
        expect(datafeedsAfterDeactivation[i].isActive).is.false;
      } else {      
        expect(datafeedsAfterDeactivation[i].isActive).is.true;
      }    
    }
    
    // ******* Activate datafeed ******* 
    // Should throw if calling address is not the owner
    await expect(whitelist.connect(otherAddr).activateDatafeeds(datafeedProviderAddr1.address, [0, 2], ["ETH/USD", "ADA/USD"])).to.be.revertedWith("Only owner."); 
    await expect(whitelist.connect(datafeedProviderAddr1).activateDatafeeds(datafeedProviderAddr1.address, [0, 2], ["ETH/USD", "ADA/USD"])).to.be.revertedWith("Only owner."); 
    // Should work if called by the owner
    await whitelist.activateDatafeeds(datafeedProviderAddr1.address, [0, 2], ["ETH/USD", "ADA/USD"]); 
    datafeedsAfterReactivation = await whitelist.getDatafeeds(datafeedProviderAddr1.address);
    for (i=0; i < datafeedsAfterReactivation.length; i++) { 
      expect(datafeedsAfterReactivation[i].isActive).is.true;
    } 
    
    // ******* Get all providers ******* 
    providerAddresses = await whitelist.getAllProviders();
    console.log("provider address array output format: " + providerAddresses); // ['0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266','0x70997970C51812dc3A010C7d01b50e0d17dc79C8']
    expect(providerAddresses[0]).to.equal(datafeedProviderAddr1.address);
    expect(providerAddresses[1]).to.equal(datafeedProviderAddr2.address);
  });

  it('getDatafeeds output test', async () => {
    const test = await whitelist.getDatafeeds(otherAddr.address);
    console.log(test);
  });

  it('Fails to deactivate datafeeds when arrays are of different lengths', async () => {
    await expect(whitelist.deactivateDatafeeds(owner.address, [0,2], ["ETH/USD"])).to.be.revertedWith('Arrays are of different lengths.');
  });

});
