#Requires AutoHotkey v1.1.35+
;==============================================================
; RegNamespace — Registry namespace helper with optional subkeys and RegView switching
;
; GitHub: https://github.com/SevenKeyboard/reg-namespace
; Author: SevenKeyboard Ltd. (2026)
; License: MIT License
;==============================================================
class VersionManager_RegNamespace
{
    static _ := VersionManager_RegNamespace._init()
    _init()    {
        global
        REGNAMESPACE_VERSION := "1.0.0"
    }
}
class RegNamespace
{
    __new(rootPath, regView := "Default")    {
        this._rootPath := rTrim(rootPath, "\")
        if (this._rootPath == "")
            throw "Parameter #1 cannot be an empty string."
        this._regView := (regView == 32 ? 32 : regView == 64 ? 64 : "Default")
    }
    RootPath    {
        get  {
            return this._rootPath
        }
    }
    RegView    {
        get  {
            return this._regView
        }
    }
    ;---------------------------------------
    createKey(subKey := "UNSET_SUBKEY_7C99F0B4")    {
        if (A_RegView !== this._regView)    {
            prevRegView := A_RegView
            setRegView % this._regView
        }
        keyPath := this._resolveKeyPath(subKey)
        regRead _, % keyPath
        if (errorLevel)    {
            regWrite % "REG_SZ", % keyPath,, % ""
            if (!errorLevel)
                regDelete % keyPath, % chr(0x0041) . chr(0x0048) . chr(0x004B) . "_" . chr(0x0044) . chr(0x0045) . chr(0x0046) . chr(0x0041) . chr(0x0055) . chr(0x004C) . chr(0x0054)
        }  else  {
            errorLevel := 0
        }
        if (isSet(prevRegView))
            setRegView % prevRegView
    }
    delete(subKey := "UNSET_SUBKEY_7C99F0B4", valueName := "UNSET_VALUENAME_0777A948")    {
        local
        if (A_RegView !== this._regView)    {
            prevRegView := A_RegView
            setRegView % this._regView
        }
        if (valueName == "" || valueName == "UNSET_VALUENAME_0777A948")
            valueName := chr(0x0041) . chr(0x0048) . chr(0x004B) . "_" . chr(0x0044) . chr(0x0045) . chr(0x0046) . chr(0x0041) . chr(0x0055) . chr(0x004C) . chr(0x0054)
        regDelete % this._resolveKeyPath(subKey), % valueName
        if (isSet(prevRegView))
            setRegView % prevRegView
    }
    deleteKey(subKey := "UNSET_SUBKEY_7C99F0B4")    {
        local
        if (A_RegView !== this._regView)    {
            prevRegView := A_RegView
            setRegView % this._regView
        }
        regDelete % this._resolveKeyPath(subKey)
        if (isSet(prevRegView))
            setRegView % prevRegView
    }
    read(subKey := "UNSET_SUBKEY_7C99F0B4", valueName := "", default := "UNSET_DEFAULT_B861760B")    {
        local
        if (A_RegView !== this._regView)    {
            prevRegView := A_RegView
            setRegView % this._regView
        }
        regRead value, % this._resolveKeyPath(subKey), % valueName
        if (errorLevel)    {
            if (default !== "UNSET_DEFAULT_B861760B")    {
                value := default
                errorLevel := 0
            }
        }
        if (isSet(prevRegView))
            setRegView % prevRegView
        return value
    }
    write(value, valueType, subKey := "UNSET_SUBKEY_7C99F0B4", valueName := "")    {
        local
        if (A_RegView !== this._regView)    {
            prevRegView := A_RegView
            setRegView % this._regView
        }
        regWrite % valueType, % this._resolveKeyPath(subKey), % valueName, % value
        if (isSet(prevRegView))
            setRegView % prevRegView
    }
    ;---------------------------------------
    _resolveKeyPath(subKey)    {
        return this._rootPath . (subKey !== "UNSET_SUBKEY_7C99F0B4" && subKey !== "" ? "\" . lTrim(subKey, "\") : "")
    }
}