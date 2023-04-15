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
      justfyContent: 'space-between',
      px: 16,
    }}>
      <img src={logo} ></img>
      <Button variant="contained" sx={{borderRadius: 10}} onClick={props.onClickConnect}>{props.isConnected ? 'Disconnect' : 'Connect'}</Button>
    </Container>
  )
}

export default Header
