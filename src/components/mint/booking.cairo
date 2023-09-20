// Core imports

use traits::{Into, TryInto, PartialEq};
use option::OptionTrait;
use debug::PrintTrait;

// Starknet imports

use starknet::{Store, StorageBaseAddress};
use starknet::SyscallResult;
use starknet::{
    storage_access, storage_read_syscall, storage_write_syscall,
    storage_address_from_base_and_offset
};

#[derive(storage_access::StorageAccess, Drop, Copy)]
struct Booking {
    value: u256,
    amount: u256,
    status: u8,
}

#[derive(storage_access::StorageAccess, Drop, Copy)]
enum BookingStatus {
    Unknown: (),
    Booked: (),
    Failed: (),
    Minted: (),
    Refunded: (),
}

trait BookingTrait {
    fn new(value: u256, amount: u256, status: BookingStatus) -> Booking;
    fn get_status(ref self: Booking) -> BookingStatus;
    fn set_status(ref self: Booking, status: BookingStatus);
    fn is_status(ref self: Booking, status: BookingStatus) -> bool;
}

impl BookingImpl of BookingTrait {
    fn new(value: u256, amount: u256, status: BookingStatus) -> Booking {
        Booking { value, amount, status: status.into() }
    }
    fn get_status(ref self: Booking) -> BookingStatus {
        self.status.try_into().unwrap()
    }
    fn set_status(ref self: Booking, status: BookingStatus) {
        self.status = status.into();
    }
    fn is_status(ref self: Booking, status: BookingStatus) -> bool {
        self.status == status.into()
    }
}

impl BookingStatusIntoU8 of Into<BookingStatus, u8> {
    fn into(self: BookingStatus) -> u8 {
        match self {
            BookingStatus::Unknown => 0,
            BookingStatus::Booked => 1,
            BookingStatus::Failed => 2,
            BookingStatus::Minted => 3,
            BookingStatus::Refunded => 4,
        }
    }
}

impl U8TryIntoBookingStatus of TryInto<u8, BookingStatus> {
    fn try_into(self: u8) -> Option<BookingStatus> {
        self.print();
        if self == 0 {
            return Option::Some(BookingStatus::Unknown);
        } else if self == 1 {
            return Option::Some(BookingStatus::Booked);
        } else if self == 2 {
            return Option::Some(BookingStatus::Failed);
        } else if self == 3 {
            return Option::Some(BookingStatus::Minted);
        } else if self == 4 {
            return Option::Some(BookingStatus::Refunded);
        } else {
            return Option::None;
        }
    }
}

impl StoreBooking of Store<Booking> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult::<Booking> {
        StoreBooking::read_at_offset(address_domain, base, 0)
    }
    fn read_at_offset(
        address_domain: u32, base: StorageBaseAddress, mut offset: u8
    ) -> SyscallResult::<Booking> {
        Result::Ok(
            Booking {
                value: u256 {
                    low: storage_read_syscall(
                        address_domain, storage_address_from_base_and_offset(base, 0_u8 + offset)
                    )?
                        .try_into()
                        .unwrap(),
                    high: storage_read_syscall(
                        address_domain, storage_address_from_base_and_offset(base, 1_u8 + offset)
                    )?
                        .try_into()
                        .unwrap()
                },
                amount: u256 {
                    low: storage_read_syscall(
                        address_domain, storage_address_from_base_and_offset(base, 2_u8 + offset)
                    )?
                        .try_into()
                        .unwrap(),
                    high: storage_read_syscall(
                        address_domain, storage_address_from_base_and_offset(base, 3_u8 + offset)
                    )?
                        .try_into()
                        .unwrap()
                },
                status: storage_read_syscall(
                    address_domain, storage_address_from_base_and_offset(base, 4_u8 + offset)
                )?
                    .try_into()
                    .unwrap(),
            }
        )
    }

    fn write(address_domain: u32, base: StorageBaseAddress, value: Booking) -> SyscallResult::<()> {
        StoreBooking::write_at_offset(address_domain, base, 0, value)
    }

    fn write_at_offset(
        address_domain: u32, base: StorageBaseAddress, offset: u8, value: Booking
    ) -> SyscallResult::<()> {
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 0_u8 + offset),
            value.value.low.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 1_u8 + offset),
            value.value.high.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 2_u8 + offset),
            value.amount.low.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 3_u8 + offset),
            value.amount.high.into()
        )?;
        storage_write_syscall(
            address_domain,
            storage_address_from_base_and_offset(base, 4_u8 + offset),
            value.status.into()
        )
    }

    fn size() -> u8 {
        5 * Store::<felt252>::size()
    }
}
