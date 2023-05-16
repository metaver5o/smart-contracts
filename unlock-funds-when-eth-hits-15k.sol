pragma solidity ^0.8.0;

contract PriceLockContract {
    uint256 constant LOCKED_PRICE = 15000 * 1e18; // USD 15,000 in wei

    address payable public beneficiary;
    uint256 public unlockTimestamp;
    bool public fundsUnlocked;

    event FundsUnlocked(address indexed beneficiary, uint256 amount);

    constructor(address payable _beneficiary) {
        beneficiary = _beneficiary;
        unlockTimestamp = 0;
        fundsUnlocked = false;
    }

    function lockFunds() external payable {
        require(!fundsUnlocked, "Funds have already been unlocked");
        require(msg.value > 0, "No funds sent");

        // Lock funds only if unlockTimestamp is not set
        if (unlockTimestamp == 0) {
            unlockTimestamp = block.timestamp;
        }
    }

    function unlockFunds() external {
        require(!fundsUnlocked, "Funds have already been unlocked");
        require(unlockTimestamp > 0, "Funds are not locked yet");
        require(getEthPrice() >= LOCKED_PRICE, "ETH price is below the locked price");

        fundsUnlocked = true;
        uint256 amountToTransfer = address(this).balance;
        beneficiary.transfer(amountToTransfer);

        emit FundsUnlocked(beneficiary, amountToTransfer);
    }

    function getEthPrice() public view returns (uint256) {
        // Implement your logic to fetch the ETH price from an oracle or external source
        // For simplicity, we return a fixed value here
        return 17000 * 1e18; // Assume ETH price is $17,000 in wei
    }
}
