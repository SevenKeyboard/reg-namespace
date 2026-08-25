#Requires AutoHotkey v2.0.0+
;==============================================================
; RegNamespace — Registry namespace helper with optional subkeys and RegView switching
;
; GitHub: https://github.com/SevenKeyboard/reg-namespace
; Author: SevenKeyboard Ltd. (2026)
; License: MIT License
;==============================================================
class VersionManager_RegNamespace
{
    static _ := this._init()
    static _init()    {
        global
        REGNAMESPACE_VERSION := "1.0.2"
    }
}
class RegNamespace
{
    __new(rootPath, regView := "Default", readOnly := false)    {
        this._rootPath := rTrim(rootPath, "\")
        if (this._rootPath == "")
            throw valueError("Parameter #1 cannot be an empty string.", -1)
        this._regView := (regView == 32 ? 32 : regView == 64 ? 64 : "Default")
        this._readOnly := (!!readOnly)
    }
    RootPath    => this._rootPath
    RegView     => this._regView
    ReadOnly    => this._readOnly
    ;---------------------------------------
    createKey(subKey?)    {
        if (this._readOnly)
            throw error("Cannot create registry keys from a read-only instance.")
        if (A_RegView !== this._regView)
            prevRegView := setRegView(this._regView)
        try regCreateKey(this._resolveKeyPath(subKey?))
        catch  {
            throw
        }  finally  {
            if (isSet(prevRegView))
                setRegView(prevRegView)
        }
    }
    delete(subKey?, valueName?)    {
        if (this._readOnly)
            throw error("Cannot delete registry keys or values from a read-only instance.")
        if (A_RegView !== this._regView)
            prevRegView := setRegView(this._regView)
        try regDelete(this._resolveKeyPath(subKey?), valueName?)
        catch  {
            throw
        }  finally  {
            if (isSet(prevRegView))
                setRegView(prevRegView)
        }
    }
    deleteKey(subKey?)    {
        if (this._readOnly)
            throw error("Cannot delete registry keys from a read-only instance.")
        if (A_RegView !== this._regView)
            prevRegView := setRegView(this._regView)
        try regDeleteKey(this._resolveKeyPath(subKey?))
        catch  {
            throw
        }  finally  {
            if (isSet(prevRegView))
                setRegView(prevRegView)
        }
    }
    read(subKey?, valueName?, default?)    {
        if (A_RegView !== this._regView)
            prevRegView := setRegView(this._regView)
        try value := regRead(this._resolveKeyPath(subKey?), valueName?, default?)
        catch  {
            throw
        }  finally  {
            if (isSet(prevRegView))
                setRegView(prevRegView)
        }
        return value
    }
    write(value, valueType, subKey?, valueName?)    {
        if (this._readOnly)
            throw error("Cannot write registry keys or values from a read-only instance.")
        if (A_RegView !== this._regView)
            prevRegView := setRegView(this._regView)
        try regWrite(value, valueType, this._resolveKeyPath(subKey?), valueName?)
        catch  {
            throw
        }  finally  {
            if (isSet(prevRegView))
                setRegView(prevRegView)
        }
    }
    ;---------------------------------------
    _resolveKeyPath(subKey?) => this._rootPath . (isSet(subKey) && subKey !== "" ? "\" . lTrim(subKey, "\") : "")
}