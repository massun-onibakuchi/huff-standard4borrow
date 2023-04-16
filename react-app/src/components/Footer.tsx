import { useEffect, useState } from 'react'
import { getAaveLastBorrowedDocument, execute } from '../.graphclient/'
import { Grid, Box } from '@mui/material'

interface FooterProps {}
const Footer = (props: FooterProps) => {
  const calcAPY = (liquidityRate: number) => {
    return (((1 + ((liquidityRate / 10**27) / 31536000)) ** 31536000) - 1) * 100
  }

  const [data, setData] = useState<number>()
  useEffect(() => {
    execute(getAaveLastBorrowedDocument, {}).then((result) => {
      console.log(result)
      setData(calcAPY(parseInt(result?.data.borrows[0].reserve.liquidityRate)))
    })
    
  }, [setData])
  return (
    <Box sx={{ flexGrow: 1 }}>
      <Grid container spacing={2} sx={{ justifyContent: 'space-around' }}>
        <Grid item xs={2} sx={{ backgroundColor: 'white', borderRadius: 4 }} pr={2}>
          <h1>AAVE</h1>
          <h3>{`${Math.round((data ?? 0) * 100) / 100}%`}</h3>
        </Grid>
        <Grid item xs={2} sx={{ backgroundColor: 'white', borderRadius: 4 }} pr={2}>
          <h1>MakerDAO</h1>
          <h3>1.75%</h3>
        </Grid>
        <Grid item xs={2} sx={{ backgroundColor: 'white', borderRadius: 4 }} pr={2}>
          <h1>Compound</h1>
          <h3>3.16%</h3>
        </Grid>
        <Grid item xs={2} sx={{ backgroundColor: 'white', borderRadius: 4 }} pr={2}>
          <h1>Venus</h1>
          <h3>2.21%</h3>
        </Grid>
      </Grid>
    </Box>
  )
}

export default Footer
