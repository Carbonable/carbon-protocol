#[derive(Drop, Copy)]
enum BookingStatus {
    Unknown,
    Booked,
    Failed,
    Minted,
    Refunded,
}

#[derive(Drop, Copy, Serde, starknet::Store)]
struct Booking {
    value: u256,
    amount: u256,
    status: u8,
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
