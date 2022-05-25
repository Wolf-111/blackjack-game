import React, { useState } from 'react';
import { ethers } from 'ethers';
import './App.css';

function App() {
  const [isMetamaskConnected, setIsMetamaskConnected] = useState<boolean>(false);

  const connectMetamask = async (): Promise<void> => {
    const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    // Prompt user for account connections
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    if (signer) {
      setIsMetamaskConnected(true);
    }
  }
  
  return (
    <React.Fragment>
      <h1 className='center'>Blackjack</h1>
      <button onClick={connectMetamask}>Connect to Metamask to play</button>
    </React.Fragment>
  );
}

export default App;