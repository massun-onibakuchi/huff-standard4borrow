import { useState } from 'react';
import { Button, Box, Container, TextField, Select, MenuItem, SelectChangeEvent } from '@mui/material';

import { BigNumber } from 'ethers'


interface BorrowViewProps {
  myAddress?: `0x${string}`;
}

const BorrowView = (props: BorrowViewProps) => {
  // const { config, error } = usePrepareMockLendingMarketBorrow({
  //   address: '0x6D544390Eb535d61e196c87d6B9c80dCD8628Acd',
  //   args: [
  //     '0x5FbDB2315678afecb367f032d93F642f64180aa3',
  //     BigNumber.from('42'),
  //     props.myAddress,
  //     props.myAddress,
  //   ],
  // })
  // const { write } = useMockLendingMarketBorrow(config)　
  const [coin, setCoin] = useState<string>('')
  const [collateral, setCollateral] = useState<number>(0)
  const [rate, setRate] = useState<number>(0)
  const handleChangeCoinType = (e: SelectChangeEvent) => {
    setCoin(e.target.value as string)
  }
  return (
    <Container sx={{
      boxShadow: 2,
      fontWeight: 'bold',
      py: 12,
      px: 12,
      borderRadius: 20
    }}>
      <Box sx={{
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'space-between'
      }}>
        <p>Amount to Borrow</p>
        <TextField inputProps={{ inputMode: 'numeric', pattern: '[0-9]*' }} />
        <Select
          labelId="select-coins"
          id="select-coints"
          value={coin}
          label="Age"
          onChange={handleChangeCoinType}
          color="info"
          sx={{minWidth: 120}}
        >
          <MenuItem value={'ETH'}>ETH</MenuItem>
          <MenuItem value={'USDC'}>USDC</MenuItem>
        </Select>
      </Box>
      <hr></hr>
      <Box sx={{
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'space-between'
      }}>
        <p>Collateral Required</p>
        <p>{collateral}</p>
        <p>ETH</p>
      </Box>
      <Box sx={{
        display: 'flex',
        flexDirection: 'row',
        justifyContent: 'space-between'
      }}>
        <p>Rate</p>
        <p>{`${rate}%`}</p>
        <p>APY</p>
      </Box>
      <Button size="large" variant="outlined" type="button" onClick={() => {}}>
        Confirm Borrow
      </Button>
    </Container>
  )
}

export default BorrowView

