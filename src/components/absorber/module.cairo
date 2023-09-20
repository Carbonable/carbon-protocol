#[starknet::contract]
mod Absorber {
    use starknet::{get_block_timestamp, get_caller_address, ContractAddress};
    use traits::Into;
    use array::{ArrayTrait, SpanTrait};
    use alexandria_numeric::interpolate::{interpolate, Interpolation, Extrapolation};
    use alexandria_storage::list::{List, ListTrait};
    use carbon::components::absorber::interface::IAbsorber;

    #[storage]
    struct Storage {
        _absorber_ton_equivalent: LegacyMap<u256, u64>,
        _absorber_project_value: LegacyMap<u256, u256>,
        _absorber_times: LegacyMap<u256, List<u64>>,
        _absorber_absorptions: LegacyMap<u256, List<u64>>,
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

    impl AbsorberImpl of IAbsorber<ContractState> {
        // Absorption
        fn get_start_time(self: @ContractState, slot: u256) -> u64 {
            let times = self._absorber_times.read(slot);
            if times.len() == 0 {
                return 0;
            }
            times[0]
        }
        fn get_final_time(self: @ContractState, slot: u256) -> u64 {
            let times = self._absorber_times.read(slot);
            if times.len() == 0 {
                return 0;
            }
            times[times.len() - 1]
        }
        fn get_times(self: @ContractState, slot: u256) -> Span<u64> {
            self._absorber_times.read(slot).array().span()
        }
        fn get_absorptions(self: @ContractState, slot: u256) -> Span<u64> {
            self._absorber_absorptions.read(slot).array().span()
        }
        fn get_absorption(self: @ContractState, slot: u256, time: u64) -> u64 {
            let times = self._absorber_times.read(slot);
            if times.len() == 0 {
                return 0;
            }

            let absorptions = self._absorber_absorptions.read(slot);
            if absorptions.len() == 0 {
                return 0;
            }

            // [Compute] Convert into u256 to avoid overflow
            let time_u256: u256 = time.into();
            let times_u256 = self.__list_u64_into_u256(@times);
            let absorptions_u256 = self.__list_u64_into_u256(@absorptions);
            let absorption = interpolate(
                time_u256,
                times_u256,
                absorptions_u256,
                Interpolation::Linear(()),
                Extrapolation::Constant(())
            );
            absorption.try_into().expect('Absorber: Absorption overflow')
        }
        fn get_current_absorption(self: @ContractState, slot: u256) -> u64 {
            self.get_absorption(slot, get_block_timestamp())
        }
        fn get_final_absorption(self: @ContractState, slot: u256) -> u64 {
            let absorptions = self._absorber_absorptions.read(slot);
            if absorptions.len() == 0 {
                return 0;
            }
            absorptions[absorptions.len() - 1]
        }
        fn get_project_value(self: @ContractState, slot: u256) -> u256 {
            self._absorber_project_value.read(slot)
        }
        fn get_ton_equivalent(self: @ContractState, slot: u256) -> u64 {
            self._absorber_ton_equivalent.read(slot)
        }
        fn is_setup(self: @ContractState, slot: u256) -> bool {
            self._absorber_project_value.read(slot)
                * self._absorber_times.read(slot).len().into()
                * self._absorber_absorptions.read(slot).len().into()
                * self._absorber_ton_equivalent.read(slot).into() != 0
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
            assert(ton_equivalent > 0, 'Ton equivalent must be positive');

            // [Effect] Clean times and absorptions
            let mut stored_times = self._absorber_times.read(slot);
            stored_times.len = 0;
            let mut stored_absorptions = self._absorber_absorptions.read(slot);
            stored_absorptions.len = 0;

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
            self._absorber_ton_equivalent.write(slot, ton_equivalent);

            // [Event] Emit event
            let current_time = get_block_timestamp();
            self.emit(Event::AbsorptionUpdate(AbsorptionUpdate { slot: slot, time: current_time }));
        }
        fn set_project_value(ref self: ContractState, slot: u256, project_value: u256) {
            // [Event] Update storage
            self._absorber_project_value.write(slot, project_value);

            // [Event] Emit event
            self
                .emit(
                    Event::ProjectValueUpdate(
                        ProjectValueUpdate { slot: slot, value: project_value }
                    )
                );
        }
    }

    #[generate_trait]
    impl PrivateImpl of PrivateTrait {
        fn __list_u64_into_u256(self: @ContractState, list: @List<u64>) -> Span<u256> {
            let mut array = ArrayTrait::<u256>::new();
            let mut index = 0;
            loop {
                if index == list.len() {
                    break ();
                }
                array.append(list[index].into());
                index += 1;
            };
            array.span()
        }
    }
}


#[cfg(test)]
mod Test {
    use starknet::testing::set_block_timestamp;
    use super::Absorber;

    fn STATE() -> Absorber::ContractState {
        Absorber::contract_state_for_testing()
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_setup() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![0, 1179750, 2359500, 3539250, 4719000].span();
        let ton_equivalent = 1;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
        let project_value = 100;
        Absorber::AbsorberImpl::set_project_value(ref state, 0, project_value);
        // [Assert] Absorber is setup
        let is_setup = Absorber::AbsorberImpl::is_setup(@state, 0);
        assert(is_setup, 'Absorber is not setup');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_not_setup_missing_project_value() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![0, 1179750, 2359500, 3539250, 4719000].span();
        let ton_equivalent = 1;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
        // [Assert] Absorber is setup
        let is_setup = Absorber::AbsorberImpl::is_setup(@state, 0);
        assert(!is_setup, 'Absorber is not setup');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_not_setup_missing_absorptions() {
        // [Setup]
        let mut state = STATE();
        let project_value = 100;
        Absorber::AbsorberImpl::set_project_value(ref state, 0, project_value);
        // [Assert] Absorber is setup
        let is_setup = Absorber::AbsorberImpl::is_setup(@state, 0);
        assert(!is_setup, 'Absorber is not setup');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_project_value() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Project value is 0 by default
        let project_value = Absorber::AbsorberImpl::get_project_value(@state, 0);
        assert(project_value == 0, 'Wrong project value');
        // [Assert] Project value is set correctly
        Absorber::AbsorberImpl::set_project_value(ref state, 0, 100);
        let project_value = Absorber::AbsorberImpl::get_project_value(@state, 0);
        assert(project_value == 100, 'Wrong project value');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_absorptions() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![0, 1179750, 2359500, 3539250, 4719000].span();
        let ton_equivalent = 1;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
        // [Assert] Times are set correctly
        let stored_times = Absorber::AbsorberImpl::get_times(@state, 0);
        assert(stored_times == times, 'Wrong times');
        // [Assert] Absorptions are set correctly
        let stored_absorptions = Absorber::AbsorberImpl::get_absorptions(@state, 0);
        assert(stored_absorptions == absorptions, 'Wrong absorptions');
        // [Assert] Ton equivalent is set correctly
        let stored_ton_equivalent = Absorber::AbsorberImpl::get_ton_equivalent(@state, 0);
        assert(stored_ton_equivalent == ton_equivalent, 'Wrong ton equivalent');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_current_absorption() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![
            0, 1179750000000, 2359500000000, 3539250000000, 4719000000000
        ]
            .span();
        let ton_equivalent = 1000000;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
        // [Assert] Before start, absorption = absorptions[0]
        set_block_timestamp(*times.at(0) - 86000);
        let absorption = Absorber::AbsorberImpl::get_current_absorption(@state, 0);
        assert(absorption == *absorptions.at(0), 'Wrong absorption');
        // [Assert] At start, absorption = absorptions[0]
        set_block_timestamp(*times.at(0));
        let absorption = Absorber::AbsorberImpl::get_current_absorption(@state, 0);
        assert(absorption == *absorptions.at(0), 'Wrong absorption');
        // [Assert] After start, absorptions[0] < absorption < absorptions[1]
        set_block_timestamp(*times.at(0) + 86000);
        let absorption = Absorber::AbsorberImpl::get_current_absorption(@state, 0);
        assert(absorption > *absorptions.at(0), 'Wrong absorption');
        assert(absorption < *absorptions.at(1), 'Wrong absorption');
        // [Assert] Before end, absorptions[-2] < absorption < absorptions[-1]
        set_block_timestamp(*times.at(times.len() - 1) - 86000);
        let absorption = Absorber::AbsorberImpl::get_current_absorption(@state, 0);
        assert(absorption > *absorptions.at(absorptions.len() - 2), 'Wrong absorption');
        assert(absorption < *absorptions.at(absorptions.len() - 1), 'Wrong absorption');
        // [Assert] At end, absorption = absorptions[-1]
        set_block_timestamp(*times.at(times.len() - 1));
        let absorption = Absorber::AbsorberImpl::get_current_absorption(@state, 0);
        assert(absorption == *absorptions.at(absorptions.len() - 1), 'Wrong absorption');
        // [Assert] After end, absorption = absorptions[-1]
        set_block_timestamp(*times.at(times.len() - 1) + 86000);
        let absorption = Absorber::AbsorberImpl::get_current_absorption(@state, 0);
        assert(absorption == *absorptions.at(absorptions.len() - 1), 'Wrong absorption');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_current_absorption_zero_not_set() {
        // [Setup]
        let mut state = STATE();
        set_block_timestamp(86000);
        let absorption = Absorber::AbsorberImpl::get_current_absorption(@state, 0);
        assert(absorption == 0, 'Wrong absorption');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_start_time() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![0, 1179750, 2359500, 3539250, 4719000].span();
        let ton_equivalent = 1000000;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
        // [Assert] Start time = times[0]
        let time = Absorber::AbsorberImpl::get_start_time(@state, 0);
        assert(time == *times.at(0), 'Wrong time');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_start_time_zero_not_set() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Start time = 0
        let time = Absorber::AbsorberImpl::get_start_time(@state, 0);
        assert(time == 0, 'Wrong time');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_final_time() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![0, 1179750, 2359500, 3539250, 4719000].span();
        let ton_equivalent = 1000000;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
        // [Assert] Final time = times[-1]
        let time = Absorber::AbsorberImpl::get_final_time(@state, 0);
        assert(time == *times.at(times.len() - 1), 'Wrong time');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_final_time_zero_not_set() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Final time = times[-1]
        let time = Absorber::AbsorberImpl::get_final_time(@state, 0);
        assert(time == 0, 'Wrong time');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_final_absorption() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![0, 1179750, 2359500, 3539250, 4719000].span();
        let ton_equivalent = 1000000;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
        // [Assert] Final absorption = absorptions[-1]
        let absorption = Absorber::AbsorberImpl::get_final_absorption(@state, 0);
        assert(absorption == *absorptions.at(absorptions.len() - 1), 'Wrong absorption');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_final_absorption_zero_not_set() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Final absorption = absorptions[-1]
        let absorption = Absorber::AbsorberImpl::get_final_absorption(@state, 0);
        assert(absorption == 0, 'Wrong absorption');
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Times and absorptions mismatch',))]
    fn test_set_absorptions_revert_mismatch() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![].span();
        let ton_equivalent = 0;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Inputs cannot be empty',))]
    fn test_set_absorptions_revert_empty() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![].span();
        let absorptions: Span<u64> = array![].span();
        let ton_equivalent = 0;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Ton equivalent must be positive',))]
    fn test_set_absorptions_revert_not_positive() {
        // [Setup]
        let mut state = STATE();
        let times: Span<u64> = array![1651363200, 1659312000, 1667260800, 1675209600, 1682899200]
            .span();
        let absorptions: Span<u64> = array![0, 1179750, 2359500, 3539250, 4719000].span();
        let ton_equivalent = 0;
        Absorber::AbsorberImpl::set_absorptions(ref state, 0, times, absorptions, ton_equivalent);
    }
}
