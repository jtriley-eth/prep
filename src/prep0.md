## Prep 0

```yul
object "Depositooor" {
    code {
        // -----------------------------------------------------------------------------------------
        // Constructor

        // Store the creator in slot zero.
        sstore(0, caller())

        // Deploy the contract
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }
    object "runtime" {
        code {
            // -------------------------------------------------------------------------------------
            // Dispatch

            switch shr(0xe0, calldataload(0x00))
            case 0xd0e30db0 {
                let storage_ptr := deposit_ptr(caller())
                sstore(storage_ptr, add(sload(storage_ptr), callvalue()))
                log_deposit(caller(), callvalue())
            }
            case 0x3ccfd60b {
                if iszero(iszero(callvalue())) { revert(0x00, 0x00) }
                let storage_ptr := deposit_ptr(caller())
                let amount := sload(storage_ptr)
                let res := call(gas(), caller(), amount, 0x00, 0x00, 0x00, 0x00)
                if iszero(res) { revert(0x00, 0x00) }
                sstore(storage_ptr, 0x00)
                log_withdrawal(caller(), amount)
            }
            case 0xfc7e286d {
                if iszero(iszero(callvalue())) { revert(0x00, 0x00) }
                mstore(0x00, sload(deposit_ptr(caller())))
                return(0x00, 0x20)
            }
            default {
                revert(0x00, 0x00)
            }

            // -------------------------------------------------------------------------------------
            // Storage
            function deposit_ptr(account) -> offset {
                mstore(0x00, account)
                mstore(0x20, 0x00)
                offset := keccak256(0x00, 0x40)
            }

            // -------------------------------------------------------------------------------------
            // Events
            function log_deposit(account, amount) {
                let hash := 0xe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c
                mstore(0, amount)
                log2(0x00, 0x20, hash, account)
            }

            function log_withdrawal(account, amount) {
                let hash := 0x884edad9ce6fa2440d8a54cc123490eb96d2768479d49ff9c7366125a9424364
                mstore(0x00, amount)
                log2(0x00, 0x20, hash, account)
            }
        }
    }
}
```
