// Define the module `basics::clock`
module basics::clock {
    // Import the `Clock` struct from the `sui::clock` module
    // and the `event` module from `sui`
    use sui::{clock::Clock, event};

// Define a public struct `TimeEvent` with three abilities: `copy`, `drop`, and `store`
// This struct has one field: `timestamp_ms` of type `u64`
public struct TimeEvent has copy, drop, store {
timestamp_ms: u64,
}

// Define an entry function `access` that takes a reference to a `Clock` struct as a parameter
entry fun access(clock: &Clock) {
// Emit an event `TimeEvent` with the current timestamp in milliseconds
// The `clock.timestamp_ms()` function is called to get the current timestamp
event::emit(TimeEvent { timestamp_ms: clock.timestamp_ms() });
}
}


// let clock = sui::clock::Clock::new();
// basics::clock::access(&clock);