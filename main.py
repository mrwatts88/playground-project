from typing import Optional
from enum import Enum

from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from web3 import Web3
from web3.middleware import geth_poa_middleware

provider = "https://rinkeby.infura.io/v3/9a349c5cab5c4b6dba9590d704578388"
abi = [
    {
        "inputs": [
            {
                "internalType": "address",
                "name": "owner",
                "type": "address"
            }
        ],
        "name": "getApprovedOperators",
        "outputs": [
            {
                "internalType": "address[]",
                "name": "",
                "type": "address[]"
            }
        ],
        "stateMutability": "view",
        "type": "function"
    },
]

w3 = Web3(Web3.HTTPProvider(provider))
w3.middleware_onion.inject(geth_poa_middleware, layer=0)

contract = w3.eth.contract(address='0xac70bbde9E80f7726cdc67c00054aDb283c0AA31', abi=abi)

app = FastAPI()
origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/test/{address}")
def get_approved_operators(address: str):
    approvedOperators = contract.functions.getApprovedOperators(Web3.toChecksumAddress(address)).call()

    return approvedOperators
