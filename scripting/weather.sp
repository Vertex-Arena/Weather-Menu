#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>

#define PLUGIN_VERSION "0.6"

public Plugin myinfo =
{
    name = "[IOS] Weather Menu",
    author = "inactivo",
    description = "Allows administrators to change the weather.",
    version = PLUGIN_VERSION,
    url = "dsc.gg/vertexar"
};

public void OnPluginStart()
{
    RegAdminCmd("sm_weather", Command_Weather, ADMFLAG_GENERIC, "Change the weather");
    LoadTranslations("weather.phrases");
}

public Action Command_Weather(int client, int args)
{
    if (!client)
    {
        ReplyToCommand(client, "[SM] This command cannot be used from console.");
        return Plugin_Handled;
    }

    Menu menu = new Menu(Handle_WeatherMenu);
    menu.SetTitle("%t", "PickTheWeather");

    char rainy[16];
    Format(rainy, sizeof(rainy), "%t", "Rainy");
    menu.AddItem("1", rainy);

    char snowy[16];
    Format(snowy, sizeof(snowy), "%t", "Snowy");
    menu.AddItem("2", snowy);

    char sunny[16];
    Format(sunny, sizeof(sunny), "%t", "Sunny");
    menu.AddItem("0", sunny);

    menu.Display(client, 20);
    return Plugin_Handled;
}

public int Handle_WeatherMenu(Menu menu, MenuAction action, int param1, int param2)
{
    if (action == MenuAction_Select)
    {
        char option[4];
        menu.GetItem(param2, option, sizeof(option));
        int weather = StringToInt(option);

        char weatherString[16];
        switch (weather)
        {
            case 1: Format(weatherString, sizeof(weatherString), "%T", "Rainy", param1);
            case 2: Format(weatherString, sizeof(weatherString), "%T", "Snowy", param1);
            case 0: Format(weatherString, sizeof(weatherString), "%T", "Sunny", param1);
        }

        ServerCommand("mp_weather %d", weather);
        PrintToChat(param1, "[SM] \x04%t", "WeatherChangedTo", weatherString);
    }
    return 0;
}