module basics::random {
    use sui::event;
    use sui::random::Random;

    // Define a public struct `RandomU128Event` with the `copy` and `drop` abilities
    // This struct has one field: `value`
    public struct RandomU128Event has copy, drop {
        value: u128, // A 128-bit unsigned integer representing the random value
    }

    // Define an entry function `new` that takes a reference to a `Random` object
    // and a mutable reference to a `TxContext`
    // This function generates a random u128 value and emits it as an event
    entry fun new(r: &Random, ctx: &mut TxContext) {
        // Create a new random number generator using the `Random` object and transaction context
        let mut gen = r.new_generator(ctx);
        // Generate a random 128-bit unsigned integer
        let value = gen.generate_u128();
        // Emit an event `RandomU128Event` with the generated random value
        event::emit(RandomU128Event { value });
    }
}
