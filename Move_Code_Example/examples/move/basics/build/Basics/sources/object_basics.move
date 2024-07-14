// Define the module `basics::object_basics`
module basics::object_basics {
    // Import the `event` module from `sui`
    use sui::event;

    // Define a public struct `Object` with the `key` and `store` abilities
    // This struct has two fields: `id` and `value`
    public struct Object has key, store {
        id: UID,         // Unique identifier for the Object
        value: u64,
    }

    // Define a public struct `Wrapper` with the `key` ability
    // This struct has two fields: `id` and `o`
    public struct Wrapper has key {
        id: UID,        // Unique identifier for the Wrapper
        o: Object       // An Object contained within the Wrapper
    }

    // Define a public struct `NewValueEvent` with the `copy` and `drop` abilities
    // This struct has one field: `new_value`
    public struct NewValueEvent has copy, drop {
        new_value: u64
    }

    // Define a public function `create` that takes a `value`, a `recipient` address,
    // and a mutable reference to a `TxContext`
    // This function creates a new `Object` with the specified value and transfers it to the recipient
    public fun create(value: u64, recipient: address, ctx: &mut TxContext) {
        transfer::public_transfer(
            Object {
                id: object::new(ctx), // Generate a new unique identifier for the Object
                value                 // Initialize the Object value
            },
            recipient                // Transfer the new Object to the recipient
        )
    }

    // Define a public function `transfer` that takes an `Object` and a `recipient` address
    // This function transfers the given `Object` to the specified recipient
    public fun transfer(o: Object, recipient: address) {
        transfer::public_transfer(o, recipient) // Transfer the Object to the recipient
    }

    // Define a public function `freeze_object` that takes an `Object`
    // This function freezes the specified `Object`, preventing it from being transferred
    public fun freeze_object(o: Object) {
        transfer::public_freeze_object(o) // Freeze the Object
    }

    // Define a public function `set_value` that takes a mutable reference to an `Object` and a `value`
    // This function sets the `value` field of the given `Object`
    public fun set_value(o: &mut Object, value: u64) {
        o.value = value; // Set the Object's value
    }

    // Define a public function `update` that takes a mutable reference to `o1` and a reference to `o2`
    // This function updates the value of `o1` to match the value of `o2` and emits an event with the new value
    public fun update(o1: &mut Object, o2: &Object) {
        o1.value = o2.value; // Update the value of o1 to match o2
        // Emit an event so the world can see the new value
        event::emit(NewValueEvent { new_value: o2.value })
    }

    // Define a public function `delete` that takes an `Object`
    // This function deletes the specified `Object`
    public fun delete(o: Object) {
        let Object { id, value: _ } = o; // Destructure the Object to get its `id`
        id.delete(); // Delete the unique identifier, effectively removing the Object
    }

    // Define a public function `wrap` that takes an `Object` and a mutable reference to a `TxContext`
    // This function wraps the `Object` into a `Wrapper` and transfers the `Wrapper` to the sender
    public fun wrap(o: Object, ctx: &mut TxContext) {
        transfer::transfer(
            Wrapper {
                id: object::new(ctx), // Generate a new unique identifier for the Wrapper
                o                     // Wrap the Object
            },
            ctx.sender()             // Transfer the Wrapper to the sender
        );
    }

    // Define a public function `unwrap` that takes a `Wrapper` and a reference to a `TxContext`
    // This function unwraps the `Wrapper`, deletes its unique identifier, and transfers the contained `Object` back to the sender
    #[lint_allow(self_transfer)]
    public fun unwrap(w: Wrapper, ctx: &TxContext) {
        let Wrapper { id, o } = w; // Destructure the Wrapper to get its `id` and contained `Object`
        id.delete(); // Delete the unique identifier, effectively removing the Wrapper
        transfer::public_transfer(o, ctx.sender()); // Transfer the contained Object back to the sender
    }
}

// Linting Warning
// Linting refers to the process of running a program that analyzes code for potential errors, stylistic issues, and deviations from best practices. Linters help developers maintain code quality and consistency by identifying problematic patterns and suggesting improvements.
//
// Linting Warning in Move
// In the context of Move, a linting warning indicates that the code may have a potential issue or could be improved according to certain predefined rules. These warnings do not prevent the code from being compiled or executed, but they serve as helpful reminders to improve code quality.
//
// #[lint_allow(self_transfer)] Attribute
// In Move, the #[lint_allow] attribute is used to suppress specific linting warnings for a particular piece of code. The attribute allows the developer to explicitly indicate that they are aware of a potential issue flagged by the linter and have chosen to allow it for specific reasons.
//
// #[lint_allow(self_transfer)]
//
// The #[lint_allow(self_transfer)] attribute is used to suppress warnings related to self-transfers. A self-transfer occurs when an object is transferred to the same address that currently owns it. This might be flagged by the linter as unnecessary or redundant.

