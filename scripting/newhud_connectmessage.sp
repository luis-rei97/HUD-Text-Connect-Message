/* [CS:GO] New HUD Connect Message
 *
 *  Copyright (C) 2017 Hallucinogenic Troll
 * 
 * This program is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see http://www.gnu.org/licenses/.
 */


#include <sourcemod>
#include <geoip>
#include <sdktools>

//Compiler Options
#pragma semicolon 1
#pragma newdecls required

// CVARs to customize the HUD as you want;
ConVar g_connect_enable;
ConVar g_connect_red;
ConVar g_connect_green;
ConVar g_connect_blue;
ConVar g_connect_fade_in;
ConVar g_connect_fade_out;
ConVar g_connect_x_coordenates;
ConVar g_connect_y_coordenates;
ConVar g_connect_hold_time;

public Plugin myinfo = 
{
	name = "New Custom Hud Connect's Message",
	author = "Hallucinogenic Troll, Bulletford for the Snippet",
	description = "A Plugin which you can use the new HUD to a player connection.",
	version = "1.4",
	url = "PTFun.net/newsite"
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
	
	LoadTranslations("newhud_connectmessage.phrases");
	
	AutoExecConfig(true, "newhud_connectmessage");
}

public void OnClientPostAdminCheck(int client)
{
	// Check if you enabled the plugin (with the cvar set on 1);
	
	if(g_connect_enable)
	{			
		
		if(CheckCommandAccess(client, "sm_admin", ADMFLAG_GENERIC))
		{
			return;
		}
			
		char name[99];
		char IP[99];
		char country[99];
		char message[256];
		
		// Information to add in the connect message;
		GetClientName(client, name, sizeof(name));
		GetClientIP(client, IP, sizeof(IP), true);
		
		// Getting the RGB code from the colors you set in the cfg
		int red = GetConVarInt(g_connect_red);
		int green = GetConVarInt(g_connect_green);
		int blue = GetConVarInt(g_connect_blue);
		
		// Getting the time you want to appear in the screen
		float fade_in = GetConVarFloat(g_connect_fade_in);
		
		// Getting the time you want to disappear in the screen
		float fade_out = GetConVarFloat(g_connect_fade_out);
		
		// Getting the time you want to stay in the screen
		float hold_time = GetConVarFloat(g_connect_hold_time);
		
		// If it can't trace your country, it won't display saying "Unknown Country";
		if(!GeoipCountry(IP, country, sizeof(country)))
		{
			Format(message, 256, "%t", "PlayerConnectWithoutCountry", name);
		}
		else
		{
			Format(message, 256, "%t", "Player Connected With Country", name, country);
		}
		
		
		// Getting the horizontal coordenates you want in the screen;
		float x_coord = GetConVarFloat(g_connect_x_coordenates);
		
		// Getting the vertical coordenates you want in the screen;
		float y_coord = GetConVarFloat(g_connect_y_coordenates);
		
		// Since the Text Parameters are now supported in CS:GO, it's better to use this way.
		for(int i = 1; i <= MaxClients; i++)
		{
			if(IsClientInGame(i) && !IsFakeClient(i))
			{
				SetHudTextParams(x_coord, y_coord, hold_time, red, green, blue, 255, 0, 0.25, fade_in, fade_out);
				ShowHudText(client, 5, message);
			}
		}
    
		
		
	}
}