# scripts/deploy.py
import os
from nile.nre import NileRuntimeEnvironment
from nile.core.call_or_invoke import call_or_invoke


def run(nre: NileRuntimeEnvironment):
    print("Compiling contracts...")
    nre.compile(
        [
            "src/nft/CarbonableProjectNFT.cairo",
            "src/mint/CarbonableMinter.cairo",
        ]
    )
    owner = os.environ["OWNER"]

    name = str(str_to_felt("CarbonableProject"))
    symbol = str(str_to_felt("CP"))
    params = [name, symbol, owner]

    print("Deploying CarbonableProjectNFT...")
    address, _ = nre.deploy(
        "CarbonableProjectNFT",
        params,
        alias="CarbonableProjectNFT",
    )
    print(f"CarbonableProjectNFT contract address: {address}")

    projectNFTAddress = address
    paymentTokenAddress = 0
    whitelistedSaleOpen = 0
    publicSaleOpen = 0
    maxBuyPerTx = 5
    unitPrice = uint(100)
    maxSupplyForMint = uint(10)

    minterParams = [
        owner,
        projectNFTAddress,
        paymentTokenAddress,
        whitelistedSaleOpen,
        publicSaleOpen,
        maxBuyPerTx,
        100,
        0,  # unit price
        10,
        0,  # max supply for mint
    ]

    print("Deploying CarbonableMinter...")
    minterAddress, _ = nre.deploy(
        "CarbonableMinter",
        minterParams,
        alias="CarbonableMinter",
    )
    print(f"CarbonableMinter contract address: {minterAddress}")


# Auxiliary functions
def str_to_felt(text):
    b_text = bytes(text, "ascii")
    return int.from_bytes(b_text, "big")


def uint(a):
    return (a, 0)
