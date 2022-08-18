# SPDX-License-Identifier: MIT
# Carbonable smart contracts written in Cairo v0.1.0 (test_specific_case.cairo)

%lang starknet

# Starkware dependencies
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.bool import TRUE, FALSE

# Project dependencies
from tests.integrations.minter.library import (
    carbonable_minter_instance,
    project_nft_instance,
    payment_token_instance,
    admin_instance as admin,
    anyone_instance as anyone,
)
