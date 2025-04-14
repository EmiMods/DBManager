scriptTitle = "Aurora Database Manager"
scriptAuthor = "EmiMods"
scriptVersion = 1.0
scriptDescription = "Browse Aurora's content and settings databases"
scriptIcon = "icon.png"
scriptPermissions = { "sql" }

ExitTriggered = false

-- Unfortunately I don't know the secondary database alias for Settings (Content.db is primary) and we cannot use commands, so manually listing tables and DB
TableContentHeader = "--- Content.db Tables ---"
TableSettingsHeader = "--- Settings.db Tables ---"
TableSubitemPadding = "      ";
Tables = { 
 -- { {table}, {columns} }
    { {TableContentHeader}, {} },
    { {TableSubitemPadding .. "ContentItems"}, { "Id","Directory","Executable","TitleId","MediaId","BaseVersion","DiscNum","DiscsInSet","TitleName","Description","Publisher","Developer","LiveRating","LiveRaters","ReleaseDate","GenreFlag","ContentFlags","Hash","GameCapsOnline","GameCapsOffline","GameCapsFlags","FileType","ContentType","ContentGroup","DefaultGroup","DateAdded","FoundAtDepth","SystemLink","ScanPathId","CaseIndex"} },
    { {TableSubitemPadding .. "DvdCache"}, {"Id","Directory","Executable","TitleId","MediaId","BaseVersion","DiscNum","DiscsInSet","TitleName","Description","Publisher","Developer","LiveRating","LiveRaters","ReleaseDate","GenreFlag","ContentFlags","Hash","GameCapsOnline","GameCapsOffline","GameCapsFlags","FileType","ContentType","ContentGroup","DefaultGroup","DateAdded","FoundAtDepth","SystemLink","ScanPathId","CaseIndex"} },
    { {TableSubitemPadding .. "MountedDevices"}, {"DeviceId","DeviceName","VirtualRoot","MountPoint"} },
    { {TableSubitemPadding .. "TitleUpdates"}, {"Id","DisplayName","FileName","LiveDeviceId","LivePath","TitleId","MediaId","BaseVersion","Version","Hash","BackupPath","FileSize"} },
    { {TableSettingsHeader}, {} },
    { {TableSubitemPadding .. "ActiveTitleUpdates"}, {"Id","TitleUpdateId"} },
    { {TableSubitemPadding .. "Profiles"}, {"Id","Gametag","Xuid"} },
    { {TableSubitemPadding .. "QuickViews"}, {"Id","DisplayName","SortMethod","FilterMethod","Flags","CreatorXUID","OrderIndex","IconHash"} },
    { {TableSubitemPadding .. "RSSFeeds"}, {"Id","Url","Enabled"} },
    { {TableSubitemPadding .. "ScanPaths"}, {"Id","Path","DeviceId","Depth","ScriptData","OptionsFlag"} },
    { {TableSubitemPadding .. "SystemSettings"}, {"Id","Name","Value"} },
    { {TableSubitemPadding .. "TitleSettings"}, {"Id","ContentId","SettingValue"} },
    { {TableSubitemPadding .. "Trainers"}, {"Id","Hash","TitleId","Value"} },
    { {TableSubitemPadding .. "UserFavorites"}, {"Id","ContentId","ProfileId"} },
    { {TableSubitemPadding .. "UserHidden"}, {"Id","ContentId","ProfileId"} },
    { {TableSubitemPadding .. "UserRecentGames"}, {"Id","DateTime","ContentId","ProfileId"} },
    { {TableSubitemPadding .. "UserSettings"}, {"Id","Name","Value","ProfileId"} }
}

CurrentQuery = ""

QueryBuilderMenu = {
    "Show SQL Syntax",
    "Show Keyboard",
    "Show Column By Table",
    "Delete Last Entry",
    "",
    "Clear Query",
    "Quit",
    "Main Menu",
    "",
    "Execute Query"
}

SqlSyntax = {
    "SELECT",
    "SELECT *",
    "UPDATE",
    "INSERT",
    "INTO",
    "DELETE",
    "DISTINCT",
    "AS",
    "SET",
    "FROM",
    "WHERE",
    "AND",
    "OR",
    "ANY",
    "ALL",
    "NOT",
    "LIKE",
    "CASE",
    "WHEN",
    "THEN",
    "ELSE",
    "END",
    "JOIN",
    "LEFT JOIN",
    "RIGHT JOIN",
    "CROSS JOIN",
    "UNION",
    "ON",
    "DO",
    "BETWEEN",
    "IN",
    "ORDER BY",
    "GROUP BY",
    "HAVING",
    "ASC",
    "DESC",
    "LIMIT",
    "NULL",
    "NOTHING",
    "EXCEPT",
    "VALUES(",
    "CONFLICT(",
    "SUM(",
    "AVG(",
    "MAX(",
    "MIN(",
    "GROUP_CONCAT(",
    "",
}

Keyboard = {
    "SPACE",
    ",",
    "'",
    "(",
    ")",
    ".",
    "=",
    "==",
    "+",
    "-",
    "*",
    "/",
    "%",
    ">",
    "<",
    ">=",
    ">=",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
    "\"",
    "-",
    "_",
    ":",
    ";",
    "{",
    "}",
    "$",
    "@",
    "!",
    "#",
    "^",
    "\\";
    "~",
    "`",
    "|",
    "&",
    ""
}

MainMenu = {
    "Manually Query Databases",
    "View Table (All Entries)"
}

-- Main entry point to script
function main()
    local selectedMenuOption = ShowMainMenu();

    local selectedTableKey =   PromptTableSelect()
    if selectedMenuOption == 1 then
        ShowTable(selectedTableKey)
    elseif selectedMenuOption == 2 then
        ShowQueryBuilder()
    end
end

-- Menu for user to build and execute queries
function ShowQueryBuilder()
    local dialogBox = Script.ShowPopupList("Query Builder", "Error", QueryBuilderMenu)
    local selected = dialogBox.Selected.Key

    if selected == QueryBuilderMenu[1] then     -- "Show SQL Syntax"
    elseif selected == QueryBuilderMenu[2] then -- "Show Keyboard"
    elseif selected == QueryBuilderMenu[3] then -- "Show Column By Table"
    elseif selected == QueryBuilderMenu[4] then -- "Delete Last Entry"
    elseif selected == QueryBuilderMenu[5] then -- ""
    elseif selected == QueryBuilderMenu[6] then -- "Clear Query"
    elseif selected == QueryBuilderMenu[7] then -- "Quit"
    elseif selected == QueryBuilderMenu[8] then -- "Main Menu"
    elseif selected == QueryBuilderMenu[9] then -- ""
    elseif selected == QueryBuilderMenu[10] then -- "Execute Query"
        
    end
end

function ShowMainMenu()
    local dialogBox = Script.ShowPopupList(scriptTitle, "Error", MainMenu)
    return dialogBox.Selected.Key
end

-- Prompts user to select a table for browsing and returns selected index
function PromptTableSelect()
    local selected = ""
    local dialogBox
    while selected == "" do
        dialogBox = Script.ShowPopupList("Database Browser", "None found.", GetTableNames())
    
        if dialogBox.Selected.Value ~= TableContentHeader and dialogBox.Selected.Value ~= TableSettingsHeader then
            selected = dialogBox.Selected.Value
        end
    end

    return dialogBox.Selected.Key
end

-- Display table in message box
function ShowTable(key)
    -- Populate table name, columns, and database entries
    local rows = {}
    local tableName = StripSubitemPadding(Tables[key][1][1])
    local columns = Tables[key][2]
    for i, row in pairs(Sql.ExecuteFetchRows("SELECT * FROM " .. tableName .. " ORDER BY " .. columns[1] .. " ASC")) do   -- Safe to assume first column will always be primary key
        rows[i] = row
    end

    -- Iterate database entries and display
    for i, row in ipairs(rows) do
        local displayRows = {}
        for j, column in ipairs(columns) do
            displayRows[j] = column .. ": " .. row[column]
        end
        Script.ShowPopupList("Table: " .. tableName .. " Entry: " .. i .. " of " .. #rows, "None found.", displayRows)
    end

    Script.ShowMessageBox("<3", "" .. columns[1], "Please God no", "No");
end

-- Returns an array of accessible table names
function GetTableNames()
    local ret = {}
    for i, innerTable in ipairs(Tables) do
        ret[i] = innerTable[1][1]
    end
    return ret
end

 -- Remove display padding and return string
function StripSubitemPadding(stringToStrip)
    return string.sub(stringToStrip, string.len(TableSubitemPadding) + 1, string.len(stringToStrip));
end