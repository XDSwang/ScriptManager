#Requires AutoHotkey v2.0

File_Exists(path)
{
    return FileExist(path)
}

File_Read(path)
{
    return FileRead(path)
}

File_Write(path,data)
{
    FileAppend(data,path)
}

File_Delete(path)
{
    if FileExist(path)
        FileDelete(path)
}
