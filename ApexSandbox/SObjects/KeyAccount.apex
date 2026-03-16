public Boolean isKeyAccount(Account a) {
    
    switch on a.Industry{
        when 'Banking'{
            if (a.AnnualRevenue < 600000)
                return false;
            return true;
        }
        when 'Technology'{
            if (a.AnnualRevenue < 800000)
                return false;
            return true;
        }
        when 'Retail'{
            if (a.AnnualRevenue < 2000000)
                return false;
            return true;
        }
        when else {
            if (a.AnnualRevenue < 500000)
                return false;
            return true;
        }
    }
}