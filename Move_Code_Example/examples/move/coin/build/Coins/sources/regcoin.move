// the regcoin module is similar to the my_coin module, but with added features for regulation and management of a deny list.



module examples::regcoin {
    // Import necessary items from the `sui::coin` module and the `sui::deny_list` module
    use sui::coin::{Self, DenyCapV2};
    use sui::deny_list::{DenyList};

    // Define a public struct `REGCOIN` with the `drop` ability
    public struct REGCOIN has drop {}

    // Module initializer is called once on module publish. A treasury
    // cap and deny cap are sent to the publisher, who then controls minting,
    // burning, and managing the deny list.
    fun init(witness: REGCOIN, ctx: &mut TxContext) {
        // Create a new regulated currency with the specified parameters
        let (treasury, deny_cap, metadata) = coin::create_regulated_currency_v2(
            witness,        // The type identifier for the coin
            6,              // The number of decimal places for the coin
            b"REGCOIN",     // The name of the coin in bytes
            b"",            // Empty byte string for the description
            b"",            // Empty byte string for the icon URL
            option::none(), // No additional options
            false,          // Indicates whether the currency should start with all addresses denied
            ctx,            // The transaction context
        );
        // Freezing this object makes the metadata immutable, including the title, name, and icon image.
        transfer::public_freeze_object(metadata);
        // Transfer the treasury cap to the sender of the transaction
        transfer::public_transfer(treasury, ctx.sender());
        // Transfer the deny cap to the sender of the transaction
        transfer::public_transfer(deny_cap, ctx.sender())
    }

    // Add an address to the deny list
    public fun add_addr_from_deny_list(
        denylist: &mut DenyList,            // A mutable reference to the deny list
        denycap: &mut DenyCapV2<REGCOIN>,   // A mutable reference to the DenyCapV2 for REGCOIN
        denyaddy: address,                  // The address to be added to the deny list
        ctx: &mut TxContext,                // A mutable reference to the transaction context
    ) {
        // Call `coin::deny_list_v2_add` to add the address to the deny list
        coin::deny_list_v2_add(denylist, denycap, denyaddy, ctx);
    }

    // Remove an address from the deny list
    public fun remove_addr_from_deny_list(
        denylist: &mut DenyList,            // A mutable reference to the deny list
        denycap: &mut DenyCapV2<REGCOIN>,   // A mutable reference to the DenyCapV2 for REGCOIN
        denyaddy: address,                  // The address to be removed from the deny list
        ctx: &mut TxContext,                // A mutable reference to the transaction context
    ) {
        // Call `coin::deny_list_v2_remove` to remove the address from the deny list
        coin::deny_list_v2_remove(denylist, denycap, denyaddy, ctx);
    }
}
