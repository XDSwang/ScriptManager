#Requires AutoHotkey v2.0

Input_RegisterKey(keys,key)
{
    keys.Push(key)
    return keys
}

Input_ReleaseKeys(keys)
{
    for key in keys
        SendEvent "{" key " up}"
}
