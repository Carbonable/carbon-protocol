#[starknet::contract]
mod Absorber {
    use starknet::{get_block_timestamp, get_caller_address, ContractAddress};
    use traits::Into;
    use array::{ArrayTrait, SpanTrait};
    use alexandria_numeric::interpolate::{interpolate, Interpolation, Extrapolation};
    use alexandria_storage::list::{List, ListTrait};
    use protocol::absorber::interface::IAbsorber;

    #[storage]
    struct Storage {
        _ton_equivalent: LegacyMap<u256, u64>,
        _project_value: LegacyMap<u256, u256>,
        _times: LegacyMap<u256, List<u64>>,
        _absorptions: LegacyMap<u256, List<u64>>,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        AbsorptionUpdate: AbsorptionUpdate,
        ProjectValueUpdate: ProjectValueUpdate,
    }

    #[derive(Drop, starknet::Event)]
    struct AbsorptionUpdate {
        slot: u256,
        time: u64,
    }

    #[derive(Drop, starknet::Event)]
    struct ProjectValueUpdate {
        slot: u256,
        value: u256
    }

    #[external(v0)]
    impl AbsorberImpl of IAbsorber<ContractState> {
        // Absorption
        fn get_start_time(self: @ContractState, slot: u256) -> u64 {
            self._times.read(slot)[0]
        }
        fn get_final_time(self: @ContractState, slot: u256) -> u64 {
            let times = self._times.read(slot);
            if times.len() == 0 {
                return 0;
            }
            times[times.len() - 1]
        }
        fn get_times(self: @ContractState, slot: u256) -> Span<u64> {
            self._times.read(slot).array().span()
        }
        fn get_absorptions(self: @ContractState, slot: u256) -> Span<u64> {
            self._absorptions.read(slot).array().span()
        }
        fn get_absorption(self: @ContractState, slot: u256, time: u64) -> u64 {
            let times = self._times.read(slot).array();
            let absorptions = self._absorptions.read(slot).array();
            interpolate(
                time,
                times.span(),
                absorptions.span(),
                Interpolation::Linear(()),
                Extrapolation::Constant(())
            )
        }
        fn get_current_absorption(self: @ContractState, slot: u256) -> u64 {
            self.get_absorption(slot, get_block_timestamp())
        }
        fn get_final_absorption(self: @ContractState, slot: u256) -> u64 {
            let absorptions = self._absorptions.read(slot);
            if absorptions.len() == 0 {
                return 0;
            }
            absorptions[absorptions.len() - 1]
        }
        fn get_project_value(self: @ContractState, slot: u256) -> u256 {
            self._project_value.read(slot)
        }
        fn get_ton_equivalent(self: @ContractState, slot: u256) -> u64 {
            self._ton_equivalent.read(slot)
        }
        fn is_setup(self: @ContractState, slot: u256) -> bool {
            self._project_value.read(slot)
                * self._times.read(slot).len().into()
                * self._absorptions.read(slot).len().into()
                * self._ton_equivalent.read(slot).into() != 0
        }
        fn set_absorptions(
            ref self: ContractState,
            slot: u256,
            times: Span<u64>,
            absorptions: Span<u64>,
            ton_equivalent: u64
        ) {
            // [Check] Times and prices are defined
            assert(times.len() == absorptions.len(), 'Times and absorptions mismatch');
            assert(times.len() > 0, 'Inputs cannot be empty');

            // [Effect] Clean times and absorptions
            let mut stored_times = self._times.read(slot);
            let mut stored_absorptions = self._absorptions.read(slot);
            let mut index = stored_times.len();
            loop {
                if index == 0 {
                    break;
                }
                stored_times.pop_front();
                stored_absorptions.pop_front();
                index -= 1;
            };

            // [Effect] Store new times and absorptions
            let mut index = 0;
            stored_times.append(*times[index]);
            stored_absorptions.append(*absorptions[index]);
            loop {
                index += 1;
                if index == times.len() {
                    break;
                }
                // [Check] Times are sorted
                assert(*times[index] > *times[index - 1], 'Times not sorted');
                // [Check] Absorptions are sorted
                assert(*absorptions[index] >= *absorptions[index - 1], 'Absorptions not sorted');
                // [Effect] Store values
                stored_times.append(*times[index]);
                stored_absorptions.append(*absorptions[index]);
            };

            // [Effect] Store new ton equivalent
            self._ton_equivalent.write(slot, ton_equivalent);
        }
        fn set_project_value(ref self: ContractState, slot: u256, project_value: u256) {
            self._project_value.write(slot, project_value);
        }
    }
}
