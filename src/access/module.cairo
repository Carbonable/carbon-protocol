#[starknet::contract]
mod Access {
    use starknet::ContractAddress;
    use poseidon::poseidon_hash_span;
    use array::ArrayTrait;
    use traits::Into;
    use openzeppelin::access::accesscontrol::accesscontrol::AccessControl;
    use protocol::access::interface::{IMinter, ICertifier, IWithdrawer, IProvisioner};

    const MINTER_ROLE: felt252 = 'MINTER';
    const CERTIFIER_ROLE: felt252 = 'CERTIFIER';
    const WITHDRAWER_ROLE: felt252 = 'WITHDRAWER';
    const PROVISIONER_ROLE: felt252 = 'PROVISIONER';

    #[storage]
    struct Storage {
        _role_members: LegacyMap<(felt252, u32), ContractAddress>,
        _role_members_index: LegacyMap<(felt252, ContractAddress), u32>,
        _role_members_len: LegacyMap<felt252, u32>,
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
            self._role_members.read((role, 0))
        }

        fn set_certifier(ref self: ContractState, slot: u256, user: ContractAddress) {
            // [Effect] Revoke current certifier
            let role = self._hash(CERTIFIER_ROLE, slot);
            let certifier = self._role_members.read((role, 0));
            let mut unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::_revoke_role(ref unsafe_state, role, certifier);

            // [Effect] Set new certifier
            AccessControl::InternalImpl::_grant_role(ref unsafe_state, role, user);
            self._role_members.write((role, 0), user);
        }
    }

    #[external(v0)]
    impl WithdrawerImpl of IWithdrawer<ContractState> {
        fn get_withdrawer(self: @ContractState, slot: u256) -> ContractAddress {
            let role = self._hash(WITHDRAWER_ROLE, slot);
            self._role_members.read((role, 0))
        }

        fn set_withdrawer(ref self: ContractState, slot: u256, user: ContractAddress) {
            // [Effect] Revoke current withdrawer
            let role = self._hash(WITHDRAWER_ROLE, slot);
            let withdrawer = self._role_members.read((role, 0));
            let mut unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::_revoke_role(ref unsafe_state, role, withdrawer);

            // [Effect] Set new withdrawer
            AccessControl::InternalImpl::_grant_role(ref unsafe_state, role, user);
            self._role_members.write((role, 0), user);
        }
    }

    #[external(v0)]
    impl ProvisionerImpl of IProvisioner<ContractState> {
        fn get_provisioner(self: @ContractState, slot: u256) -> ContractAddress {
            let role = self._hash(PROVISIONER_ROLE, slot);
            self._role_members.read((role, 0))
        }

        fn set_provisioner(ref self: ContractState, slot: u256, user: ContractAddress) {
            // [Effect] Revoke current provisioner
            let role = self._hash(PROVISIONER_ROLE, slot);
            let provisioner = self._role_members.read((role, 0));
            let mut unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::_revoke_role(ref unsafe_state, role, provisioner);

            // [Effect] Set new provisioner
            AccessControl::InternalImpl::_grant_role(ref unsafe_state, role, user);
            self._role_members.write((role, 0), user);
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

        fn assert_only_withdrawer(self: @ContractState, slot: u256) {
            let role = self._hash(WITHDRAWER_ROLE, slot);
            let unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::assert_only_role(@unsafe_state, role);
        }

        fn assert_only_provisioner(self: @ContractState, slot: u256) {
            let role = self._hash(PROVISIONER_ROLE, slot);
            let unsafe_state = AccessControl::unsafe_new_contract_state();
            AccessControl::InternalImpl::assert_only_role(@unsafe_state, role);
        }

        fn _hash(self: @ContractState, role: felt252, slot: u256) -> felt252 {
            let mut inputs: Array<felt252> = ArrayTrait::new();
            inputs.append(slot.low.into());
            inputs.append(slot.high.into());
            inputs.append(role);
            poseidon_hash_span(inputs.span())
        }

        fn _get_role_members(self: @ContractState, role: felt252) -> Span<ContractAddress> {
            let len = self._role_members_len.read(role);
            let mut members: Array<ContractAddress> = ArrayTrait::new();
            let mut index = 0;
            loop {
                if index == len {
                    break;
                }
                members.append(self._role_members.read((role, index)));
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
            let index = self._role_members_len.read(role);
            self._role_members.write((role, index), user);
            self._role_members_index.write((role, user), index);
            self._role_members_len.write(role, index + 1);
        }

        fn _revoke_role(ref self: ContractState, role: felt252, user: ContractAddress) {
            // [Check] User already has role
            let mut unsafe_sate = AccessControl::unsafe_new_contract_state();
            if !AccessControl::AccessControlImpl::has_role(@unsafe_sate, role, user) {
                return;
            }

            // [Effect] Remove user role
            let len = self._role_members_len.read(role);
            let user_index = self._role_members_index.read((role, user));
            let last_user = self._role_members.read((role, len - 1));
            self._role_members_len.write(role, len - 1);
            self._role_members.write((role, user_index), last_user);
            self._role_members_index.write((role, last_user), user_index);
            AccessControl::InternalImpl::_revoke_role(ref unsafe_sate, role, user);
        }
    }
}
