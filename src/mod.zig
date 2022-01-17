//! The specification for the project management (not necessarily pkg mgmt yet)
//! portion of the module specification for the IDL ecossytem. The ./mod/ folder
//! contains files which are intended to span the different levels at which the 
//! project mgmt must operate, from a single module, to a user's network of different
//! projects and workspaces, to an entire package/repo ecossytem.
const str = []const u8;

pub const Module = struct {
    label: ?str,
    path: ?str,
    trigger: ModuleTrigger,
};

pub const ModuleTrigger = enum(u8) {
    File,
    BraceBlockInit,
    NewDataBlock,
};
