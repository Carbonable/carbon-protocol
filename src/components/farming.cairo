use starknet::ContractAddress;
use starknet::{get_caller_address, get_contract_address};
use protocol::interfaces::project::{IProjectDispatcher, IProjectDispatcherTrait};

const TIME_SK: felt252 = 'TIME';
const PRICE_SK: felt252 = 'PRICE';
const YEAR_SECONDS: u64 = 31556925;

#[starknet::contract_state(FarmingState)]
struct FarmingStorage {
    project: ContractAddress,
    slot: u256,
    total_absorption: u256,
    total_sale: u256,
    total_registered_value: u256,
    total_registered_time: u256,
    absorption: LegacyMap::<ContractAddress, u256>,
    sale: LegacyMap::<ContractAddress, u256>,
    registered_value: LegacyMap::<ContractAddress, u256>,
    registered_time: LegacyMap::<ContractAddress, u256>,
}

#[starknet::interface]
trait Farming<TContractState> {
    fn initializer(self: @TContractState, project: ContractAddress, slot: u256);
    fn get_project(self: @TContractState) -> ContractAddress;
    fn get_slot(self: @TContractState) -> u256;
    fn get_max_absorption(self: @TContractState) -> u256;
    fn get_max_sale(self: @TContractState) -> u256;
    fn get_total_deposited(self: @TContractState) -> u256;
    fn get_total_absorption(self: @TContractState) -> u256;
    fn get_total_sale(self: @TContractState) -> u256;
    fn get_deposited_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_absorption_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_sale_of(self: @TContractState, account: ContractAddress) -> u256;
    fn get_current_price(self: @TContractState) -> u256;
    fn get_prices(self: @TContractState) -> (Array<u64>, Array<u256>, Array<u256>, Array<u256>);
    fn get_apr(self: @TContractState) -> u256;
    fn deposit(self: @TContractState, token_id: u256, value: u256);
    fn withdraw_to(self: @TContractState, value: u256);
    fn withdraw_to_token(self: @TContractState, token_id: u256, value: u256);
    fn claim(self: @TContractState);
    fn add_price(self: @TContractState, time: u64, price: u256);
    fn update_last_price(self: @TContractState, time: u64, price: u256);
    // TODO: must be remove before mainnet
    fn set_prices(self: @TContractState, times: Array<u64>, prices: Array<u256>);
}

#[starknet::component]
impl FarmingImpl<
    TContractState, impl I: GetComponent<TContractState, FarmingState>
> of Farming<TContractState> {
    fn initializer(self: @TContractState, project: ContractAddress, slot: u256) {
        self.component_snap().project.write(project);
        self.component_snap().slot.write(slot);
    }

    fn get_project(self: @TContractState) -> ContractAddress {
        self.component_snap().project.read();
    }

    fn get_slot(self: @TContractState) -> u256 {
        self.component_snap().slot.read()
    }

    fn get_max_absorption(self: @TContractState) -> u256 {
        IProjectDispatcher { contract_address: self.component_snap().project.read() }
            .getCurrentAbsorption(slot: self.component_snap().slot.read())
    }

    fn get_max_sale(self: @TContractState) -> u256 {
        0_u256
    }

    fn get_total_deposited(self: @TContractState) -> u256 {
        self.component_snap().total_registered_value.read()
    }

    fn get_total_absorption(self: @TContractState) -> u256 {
        let computed = _compute_total_absorption();
        let stored = self.component_snap().total_absorption.read();
        computed + stored
    }

    fn get_total_sale(self: @TContractState) -> u256 {
        let computed = _compute_total_sale();
        let stored = self.component_snap().total_sale.read();
        computed + stored
    }

    fn get_deposited_of(self: @TContractState, account: ContractAddress) -> u256 {
        self.component_snap().registered_value.read(account)
    }

    fn get_absorption_of(self: @TContractState, account: ContractAddress) -> u256 {
        let computed = _compute_absorption_of(account);
        let stored = self.component_snap().absorption.read(account);
        computed + stored
    }

    fn get_sale_of(self: @TContractState, account: ContractAddress) -> u256 {
        let computed = _compute_sale_of(account);
        let stored = self.component_snap().sale.read(account);
        computed + stored
    }

    fn deposit(self: @TContractState, token_id: u256, value: u256) {
        // [Check] Value is not null
        assert(value != 0_u256, 'Farming: value is null');

        // [Check] Token id is owned by caller
        let owner = IProjectDispatcher
            .ownerOf(contract_address = self.component_snap().project.read(), token_id = token_id);
        let caller = get_caller_address();
        assert(owner == caller, 'Farming: not the token owner');

        // [Effect]
        let to_token_id = _get_token_id();
        if to_token_id == 0_u256 {
            let this = get_contract_address();
        }
    }

    fn _deposit(
        self: @TContractState,
        from_token_id: u256,
        to_token_id: u256,
        to: ContractAddress,
        value: u256
    ) {
        // [Effect] Store absorption
        let caller = get_caller_address();
        let absorption = Farming.get_absorption_of(account = caller);
        Farming.set_absorption_of(account = caller, value = absorption + value);
    }
}

fn _compute_total_absorption() -> u256 {
    0_u256
}
fn _compute_total_sale() -> u256 {
    0_u256
}

fn _get_token_id() -> u256 {
    // [Check] Contract token balance
    let this = get_contract_address();
    let balance = IProject
        .balanceOf(contract_address = self.component_snap().project.read(), owner = this);

    // [Check] Balance is null then return 0
    if balance == 0_u256 {
        return 0_u256;
    }

    // [Check] Otherwise return the first token id
    IProject
        .tokenOfOwnerByIndex(
            contract_address = self.component_snap().project.read(), owner = this, index = 0_u256
        )
}
