#[test_only]
module deployer::newspaper_tests {
    use deployer::newspaper;

    use std::signer;
    use std::unit_test;
    use std::vector;

    #[test_only]
    fun get_account(): signer {
        vector::pop_back(&mut unit_test::create_signers_for_testing(1))
    }

    #[test]
    public entry fun test_if_it_init() {
        let account = get_account();
        let addr = signer::address_of(&account);
        aptos_framework::account::create_account_for_test(addr);
        newspaper::init(account);
        assert!(newspaper::get_news_count(addr) == 0, 0);
        assert!(newspaper::is_posting_enabled(addr), 0);
    }
}