public List<String> getFieldsValue(Account acc, List<String> fields)
{
    List<String> fieldsValue = new List<String>();

    for (String field : fields){
        fieldsValue.add(String.valueOf(acc.get(field)));
    }

    return fieldsValue;
}