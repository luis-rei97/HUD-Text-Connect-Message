/* [CS:GO] New HUD Connect Message
 *
 *  Copyright (C) 2018 Hallucinogenic Troll
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

#pragma semicolon 1

// ConVars
ConVar g_CVAR_HudText_ConnectMessage_Red;
ConVar g_CVAR_HudText_ConnectMessage_Green;
ConVar g_CVAR_HudText_ConnectMessage_Blue;
ConVar g_CVAR_HudText_ConnectMessage_HideAdmins;
ConVar g_CVAR_HudText_ConnectMessage_X;
ConVar g_CVAR_HudText_ConnectMessage_Y;
ConVar g_CVAR_HudText_ConnectMessage_HoldTime;
ConVar g_CVAR_HudText_ConnectMessage_Country;
ConVar g_CVAR_HudText_ConnectMessage_VIP;
ConVar g_CVAR_HudText_ConnectMessage_VIP_Red;
ConVar g_CVAR_HudText_ConnectMessage_VIP_Green;
ConVar g_CVAR_HudText_ConnectMessage_VIP_Blue;

// Variables to store ConVar's Values

int g_HudText_ConnectMessage_Red;
int g_HudText_ConnectMessage_Green;
int g_HudText_ConnectMessage_Blue;
int g_HudText_ConnectMessage_HideAdmins;
int g_HudText_ConnectMessage_Country;
int g_HudText_ConnectMessage_VIP;
int g_HudText_ConnectMessage_VIP_Red;
int g_HudText_ConnectMessage_VIP_Green;
int g_HudText_ConnectMessage_VIP_Blue;
float g_HudText_ConnectMessage_X;
float g_HudText_ConnectMessage_Y;
float g_HudText_Connect_Message_HoldTime;

public Plugin myinfo = 
{
	name = "[CS:GO] HUD Text Connect Message",
	author = "Hallucinogenic Troll",
	description = "A Connect Message Plugin, using the HUD Text Message.",
	version = "2.1",
	url = "PTFun.net/newsite"
};

public void OnPluginStart()
{	
	g_CVAR_HudText_ConnectMessage_Red = CreateConVar("sm_hudtext_connectmessage_red", "255", "RGB Red Color to the Connect Message", _, true, 0.0, true, 255.0);
	g_CVAR_HudText_ConnectMessage_Green = CreateConVar("sm_hudtext_connectmessage_green", "255", "RGB Green Color to the Connect Message", _, true, 0.0, true, 255.0);
	g_CVAR_HudText_ConnectMessage_Blue = CreateConVar("sm_hudtext_connectmessage_blue", "255", "RGB Blue Color to the Connect Message", _, true, 0.0, true, 255.0);
	g_CVAR_HudText_ConnectMessage_HideAdmins = CreateConVar("sm_hudtext_connectmessage_hideadmins", "1", "Don't Show up the Connect Message to players, if it is an admin", _, true, 0.0, true, 1.0);
	g_CVAR_HudText_ConnectMessage_X = CreateConVar("sm_hudtext_connectmessage_x", "-1.0", "Horizontal Position to show the connect message (To be centered, set as -1.0)", _, true, -1.0, true, 1.0);
	g_CVAR_HudText_ConnectMessage_Y = CreateConVar("sm_hudtext_connectmessage_y", "0.125", "Vertical Position to show the connect message (To be centered, set as -1.0)", _, true, -1.0, true, 1.0);
	g_CVAR_HudText_ConnectMessage_HoldTime = CreateConVar("sm_hudtext_connectmessage_holdtime", "2.0", "Time that the message is shown", _, true, 0.0, true, 5.0);
	g_CVAR_HudText_ConnectMessage_Country = CreateConVar("sm_hudtext_connectmessage_country", "0", "Shows the Players country in the message", _, true, 0.0, true, 1.0);
	g_CVAR_HudText_ConnectMessage_VIP = CreateConVar("sm_hudtext_connectmessage_vip", "o", "Flag to show a different message for players with certain bonuses (for example, VIPs). 0 disables it");
	g_CVAR_HudText_ConnectMessage_VIP_Red = CreateConVar("sm_hudtext_connectmessage_vip_red", "0", "RGB Red Color to the VIP Connect Message", _, true, 0.0, true, 255.0);
	g_CVAR_HudText_ConnectMessage_VIP_Green = CreateConVar("sm_hudtext_connectmessage_vip_green", "255", "RGB Green Color to the VIP Connect Message", _, true, 0.0, true, 255.0);
	g_CVAR_HudText_ConnectMessage_VIP_Blue = CreateConVar("sm_hudtext_connectmessage_vip_blue", "0", "RGB Blue Color to the VIP Connect Message", _, true, 0.0, true, 255.0);
	LoadTranslations("hudtext_connectmessage.phrases");
	
	AutoExecConfig(true, "hudtext_connectmessage");
}

public void OnConfigsExecuted()
{
	g_HudText_ConnectMessage_Red = g_CVAR_HudText_ConnectMessage_Red.IntValue;
	g_HudText_ConnectMessage_Green = g_CVAR_HudText_ConnectMessage_Green.IntValue;
	g_HudText_ConnectMessage_Blue = g_CVAR_HudText_ConnectMessage_Blue.IntValue;
	g_HudText_ConnectMessage_HideAdmins = g_CVAR_HudText_ConnectMessage_HideAdmins.IntValue;
	
	g_HudText_ConnectMessage_X = g_CVAR_HudText_ConnectMessage_X.FloatValue;
	g_HudText_ConnectMessage_Y = g_CVAR_HudText_ConnectMessage_Y.FloatValue;
	g_HudText_Connect_Message_HoldTime = g_CVAR_HudText_ConnectMessage_HoldTime.FloatValue;
	g_HudText_ConnectMessage_Country = g_CVAR_HudText_ConnectMessage_Country.IntValue;
	
	char buffer[40];
	g_CVAR_HudText_ConnectMessage_VIP.GetString(buffer, sizeof(buffer));
	g_HudText_ConnectMessage_VIP = ReadFlagString(buffer);
	
	g_HudText_ConnectMessage_VIP_Red = g_CVAR_HudText_ConnectMessage_VIP_Red.IntValue;
	g_HudText_ConnectMessage_VIP_Green = g_CVAR_HudText_ConnectMessage_VIP_Green.IntValue;
	g_HudText_ConnectMessage_VIP_Blue = g_CVAR_HudText_ConnectMessage_VIP_Blue.IntValue;
}

public void OnClientPostAdminCheck(int client)
{
	if(g_HudText_ConnectMessage_HideAdmins && CheckCommandAccess(client, "", ADMFLAG_GENERIC, true))
	{
		return;
	}
	
	char message[256];
	
	Format(message, sizeof(message), "%T", CheckCommandAccess(client, "", g_HudText_ConnectMessage_VIP, true)?"VIPJoinedTheServer":"PlayerJoinedTheServer", client);
	
	if(g_HudText_ConnectMessage_Country)
	{
		char IP[64];
		char Country[64];
		
		GetClientIP(client, IP, sizeof(IP));
		
		if(GeoipCountry(IP, Country, sizeof(Country)))
		{
			Format(message, sizeof(message), "%s %T", message, "From Country", Country);
		}
	}
	
	
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			SetHudTextParams(g_HudText_ConnectMessage_X, g_HudText_ConnectMessage_Y, g_HudText_Connect_Message_HoldTime,
				CheckCommandAccess(client, "", g_HudText_ConnectMessage_VIP, true)?g_HudText_ConnectMessage_VIP_Red:g_HudText_ConnectMessage_Red, 
					CheckCommandAccess(client, "", g_HudText_ConnectMessage_VIP, true)?g_HudText_ConnectMessage_VIP_Green:g_HudText_ConnectMessage_Green, 
						CheckCommandAccess(client, "", g_HudText_ConnectMessage_VIP, true)?g_HudText_ConnectMessage_VIP_Blue:g_HudText_ConnectMessage_Blue, 255, 0, 0.25, 0.1, 0.2);
			
			ShowHudText(i, -1, message);
		}
	}
}