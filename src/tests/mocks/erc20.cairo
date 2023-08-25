#[starknet::interface]
trait IERC20<TContractState> {
    fn balance_of(self: @TContractState, account: starknet::ContractAddress) -> u256;

    fn transfer_from(
        ref self: TContractState,
        sender: starknet::ContractAddress,
        recipient: starknet::ContractAddress,
        amount: u256
    ) -> bool;
}

#[starknet::interface]
trait MockERC20ABI<TContractState> {
    fn balance_of(self: @TContractState, account: starknet::ContractAddress) -> u256;

    fn transfer_from(
        ref self: TContractState,
        sender: starknet::ContractAddress,
        recipient: starknet::ContractAddress,
        amount: u256
    ) -> bool;
}

#[starknet::contract]
mod erc20 {
    use super::IERC20;
    use zeroable::Zeroable;

    //
    // Storage
    //

    #[storage]
    struct Storage {
        _balances: LegacyMap<starknet::ContractAddress, u256>,
    }

    //
    // Constructor
    //

    #[constructor]
    fn constructor(
        ref self: ContractState, initial_supply: u256, recipient: starknet::ContractAddress
    ) {
        self._mint(recipient, initial_supply);
    }

    //
    // Interface impl
    //

    #[external(v0)]
    impl IERC20Impl of IERC20<ContractState> {
        fn balance_of(self: @ContractState, account: starknet::ContractAddress) -> u256 {
            self._balances.read(account)
        }

        fn transfer_from(
            ref self: ContractState,
            sender: starknet::ContractAddress,
            recipient: starknet::ContractAddress,
            amount: u256
        ) -> bool {
            self._transfer(sender, recipient, amount);
            true
        }
    }

    #[external(v0)]
    fn transferFrom(
        ref self: ContractState,
        sender: starknet::ContractAddress,
        recipient: starknet::ContractAddress,
        amount: u256
    ) -> bool {
        self.transfer_from(sender, recipient, amount)
    }

    //
    // Helpers
    //

    #[generate_trait]
    impl HelperImpl of HelperTrait {
        fn _mint(ref self: ContractState, recipient: starknet::ContractAddress, amount: u256) {
            assert(!recipient.is_zero(), 'ERC20: mint to 0');

            self._balances.write(recipient, self._balances.read(recipient) + amount);
        }

        fn _transfer(
            ref self: ContractState,
            sender: starknet::ContractAddress,
            recipient: starknet::ContractAddress,
            amount: u256
        ) {
            assert(!sender.is_zero(), 'ERC20: transfer from 0');
            assert(!recipient.is_zero(), 'ERC20: transfer to 0');

            self._balances.write(sender, self._balances.read(sender) - amount);
            self._balances.write(recipient, self._balances.read(recipient) + amount);
        }
    }
}
