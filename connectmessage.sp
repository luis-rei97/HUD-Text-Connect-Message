#include <sourcemod>
#include <geoip>
#include <sdktools>

// CVAR to enable the plugin;
Handle g_connect_enable = INVALID_HANDLE;
Handle g_connect_red = INVALID_HANDLE;
Handle g_connect_green = INVALID_HANDLE;
Handle g_connect_blue = INVALID_HANDLE;

public Plugin myinfo = 
{
	name = "New Custom Hud Connect's Message",
	author = "Hallucinogenic Troll, Bulletford for the Snippet",
	description = "A Plugin which you can use the new HUD to a player connection.",
	version = "1.0",
	url = ""
};

public void OnPluginStart()
{	
	g_connect_enable = CreateConVar("sm_connect_enable", "1", "It shows the connect messages in the new HUD.", FCVAR_NOTIFY | FCVAR_DONTRECORD);
	g_connect_red = CreateConVar("sm_connect_red", "255", "RGB Code for the Red color used in the text");
	g_connect_green = CreateConVar("sm_connect_red", "255", "RGB Code for the Green color used in the text");
	g_connect_blue = CreateConVar("sm_connect_red", "255", "RGB Code for the Blue color used in the text");
	AutoExecConfig(true, "newhud_connectmessage");
}

public void OnClientPutInServer(int client)
{
	if(g_connect_enable)
	{
		char name[99];
		char IP[99];
		char country[99];
		char message[256];
		
		// Information to add in the connect message;
		GetClientName(client, name, sizeof(name));
		GetClientIP(client, IP, sizeof(IP), true);
		
		// Creating the entity
		int entity = CreateEntityByName("game_text");
		DispatchKeyValue(entity, "channel", "1");
		
		// Getting the RGB code from the colors you set in the cfg
		int red = GetConVarInt(g_connect_red);
		int green = GetConVarInt(g_connect_green);
		int blue = GetConVarInt(g_connect_blue);
		
		// Since it's a string, let's put all together
		char rgb_colors[64];
		Format(rgb_colors, 64, "%d %d %d", red, green, blue);
		
		DispatchKeyValue(entity, "color", rgb_colors);
		DispatchKeyValue(entity, "color2", "0 0 0");
		DispatchKeyValue(entity, "effect", "0");
		DispatchKeyValue(entity, "fadein", "1.5");
		DispatchKeyValue(entity, "fadeout", "0.5");
		DispatchKeyValue(entity, "fxtime", "0.25");
		DispatchKeyValue(entity, "holdtime", "5.0");
		if(!GeoipCountry(IP, country, sizeof(country)))
		{
			Format(message, 256, "Player %s joined the server!", name);
			DispatchKeyValue(entity, "message", message);
		}
		else
		{
			Format(message, 256, "Player %s joined the server from %s!", name, country);
			DispatchKeyValue(entity, "message", message);
		}
		DispatchKeyValue(entity, "spawnflags", "0"); 	
		DispatchKeyValue(entity, "x", "0.25");
		DispatchKeyValue(entity, "y", "0.125"); 		
		DispatchSpawn(entity);
		SetVariantString("!activator");
		
		for (int i = 0; i < MaxClients; i++)
		{
			if(IsValidClient(i))
			{
				AcceptEntityInput(entity, "display", i);
			}
		}
        
	} 
	else
	{
		CloseHandle(g_connect_enable);
	}
}

stock bool IsValidClient(int client)
{
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && IsPlayerAlive(client))
	{
		return true;
	}
	
	return false;
}