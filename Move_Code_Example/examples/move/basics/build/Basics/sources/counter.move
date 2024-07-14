// Define the module `basics::counter`
module basics::counter {
    // Define a public struct `Counter` with the `key` ability
    // The struct has three fields: `id`, `owner`, and `value`
    public struct Counter has key {
        id: UID,         // Unique identifier for the Counter object
        owner: address,  // Address of the owner of this Counter
        value: u64       // The value stored in the Counter
    }

    // Define a public function `owner` that takes a reference to a `Counter`
    // and returns the owner's address
    public fun owner(counter: &Counter): address {
        counter.owner   // Return the owner field of the Counter
    }

    // Define a public function `value` that takes a reference to a `Counter`
    // and returns the current value of the Counter
    public fun value(counter: &Counter): u64 {
        counter.value   // Return the value field of the Counter
    }

    // Define a public entry function `create` that takes a mutable reference to a `TxContext`
    // This function creates and shares a new `Counter` object
    public fun create(ctx: &mut TxContext) {
        transfer::share_object(Counter {
            id: object::new(ctx),          // Generate a new unique identifier for the Counter
            owner: tx_context::sender(ctx), // Get the address of the transaction sender
            value: 0                       // Initialize the Counter value to 0
        })
    }

    // Define a public function `increment` that takes a mutable reference to a `Counter`
    // This function increments the value of the Counter by 1
    public fun increment(counter: &mut Counter) {
        counter.value = counter.value + 1; // Increment the value field of the Counter
    }

    // Define a public function `set_value` that takes a mutable reference to a `Counter`,
    // a new value, and a reference to a `TxContext`
    // This function sets the value of the Counter, ensuring only the owner can set it
    public fun set_value(counter: &mut Counter, value: u64, ctx: &TxContext) {
        assert!(counter.owner == ctx.sender(), 0); // Ensure the caller is the owner
        counter.value = value;                     // Set the value field of the Counter
    }

    // Define a public function `assert_value` that takes a reference to a `Counter`
    // and a value to compare against
    // This function asserts that the Counter's value is equal to the specified value
    public fun assert_value(counter: &Counter, value: u64) {
        assert!(counter.value == value, 0); // Assert that the Counter's value equals the specified value
    }

    // Define a public function `delete` that takes a `Counter` object and a reference to a `TxContext`
    // This function deletes the Counter, ensuring only the owner can delete it
    public fun delete(counter: Counter, ctx: &TxContext) {
        assert!(counter.owner == ctx.sender(), 0); // Ensure the caller is the owner
        let Counter {id, owner:_, value:_} = counter; // Destructure the Counter to get its `id`
        id.delete();                               // Delete the unique identifier, removing the Counter
    }
}
