const StakingToken = artifacts.require("StakingToken");

contract("StakingToken", accounts => {
    let token;
    const [owner, user1] = accounts;

    beforeEach(async () => {
        token = await StakingToken.new();
    });

    it("should have correct initial supply", async () => {
        const supply = await token.totalSupply();
        assert.equal(supply.toString(), "1000000000000000000000000");
    });
});
