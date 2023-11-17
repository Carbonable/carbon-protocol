use starknet::ContractAddress;

#[starknet::interface]
trait IAbsorber<TContractState> {
    /// Returns the first timestamp of the absorption for the given slot.
    fn get_start_time(self: @TContractState, slot: u256) -> u64;

    /// Returns the last timestamp of the absorption for the given slot.
    fn get_final_time(self: @TContractState, slot: u256) -> u64;

    /// Returns the times of the absorption for the given slot.
    fn get_times(self: @TContractState, slot: u256) -> Span<u64>;

    /// Returns the absorptions for the given slot.
    fn get_absorptions(self: @TContractState, slot: u256) -> Span<u64>;

    /// Returns the absorption for the given slot and timestamp.
    fn get_absorption(self: @TContractState, slot: u256, time: u64) -> u64;

    /// Returns the absorption at the current timestamp for the given slot.
    fn get_current_absorption(self: @TContractState, slot: u256) -> u64;

    /// Returns the total absorption for the given slot.
    fn get_final_absorption(self: @TContractState, slot: u256) -> u64;

    /// Returns the project value for the given slot.
    fn get_project_value(self: @TContractState, slot: u256) -> u256;

    /// Returns the ton equivalent for the given slot.
    fn get_ton_equivalent(self: @TContractState, slot: u256) -> u64;

    /// Returns true is the given slot has been setup.
    fn is_setup(self: @TContractState, slot: u256) -> bool;

    /// Setup the absorption curve parameters for the given slot.
    fn set_absorptions(
        ref self: TContractState,
        slot: u256,
        times: Span<u64>,
        absorptions: Span<u64>,
        ton_equivalent: u64
    );

    /// Setup the project value for the given slot.
    fn set_project_value(ref self: TContractState, slot: u256, project_value: u256);
}
