import { useState } from 'react';
import { Button, Box, Container, TextField, Select, MenuItem, SelectChangeEvent } from '@mui/material';

import { BigNumber,utils } from 'ethers'
import { useBorrowFiAggregatorAggregateBorrow, usePrepareBorrowFiAggregatorAggregateBorrow } from '../utils/generated';
import { useContractRead, erc20ABI } from 'wagmi';

const toWei = utils.parseEther;
const ZERO  = BigNumber.from('0');

interface BorrowViewProps {
  myAddress?: `0x${string}`;
}

const BorrowView = (props: BorrowViewProps) => {
  const [coin, setCoin] = useState<string>('')
  const [collateral, setCollateral] = useState<string>(0)
  const [rate, setRate] = useState<number>(1.6)
  const [amount, setAmount] = useState<string>('')
  const handleChangeCoinType = (e: SelectChangeEvent) => {
    setCoin(e.target.value as string)
  }

  // const { data: wallet, } = useContractRead({
  //   address: '',
  //   abi: erc20ABI,
  //   functionName: 'balanceOf',
  //   args: [props.myAddress],
  //   {
  //     addressOrName: '0x71Ee2EBf3EB67e1536b9D861C40eed655523ccbE',
  //     contractInterface: wagmigotchiABI,
  //   },
  //   'getHunger',
  //   { enabled: false },
  // })

  // {wrapper: '0x09ac7b0886944A327c0A03B9547a1e263D5A2B1E', amount: BigNumber.from('100000000000000000')}
  const { config } = usePrepareBorrowFiAggregatorAggregateBorrow({
    // BorrowFiAggregator
    address: '0x0c03eCB91Cb50835e560a7D52190EB1a5ffba797',
    args: [
      // `asset`
      '0x71Ee2EBf3EB67e1536b9D861C40eed655523ccbE', // mock DAI
      // '0x6B175474E89094C44Da98b954EedeAC495271d0F', // prod DAI
      [
        {
          // wrapper: '0x09ac7b0886944A327c0A03B9547a1e263D5A2B1E', // aave v3 market
          // MockLendignProtocol
          wrapper: '0x73246A05ee4Ff05666F1E7D527B69E5199183000', // mock wrapper
          amount: amount ? toWei(amount): ZERO, // = toWei(amount)
        },
      ],
    ],
  })

  const { data, isLoading, isSuccess, write } = useBorrowFiAggregatorAggregateBorrow(config);

  // const { config, error } = usePrepareMockLendingMarketBorrow({
  //   address: address,
  //   args: [
  //     '0x5FbDB2315678afecb367f032d93F642f64180aa3',
  //     BigNumber.from('42'),
  //     props.myAddress ?? '0x',
  //     props.myAddress ?? '0x',
  //   ],
  // })
  // const { write } = useMockLendingMarketBorrow(config)
  
  return (
    <Container
      sx={{
        boxShadow: 2,
        fontWeight: 'bold',
        py: 12,
        px: 12,
        borderRadius: 20,
        backgroundColor: 'white',
      }}
    >
      <Box
        sx={{
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'space-between',
        }}
      >
        <p>Amount to Borrow</p>
        <TextField
          inputProps={{ inputMode: 'numeric', pattern: '[0-9]*' }}
          onChange={(e) => setCollateral(`${Number(e.target.value) * 1.2}`)}
        />
        <Select
          labelId="select-coins"
          id="select-coints"
          value={coin}
          label="Age"
          onChange={handleChangeCoinType}
          color="info"
          sx={{ minWidth: 120 }}
        >
          <MenuItem value={'USDC'}>USDC</MenuItem>
          <MenuItem value={'ETH'}>ETH</MenuItem>
        </Select>
      </Box>
      <hr></hr>
      <Box
        sx={{
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'space-between',
        }}
      >
        <p>Collateral Required</p>
        <p>{collateral}</p>
        <p>ETH</p>
      </Box>
      <Box
        sx={{
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'space-between',
        }}
      >
        <p>Effective borrow APY</p>
        <p>{`${rate}%`}</p>
        <p>APY</p>
      </Box>
      <Button
        size="large"
        variant="outlined"
        type="button"
        onClick={() => {
          write?.()
        }}
      >
        Confirm Borrow
      </Button>
      {isLoading && <div>Processing...</div>}
      {isSuccess && (
        <div>
          <hr></hr>
          Transaction has completed:
          <Button size="large" variant="outlined" color="info" type="button">
            {data.hash}
          </Button>
        </div>
      )}
    </Container>
  )
}

export default BorrowView

