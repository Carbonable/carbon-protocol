# scripts/deploy.py
import os
from nile.nre import NileRuntimeEnvironment
from nile.core.call_or_invoke import call_or_invoke


def run(nre: NileRuntimeEnvironment):
    print("Compiling contracts…")
    nre.compile(
        [
            "src/nft/CarbonableProjectNFT.cairo",
            "src/mint/CarbonableMinter.cairo",
        ]
    )
    print("Deploying contracts…")
    owner = os.environ["OWNER"]
    name = str(str_to_felt("CarbonableProject"))
    symbol = str(str_to_felt("CP"))
    params = [name, symbol, owner]
    address, abi = nre.deploy(
        "CarbonableProjectNFT",
        params,
        alias="CarbonableProjectNFT",
    )
    print(f"ABI: {abi},\CarbonableProjectNFT contract address: {address}")

    projectNFTAddress = address
    paymentTokenAddress = "0x1234"
    whitelistedSaleOpen = 0
    publicSaleOpen = 0
    maxBuyPerTx = 5
    unitPrice = uint(100)
    maxSupplyForMint = uint(10)

    params = [
        owner,
        projectNFTAddress,
        paymentTokenAddress,
        whitelistedSaleOpen,
        publicSaleOpen,
        maxBuyPerTx,
        unitPrice,
        maxSupplyForMint,
    ]
    address, abi = nre.deploy(
        "CarbonableMinter",
        params,
        alias="CarbonableMinter",
    )
    print(f"ABI: {abi},\CarbonableMinter contract address: {address}")


# Auxiliary functions
def str_to_felt(text):
    b_text = bytes(text, "ascii")
    return int.from_bytes(b_text, "big")


def uint(a):
    return (a, 0)
