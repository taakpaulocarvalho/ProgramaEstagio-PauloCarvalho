public List<Account> checkAccounts(List<Account> accounts)
{
    if(accounts == null)
        throw new IllegalArgumentException('accounts should not be null');

    for (Account account : accounts){
        if (String.isBlank(account.BillingCity))
            throw new AccountException('Invalid BillingCity');
    }
    
    return accounts;
}

public class AccountException extends Exception {}