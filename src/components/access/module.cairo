#[starknet::contract]
mod Access {
    use starknet::ContractAddress;
    use poseidon::poseidon_hash_span;
    use array::ArrayTrait;
    use traits::Into;
    use openzeppelin::access::accesscontrol::accesscontrol::AccessControl;
    use carbon::components::access::interface::{IMinter, ICertifier, IWithdrawer};

    const MINTER_ROLE: felt252 = 'MINTER';
    const CERTIFIER_ROLE: felt252 = 'CERTIFIER';
    const WITHDRAWER_ROLE: felt252 = 'WITHDRAWER';

    #[storage]
    struct Storage {
        _access_role_members: LegacyMap<(felt252, u32), ContractAddress>,
        _access_role_members_index: LegacyMap<(felt252, ContractAddress), u32>,
        _access_role_members_len: LegacyMap<felt252, u32>,
    }

    #[external(v0)]
    impl MinterImpl of IMinter<ContractState> {
        fn get_minters(self: @ContractState, slot: u256) -> Span<ContractAddress> {
            let role = self._hash(MINTER_ROLE, slot);
            self._get_role_members(role)
        }

        fn add_minter(ref self: ContractState, slot: u256, user: ContractAddress) {
            let role = self._hash(MINTER_ROLE, slot);
            self._set_role(role, user);
        }

        fn revoke_minter(ref self: ContractState, slot: u256, user: ContractAddress) {
            let role = self._hash(MINTER_ROLE, slot);
            self._revoke_role(role, user);
        }
    }

    #[external(v0)]
    impl CertifierImpl of ICertifier<ContractState> {
        fn get_certifier(self: @ContractState, slot: u256) -> ContractAddress {
            let role = self._hash(CERTIFIER_ROLE, slot);
            self._access_role_members.read((role, 0))
        }

        fn set_certifier(ref self: ContractState, slot: u256, user: ContractAddress) {
            // [Effect] Revoke current certifier
            let role = self._hash(CERTIFIER_ROLE, slot);
            let certifier = self._access_role_members.read((role, 0));
            let mut unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::_revoke_role(ref unsafe_state, role, certifier);

            // [Effect] Set new certifier
            AccessControl::InternalImpl::_grant_role(ref unsafe_state, role, user);
            self._access_role_members.write((role, 0), user);
        }
    }

    #[external(v0)]
    impl WithdrawerImpl of IWithdrawer<ContractState> {
        fn get_withdrawer(self: @ContractState) -> ContractAddress {
            self._access_role_members.read((WITHDRAWER_ROLE, 0))
        }

        fn set_withdrawer(ref self: ContractState, user: ContractAddress) {
            // [Effect] Revoke current withdrawer
            let withdrawer = self._access_role_members.read((WITHDRAWER_ROLE, 0));
            let mut unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::_revoke_role(
                ref unsafe_state, WITHDRAWER_ROLE, withdrawer
            );

            // [Effect] Set new withdrawer
            AccessControl::InternalImpl::_grant_role(ref unsafe_state, WITHDRAWER_ROLE, user);
            self._access_role_members.write((WITHDRAWER_ROLE, 0), user);
        }
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn initializer(ref self: ContractState) {
            let mut unsafe_sate = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::initializer(ref unsafe_sate);
        }

        fn assert_only_minter(self: @ContractState, slot: u256) {
            let role = self._hash(MINTER_ROLE, slot);
            let unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::assert_only_role(@unsafe_state, role);
        }

        fn assert_only_certifier(self: @ContractState, slot: u256) {
            let role = self._hash(CERTIFIER_ROLE, slot);
            let unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::assert_only_role(@unsafe_state, role);
        }

        fn assert_only_withdrawer(self: @ContractState) {
            let unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::assert_only_role(@unsafe_state, WITHDRAWER_ROLE);
        }

        fn _hash(self: @ContractState, role: felt252, slot: u256) -> felt252 {
            let mut inputs: Array<felt252> = ArrayTrait::new();
            inputs.append(slot.low.into());
            inputs.append(slot.high.into());
            inputs.append(role);
            poseidon_hash_span(inputs.span())
        }

        fn _get_role_members(self: @ContractState, role: felt252) -> Span<ContractAddress> {
            let len = self._access_role_members_len.read(role);
            let mut members: Array<ContractAddress> = ArrayTrait::new();
            let mut index = 0;
            loop {
                if index == len {
                    break;
                }
                members.append(self._access_role_members.read((role, index)));
                index += 1;
            };
            members.span()
        }

        fn _set_role(ref self: ContractState, role: felt252, user: ContractAddress) {
            // [Check] User already has role
            let mut unsafe_sate = AccessControl::unsafe_new_contract_state();
            if AccessControl::AccessControlImpl::has_role(@unsafe_sate, role, user) {
                return;
            }

            // [Effect] Add user role
            AccessControl::InternalImpl::_grant_role(ref unsafe_sate, role, user);
            let index = self._access_role_members_len.read(role);
            self._access_role_members.write((role, index), user);
            self._access_role_members_index.write((role, user), index);
            self._access_role_members_len.write(role, index + 1);
        }

        fn _revoke_role(ref self: ContractState, role: felt252, user: ContractAddress) {
            // [Check] User already has role
            let mut unsafe_sate = AccessControl::unsafe_new_contract_state();
            if !AccessControl::AccessControlImpl::has_role(@unsafe_sate, role, user) {
                return;
            }

            // [Effect] Remove user role
            let len = self._access_role_members_len.read(role);
            let user_index = self._access_role_members_index.read((role, user));
            let last_user = self._access_role_members.read((role, len - 1));
            self._access_role_members_len.write(role, len - 1);
            self._access_role_members.write((role, user_index), last_user);
            self._access_role_members_index.write((role, last_user), user_index);
            AccessControl::InternalImpl::_revoke_role(ref unsafe_sate, role, user);
        }
    }
}

#[cfg(test)]
mod Test {
    use starknet::testing::set_caller_address;
    use super::Access;

    fn STATE() -> Access::ContractState {
        Access::unsafe_new_contract_state()
    }

    fn MINTER() -> starknet::ContractAddress {
        starknet::contract_address_const::<'MINTER'>()
    }

    fn CERTIFIER() -> starknet::ContractAddress {
        starknet::contract_address_const::<'CERTIFIER'>()
    }

    fn WITHDRAWER() -> starknet::ContractAddress {
        starknet::contract_address_const::<'WITHDRAWER'>()
    }

    fn PROVISIONER() -> starknet::ContractAddress {
        starknet::contract_address_const::<'PROVISIONER'>()
    }

    fn ANYONE() -> starknet::ContractAddress {
        starknet::contract_address_const::<'ANYONE'>()
    }

    fn ZERO() -> starknet::ContractAddress {
        starknet::contract_address_const::<0>()
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_initialization() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Initialization pass
        Access::InternalImpl::initializer(ref state);
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_minter() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Minters are null
        let minters = Access::MinterImpl::get_minters(@state, 0);
        assert(minters == array![].span(), 'Wrong minters');
        // [Assert] Add minters
        Access::MinterImpl::add_minter(ref state, 0, CERTIFIER());
        Access::MinterImpl::add_minter(ref state, 0, ANYONE());
        Access::MinterImpl::add_minter(ref state, 0, MINTER());
        let minters = Access::MinterImpl::get_minters(@state, 0);
        assert(minters == array![CERTIFIER(), ANYONE(), MINTER()].span(), 'Wrong minters');
        // [Assert] Remove 2nd minter
        Access::MinterImpl::revoke_minter(ref state, 0, ANYONE());
        let minters = Access::MinterImpl::get_minters(@state, 0);
        assert(minters == array![CERTIFIER(), MINTER()].span(), 'Wrong minters');
        // [Assert] Remove 1st minter
        Access::MinterImpl::revoke_minter(ref state, 0, CERTIFIER());
        let minters = Access::MinterImpl::get_minters(@state, 0);
        assert(minters == array![MINTER()].span(), 'Wrong minters');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_assert_minter() {
        // [Setup]
        let mut state = STATE();
        Access::MinterImpl::add_minter(ref state, 0, MINTER());
        // [Assert] Minter
        set_caller_address(MINTER());
        Access::InternalImpl::assert_only_minter(@state, 0);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Caller is missing role',))]
    fn test_assert_minter_revert_not_minter() {
        // [Setup]
        let mut state = STATE();
        Access::MinterImpl::add_minter(ref state, 0, MINTER());
        // [Assert] Minter
        set_caller_address(ANYONE());
        Access::InternalImpl::assert_only_minter(@state, 0);
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_certifier() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Certifier is null
        let certifier = Access::CertifierImpl::get_certifier(@state, 0);
        assert(certifier == ZERO(), 'Wrong certifier');
        // [Assert] Certifier is set correctly
        Access::CertifierImpl::set_certifier(ref state, 0, CERTIFIER());
        let certifier = Access::CertifierImpl::get_certifier(@state, 0);
        assert(certifier == CERTIFIER(), 'Wrong certifier');
        // [Assert] Certifier is changed correctly
        Access::CertifierImpl::set_certifier(ref state, 0, ZERO());
        let certifier = Access::CertifierImpl::get_certifier(@state, 0);
        assert(certifier != CERTIFIER(), 'Wrong certifier');
        assert(certifier == ZERO(), 'Wrong certifier');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_assert_certifier() {
        // [Setup]
        let mut state = STATE();
        Access::CertifierImpl::set_certifier(ref state, 0, CERTIFIER());
        // [Assert] Certifier
        set_caller_address(CERTIFIER());
        Access::InternalImpl::assert_only_certifier(@state, 0);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Caller is missing role',))]
    fn test_assert_certifier_revert_not_certifier() {
        // [Setup]
        let mut state = STATE();
        Access::CertifierImpl::set_certifier(ref state, 0, CERTIFIER());
        // [Assert] Certifier
        set_caller_address(ANYONE());
        Access::InternalImpl::assert_only_certifier(@state, 0);
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_withdrawer() {
        // [Setup]
        let mut state = STATE();
        // [Assert] Withdrawer is null
        let withdrawer = Access::WithdrawerImpl::get_withdrawer(@state);
        assert(withdrawer == ZERO(), 'Wrong withdrawer');
        // [Assert] Withdrawer is set correctly
        Access::WithdrawerImpl::set_withdrawer(ref state, WITHDRAWER());
        let withdrawer = Access::WithdrawerImpl::get_withdrawer(@state);
        assert(withdrawer == WITHDRAWER(), 'Wrong withdrawer');
        // [Assert] Withdrawer is changed correctly
        Access::WithdrawerImpl::set_withdrawer(ref state, ZERO());
        let withdrawer = Access::WithdrawerImpl::get_withdrawer(@state);
        assert(withdrawer != WITHDRAWER(), 'Wrong withdrawer');
        assert(withdrawer == ZERO(), 'Wrong withdrawer');
    }

    #[test]
    #[available_gas(20_000_000)]
    fn test_assert_withdrawer() {
        // [Setup]
        let mut state = STATE();
        Access::WithdrawerImpl::set_withdrawer(ref state, WITHDRAWER());
        // [Assert] Withdrawer
        set_caller_address(WITHDRAWER());
        Access::InternalImpl::assert_only_withdrawer(@state);
    }

    #[test]
    #[available_gas(20_000_000)]
    #[should_panic(expected: ('Caller is missing role',))]
    fn test_assert_withdrawer_revert_not_withdrawer() {
        // [Setup]
        let mut state = STATE();
        Access::WithdrawerImpl::set_withdrawer(ref state, WITHDRAWER());
        // [Assert] Withdrawer
        set_caller_address(ANYONE());
        Access::InternalImpl::assert_only_withdrawer(@state);
    }
}
