public Boolean isBirthday(Contact c) {
    
    if (c.BirthDate.month() == System.today().month() && 
        c.BirthDate.day() == System.today().day())
    {    
        return true;
    }
    return false;
}