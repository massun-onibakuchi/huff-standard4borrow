import {Container} from "@mui/material";
import logo from "../assets/logo.png"

import { Button } from "@mui/material";

interface HeaderProps {
  onClickConnect?: (e: any) => void;
  isConnected: boolean;
}

const Header = (props: HeaderProps) => {
  return (
    <Container sx={{
      backgroundColor: 'transparent',
      display: 'flex',
      justifyContent: 'space-between',
    }}>
      <img src={logo} ></img>
      <Button variant="contained" sx={{borderRadius: 6, height: 72, m: 2}} onClick={props.onClickConnect}>{props.isConnected ? 'Disconnect' : 'Connect'}</Button>
    </Container>
  )
}

export default Header
