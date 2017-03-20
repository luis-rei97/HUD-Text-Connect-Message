#include <sourcemod>
#include <geoip>
#include <sdktools>

// CVAR to enable the plugin;
Handle g_connect_enable = INVALID_HANDLE;
Handle g_connect_red = INVALID_HANDLE;
Handle g_connect_green = INVALID_HANDLE;
Handle g_connect_blue = INVALID_HANDLE;
Handle g_connect_fade_in = INVALID_HANDLE;
Handle g_connect_fade_out = INVALID_HANDLE;
Handle g_connect_x_coordenates = INVALID_HANDLE;
Handle g_connect_y_coordenates = INVALID_HANDLE;
Handle g_connect_hold_time = INVALID_HANDLE;

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
	g_connect_green = CreateConVar("sm_connect_green", "255", "RGB Code for the Green color used in the text");
	g_connect_blue = CreateConVar("sm_connect_blue", "255", "RGB Code for the Blue color used in the text", _, true, 0.0, true, 255.0);
	g_connect_fade_in = CreateConVar("sm_connect_fade_in", "1.5", "Time you want (in seconds) to appear completely in your screen", _, true, 0.0, false);
	g_connect_fade_out = CreateConVar("sm_connect_fade_out", "0.5", "Time you want (in seconds) to disappear completely in your screen", _, true, 0.0, false);
	g_connect_hold_time = CreateConVar("sm_connect_hold_time", "5.0", "Time you want (in seconds) to stay in the screen", _, true, 0.0, false);
	g_connect_x_coordenates = CreateConVar("sm_connect_x", "0.25", "How much you want (horizontally) your text? 0.0 = Left, 1.0 = Right", _, true, 0.0, true, 1.0);
	g_connect_y_coordenates = CreateConVar("sm_connect_y", "0.125", "How much you want (vertically) your text? 0.0 = Top, 1.0 = Bottom", _, true, 0.0, true, 1.0);
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
		
		char rgb_colors[64];
		Format(rgb_colors, 64, "%d %d %d", red, green, blue);
		
		DispatchKeyValue(entity, "color", rgb_colors);
		DispatchKeyValue(entity, "color2", "0 0 0");
		DispatchKeyValue(entity, "effect", "0");
		
		// Getting the time you want to appear in the screen
		float fade_in = GetConVarFloat(g_connect_fade_in);
		
		char fade_in_char[64];
		Format(fade_in_char, 64, "%f", fade_in)
		DispatchKeyValue(entity, "fadein", fade_in_char);
		
		// Getting the time you want to disappear in the screen
		float fade_out = GetConVarFloat(g_connect_fade_out);
		
		char fade_out_char[64];
		Format(fade_out_char, 64, "%f", fade_out)
		DispatchKeyValue(entity, "fadeout", fade_out_char);
		
		
		DispatchKeyValue(entity, "fxtime", "0.25");
		
		// Getting the time you want to stay in the screen
		float hold_time = GetConVarFloat(g_connect_hold_time);
		char hold_time_char[64];
		Format(hold_time_char, 64, "%f", hold_time);
		
		DispatchKeyValue(entity, "holdtime", hold_time_char);
		if(!GeoipCountry(IP, country, sizeof(country)))
		{
			Format(message, 256, "Player %s has joined the server!", name);
			DispatchKeyValue(entity, "message", message);
		}
		else
		{
			Format(message, 256, "Player %s has joined the server, from %s!", name, country);
			DispatchKeyValue(entity, "message", message);
		}
		
		DispatchKeyValue(entity, "spawnflags", "1"); 	
		
		
		// Getting the horizontal coordenates you want in the screen;
		float x_coord = GetConVarFloat(g_connect_x_coordenates);
		char x_coord_char[64];
		Format(x_coord_char, 64, "%f", x_coord);
		DispatchKeyValue(entity, "x", x_coord_char);
		
		// Getting the vertical coordenates you want in the screen;
		float y_coord = GetConVarFloat(g_connect_y_coordenates);
		char y_coord_char[64];
		Format(y_coord_char, 64, "%f", y_coord);
		DispatchKeyValue(entity, "y", y_coord_char);
		
		DispatchSpawn(entity);
		SetVariantString("!activator");
		
		AcceptEntityInput(entity, "display");
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