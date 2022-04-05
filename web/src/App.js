import { useEffect, useState } from 'react';
import { ethers } from "ethers";

import './App.css';

const provider = new ethers.providers.Web3Provider(window.ethereum)
const abi = [{
  "inputs": [
    {
      "internalType": "address",
      "name": "operator",
      "type": "address"
    },
    {
      "internalType": "bool",
      "name": "approved",
      "type": "bool"
    }
  ],
  "name": "setApprovalForAll",
  "outputs": [],
  "stateMutability": "nonpayable",
  "type": "function"
}];

const withoutSigner = new ethers.Contract("0xac70bbde9E80f7726cdc67c00054aDb283c0AA31", abi, provider);
const signer = provider.getSigner()
const contract = withoutSigner.connect(signer);

function App() {
  const [account, setAccount] = useState('');
  const [operators, setOperators] = useState([]);
  const [wallet, setWallet] = useState();

  useEffect(() => {
    const setup = async () => {
      const accounts = await provider.send("eth_requestAccounts", []);
      setWallet(accounts[0]);
    }

    setup();
  });

  const fetchApprovedOperators = async () => {
    const res = await fetch(`http://localhost:8000/test/${account.toUpperCase()}`)
    const operators = await res.json();
    setOperators(operators)
  }

  const setApprovalForAll = async (isApproved) => {
    await contract.setApprovalForAll(account, isApproved);
  }

  return (
    <div className="App">
      <header className="App-header">
        <div className='container'>
          <input placeholder='address' type="text" onChange={e => setAccount(e.target.value)} value={account} />
          <div className='inner'>
            <button onClick={() => setApprovalForAll(true)}>Add approved operator</button>
            <button onClick={() => setApprovalForAll(false)}>Remove operator</button>
            <button onClick={fetchApprovedOperators}>Get approved operators</button>
          </div>
          <button onClick={() => setAccount(wallet)}>Autofill my wallet</button>
        </div>
        <div className='operators'>
          <h3>Approved Operators</h3>

          {operators.length ? operators.map(o => {
            return (
              <div className='operator'>
                <div key={o}>{o}</div>
                <button onClick={() => setAccount(o)}>Autofill address</button>
              </div>
            )
          }) : <div>No Operators</div>}
        </div>
      </header>
    </div>
  );
}

export default App;
