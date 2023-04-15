import styled from "styled-components"
import logo from "../assets/logo.png"

interface HeaderProps {
  onClickConnect?: (e: any) => void;
  isConnected: boolean;
}

const Header = (props: HeaderProps) => {
  return <Container>
    <Logo src={logo} />
    <button onClick={props.onClickConnect}>{props.isConnected ? "Disconnect" : "Connect"}</button>
  </Container>
}

export default Header

const Container = styled.div`
  display: flex;
  background-color: #D7D7D7;
  justify-content: space-between;
  padding: 16px 48px;

  & > button {
    font-size: 28px;
    margin: 0;
    text-align: center;
    border: none;
    background-color: transparent;
    &:hover {
      cursor: pointer;
    }
  }
`

const Logo = styled.img`
  height: 64px;
`