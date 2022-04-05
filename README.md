To deploy the smart contract:
- Add a file named `.key.txt` to the project root with your wallet private key.
- Add a file named `.etherscan-key.txt` to the project root with your etherscan api key (only if you need to verify the source code).
- Run `npx hardhat run scripts/deploy.js --network rinkeby`
- Note the contract address.
- To verify the source code, run `npx hardhat verify "<contract address>" --network rinkeby`

To run the python server:
- If you are using a newly deployed contract, replace the contract address in `main.py` LN 36 with the new address.
    - there is already a contract deployed, so you can interact with that one without changing anything.
- Run `python3 -m uvicorn main:app --reload`
- The server runs on port 8000.

To run the web app:
- If you are using a newly deployed contract, replace the contract address in `App.js` LN 26 with the new address.
    - there is already a contract deployed, so you can interact with that one without changing anything.
- Run `cd web && npm start`
- The web app runs on port 3000.
