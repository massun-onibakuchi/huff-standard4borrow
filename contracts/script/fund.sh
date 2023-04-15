export USER=0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266
export DAI=0x6b175474e89094c44da98b954eedeac495271d0f
export LUCKY_USER=0xad0135af20fa82e106607257143d0060a7eb5cbf

v=$(cast call --rpc-url=http://127.0.0.1:8545 $DAI  "balanceOf(address)(uint256)" $LUCKY_USER)

echo $v

cast rpc --rpc-url=http://127.0.0.1:8545 anvil_impersonateAccount $LUCKY_USER

cast send --rpc-url=http://127.0.0.1:8545 $DAI --from $LUCKY_USER  "transfer(address,uint256)(bool)" $USER $v

bal=$(cast call --rpc-url=http://127.0.0.1:8545 $DAI "balanceOf(address)(uint256)" $USER)

echo $bal

# orge script --rpc-url=http://localhost:8545 --broadcast --private-key=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --sender=0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 script/BorrowFiAggregatorDeploy.sol