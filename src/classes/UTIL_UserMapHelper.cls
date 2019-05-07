public virtual class UTIL_UserMapHelper {
    public Map<Id, User> mapUserByIdField(List<User> userList, SObjectField idField) {
        Map<Id, User> userBySpecifiedIdMap = new Map<Id, User>();
        for (User user : userList) {
            userBySpecifiedIdMap.put((Id) user.get(idField), user);
        }
        return userBySpecifiedIdMap;
    }
}