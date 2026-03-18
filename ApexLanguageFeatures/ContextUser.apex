public Map<String,String> getContextUserInformation(){
    
    Map<String, String> userMap = new Map<String, String>();

    userMap.put('EmailId', UserInfo.getUserEmail());
    userMap.put('ProfileId', UserInfo.getProfileId());
    userMap.put('Type', UserInfo.getUserType());
    userMap.put('UserName', UserInfo.getUserName());

    return userMap;
}