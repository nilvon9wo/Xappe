public enum XAP_DAO_DML_SecurityCheckModeEnum {
    ALL_CRUD_AND_FLS_FOR_EVERY_SOBJECT,                 // Strongest security, large performance penalty.
    ALL_CRUD_AND_FLS_IN_FIRST_SOBJECT_IN_EACH_LIST,     // Strong security if list is mostly homogeneous.
    CRUD_AND_FLS_IN_FIRST_SOBJECT_IN_EACH_LIST,         // Strong security if list is known to be entirely homogeneous.
    ALL_CRUD_AND_FLS_IN_SPECIFIED_LIST_ONLY,            // Less secure, but better performance; developers must maintain list.
    ALL_CRUD_BUT_NO_FLS,                                // Marginally secure for heterogeneous lists
    CRUD_ONLY_IN_FIRST_SOBJECT_IN_EACH_LIST,            // Marginally secure for homogeneous lists, but best performance without bypass
    BIPASS                                              // No security
}