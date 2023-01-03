module deployer::newspaper {
    //use std::debug;
    use std::string;
    use std::signer;
    use std::error;
    use aptos_framework::event;
    use aptos_framework::account;

//:!:>resource
    struct ConfigHolder has key {
        news_count: u64,
        news_count_change_events: event::EventHandle<AddressNewsHolderEvent>,
        posting_enabled: bool,
        posting_enabled_change_events: event::EventHandle<AddressNewsHolderEvent>,
    }

    struct AddressNewsHolder has key {
        titles: vector<string::String>,
        titles_change_events: event::EventHandle<AddressNewsHolderEvent>,
    }

    struct NewsHolder has key {
        title: string::String,
        title_change_events: event::EventHandle<TitleChangeEvent>,
        content: string::String,
        content_change_events: event::EventHandle<ContentChangeEvent>,
    }
//<:!:resource

//:!:>events
    struct NewsCountHolderEvent has drop, store {
        from_news_count: u64,
        to_news_count: u64,
    }

    struct PostingEnableHolderEvent has drop, store {
        to_posting_enabled: bool,
    }

    struct AddressNewsHolderEvent has drop, store {
        from_titles: vector<string::String>,
        to_titles: vector<string::String>,
    }

    struct TitleChangeEvent has drop, store {
        from_title: string::String,
        to_title: string::String,
    }

    struct ContentChangeEvent has drop, store {
        from_content: string::String,
        to_content: string::String,
    }
//<:!:events

//:!:>errors

/// The Config Holder not found
const ENO_CONFIG: u64 = 0;

//<:!:errors

//:!:>getters

    public fun get_news_count(addr: address): u64 acquires ConfigHolder {
        assert!(exists<ConfigHolder>(addr), error::not_found(ENO_CONFIG));
        *&borrow_global<ConfigHolder>(addr).news_count
    }

    public fun is_posting_enabled(addr: address): bool acquires ConfigHolder {
        assert!(exists<ConfigHolder>(addr), error::not_found(ENO_CONFIG));
        *&borrow_global<ConfigHolder>(addr).posting_enabled
    }

//<:!:getters

    public entry fun init(account: signer) {
       let addr = signer::address_of(&account);
       assert!(!exists<ConfigHolder>(addr), error::not_found(ENO_CONFIG));
        move_to(&account, ConfigHolder {
            news_count: 0,
            news_count_change_events: account::new_event_handle<AddressNewsHolderEvent>(&account),
            posting_enabled: true,
            posting_enabled_change_events: account::new_event_handle<AddressNewsHolderEvent>(&account),
        })

    }
    // debug::print(&sum)

}

// User
// |
// --- News storage (contains news titles) [title]
// |
// --- Stats storage (contains posts count)