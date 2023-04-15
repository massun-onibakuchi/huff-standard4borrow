import styled from "styled-components"

import { BigNumber } from "ethers"
import { useMockLendingMarketBorrow, usePrepareMockLendingMarketBorrow } from "../utils/generated"


const BorrowView = () => {
  const { config, error } = usePrepareMockLendingMarketBorrow({
    address: '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
    args: [
      '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512',
      BigNumber.from('42'),
      '0x70997970C51812dc3A010C7d01b50e0d17dc79C8',
      '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
    ],
  })
  const { write } = useMockLendingMarketBorrow(config)
  return (
    <Container>
      <Info>
        <p>Amount to Borrow</p>
        <Amount type="number" min={0}/>
        <Coins name="coin">
          <option value="USDC">USDC</option>
          <option value="ETH">ETH</option>
        </Coins>
      </Info>
      <hr></hr>
      <Info>
        <p>Collateral Required</p>
        <p>5.12</p>
        <p>ETH</p>
      </Info>
      <Info>
        <p>Rate</p>
        <p>2.88%</p>
        <p>APY</p>
      </Info>
      <Confirm type="button" disabled={!write} onClick={() => write?.()}>Confirm Borrow</Confirm>
    </Container>
  )
}

export default BorrowView

const Container = styled.div`
  background-color: #d9d9d9;
  padding: 32px;
`

const Amount = styled.input`
  background-color: #d9d9d9;
  font-size: 20px;
  font-weight: bold;
  border: none;
  border-bottom: 1px solid black;
`

const Coins = styled.select`
  background-color: #d9d9d9;
  width: 132px;
  text-align: center;
  font-size: 20px;
  font-weight: bold;
`

const Info = styled.div`
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  text-align: left;
  font-size: 20px;
  font-weight: bold;
  padding: 8px 64px;
`

const Confirm = styled.button`
  background-color: #d9d9d9;
  width: 240px;
  height: 64px;
  border: solid 1px;
  font-size: 20px;
  font-weight: bold;
`