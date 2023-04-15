import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

import { WagmiConfig, createClient, configureChains } from 'wagmi'
import { localhost } from '@wagmi/chains';
import { publicProvider } from 'wagmi/providers/public'


const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);


const { chains, provider, webSocketProvider } = configureChains([localhost], [publicProvider()])


const client = createClient({
  autoConnect: true,
  provider,
  webSocketProvider,
})

root.render(
  <WagmiConfig client={client}>
    <React.StrictMode>
      <App />
    </React.StrictMode>
  </WagmiConfig>
)
