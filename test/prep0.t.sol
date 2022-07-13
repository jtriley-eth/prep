// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract ContractTest is Test {
    address depositooor;
    address alice = address(1);

    // ONLY use attacker address.
    address attacker = address(2);

    function setUp() public {

        // Deploy contract
        // Source code: src/prep0.md
        bytes memory bytecode = hex"3360005561011f61001460003961011f6000f3fe60003560e01c63d0e30db0811461002b57633ccfd60b81146100495763fc7e286d811461008657600080fd5b610034336100a6565b34815401815561004434336100bd565b600080f35b341561005457600080fd5b61005d336100a6565b805460008060008084335af18061007357600080fd5b6000835561008182336100ee565b600080f35b341561009157600080fd5b61009c6004356100a6565b5460005260206000f35b600081600052600060205260406000209050919050565b7fe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c82600052818160206000a2505050565b7f884edad9ce6fa2440d8a54cc123490eb96d2768479d49ff9c7366125a942436482600052818160206000a250505056";
        assembly {
            sstore(depositooor.slot, create(0, add(bytecode, 0x20), mload(bytecode)))
        }
        require(depositooor != address(0), "deployment fail");

        // Set up with Alice
        vm.deal(alice, 10 ether);
        vm.prank(alice);
        bool success;

        (success, ) = depositooor.call{value: 10 ether}(hex"d0e30db0");
        require(success, "setup call fail");

        bytes memory returned;
        (success, returned) = depositooor.staticcall(abi.encodeWithSelector(hex"fc7e286d", alice));
        require(success, "setup staticcall fail");
        require(abi.decode(returned, (uint256)) == 10 ether, "setup staticcall returndata fail");

        // Give attacker 1 ether
        vm.deal(attacker, 1 ether);

        // Final smoke check
        assertEq(depositooor.balance, 10 ether);
        assertEq(alice.balance, 0 ether);
        assertEq(attacker.balance, 1 ether);
    }

    function testExploit() public {
        vm.startPrank(attacker);
        // YOUR EXPLOIT HERE
        // vm cheats are disallowed

        // DO NOT CHANGE
        // this is the success check
        assertEq(depositooor.balance, 0);
    }
}