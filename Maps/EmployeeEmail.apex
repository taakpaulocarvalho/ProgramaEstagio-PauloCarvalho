public String employeeEmail(Map<String, String> employeeIdToEmail, String employeeId) {
    
    String email;

    if (employeeIdToEmail.containsKey(employeeId)){
        email = employeeIdToEmail.get(employeeId);
    }
    else{
        email = 'info@apexsandbox.io';
    }

    return email;
}