public Boolean isTypeAccount(sObject record)
{
    if (record instanceof Account)
        return true;

    return false;
}