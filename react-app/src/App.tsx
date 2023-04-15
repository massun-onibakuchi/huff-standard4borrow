import styled from "styled-components"

import Header from "./components/Header"
import BorrowView from "./components/BorrowView"

import { useAccount, useConnect, useDisconnect } from 'wagmi'
import { InjectedConnector } from 'wagmi/connectors/injected'

const App = () => {
  const { address, isConnected } = useAccount()
  const { connect } = useConnect({
    connector: new InjectedConnector(),
  })
  const { disconnect } = useDisconnect()
  return (
    <Container>
      <Header onClickConnect={() => (isConnected ? disconnect () : connect())} isConnected={isConnected} />
      <main>
        <Title>Borrow Aggregator for DeFi</Title>
        {isConnected ? <BorrowView myAddress={address} /> : <p>You should connect the wallet to borrow.</p>}
      </main>
    </Container>
  )
}

export default App

const Container = styled.div`
  text-align: center;
  & > main {
    padding: 64px 128px;
  }
`

const Title = styled.h1`
  font-size: 48px;
  margin: 32px;
`
