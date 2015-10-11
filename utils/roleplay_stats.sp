/*
 * Cette oeuvre, création, site ou texte est sous licence Creative Commons Attribution
 * - Pas d’Utilisation Commerciale
 * - Partage dans les Mêmes Conditions 4.0 International. 
 * Pour accéder à une copie de cette licence, merci de vous rendre à l'adresse suivante
 * http://creativecommons.org/licenses/by-nc-sa/4.0/ .
 *
 * Merci de respecter le travail fourni par le ou les auteurs 
 * https://www.ts-x.eu/ - kossolax@ts-x.eu
 */
#pragma semicolon 1

#include <sourcemod>
#include <sdkhooks>
#include <smlib>
#include <colors_csgo>
#include <basecomm>

#define __LAST_REV__ 		"v:0.1.0"

#pragma newdecls required
#include <roleplay.inc>	// https://www.ts-x.eu

//#define DEBUG

public Plugin myinfo = {
	name = "Utils: Stats", author = "KoSSoLaX",
	description = "RolePlay - Utils: Stats",
	version = __LAST_REV__, url = "https://www.ts-x.eu"
};

public void OnPluginStart() {
	for (int i = 1; i <= MaxClients; i++)
		if( IsValidClient(i) )
			OnClientPostAdminCheck(i);
}

public void OnClientPostAdminCheck(int client) {
	rp_HookEvent(client, RP_OnPlayerCommand, fwdCommand);
	for(int i=0;i<view_as<int>(i_uStat_max);i++)
		rp_SetClientStat(client, view_as<int_stat_data>(i), 0);

	rp_SetClientStat(client, i_Money_OnConnection, ( rp_GetClientInt(client, i_Money) + rp_GetClientInt(client, i_Bank) ));
	rp_SetClientStat(client, i_PVP_OnConnection, ( rp_GetClientInt(client, i_Money) + rp_GetClientInt(client, i_Bank) ));
	rp_SetClientStat(client, i_Vitality_OnConnection, view_as<int>(rp_GetClientFloat(client, fl_Vitality)) );
}

public Action fwdCommand(int client, char[] command, char[] arg) {
	#if defined DEBUG
	PrintToServer("fwdCommand");
	#endif
	if( StrEqual(command, "compteur") || StrEqual(command, "count") ) {
		DisplayStats(client);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public void DisplayStats(int client){
	char tmp[128];
	Handle menu = CreateMenu(MenuNothing);
	SetMenuTitle(menu, "Vos stats:");
	Format(tmp, sizeof(tmp), "Evolution de l'argent sur la session: %i", rp_GetClientStat(client, i_Money_OnConnection)-rp_GetClientInt(client, i_Money));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent gagné par la paye: %i", rp_GetClientStat(client, i_MoneyEarned_Pay));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent gagné par les missions telephone: %i", rp_GetClientStat(client, i_MoneyEarned_Phone));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent gagné via metier: %i", rp_GetClientStat(client, i_MoneyEarned_Sales));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent ramassé: %i", rp_GetClientStat(client, i_MoneyEarned_Pickup));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent gagné par les machines: %i", rp_GetClientStat(client, i_MoneyEarned_CashMachine));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent recu: %i", rp_GetClientStat(client, i_MoneyEarned_Give));
	AddMenuItem(menu, "", tmp);

	AddMenuItem(menu, "", "------------------------------------------");

	Format(tmp, sizeof(tmp), "Argent perdu en amendes: %i", rp_GetClientStat(client, i_MoneySpent_Fines));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent perdu en achetant: %i", rp_GetClientStat(client, i_MoneySpent_Shop));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent donné: %i", rp_GetClientStat(client, i_MoneySpent_Give));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent perdu par Vol: %i", rp_GetClientStat(client, i_MoneySpent_Stolen));
	AddMenuItem(menu, "", tmp);

	AddMenuItem(menu, "", "------------------------------------------");

	Format(tmp, sizeof(tmp), "Evolution de la vitalité: %i", rp_GetClientStat(client, i_Vitality_OnConnection)-view_as<int>(rp_GetClientFloat(client, fl_Vitality)));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent perdu au loto: %i", rp_GetClientStat(client, i_LotoSpent));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Argent gagné au loto: %i", rp_GetClientStat(client, i_LotoWon));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Evolution des points PVP: %i", rp_GetClientInt(client, i_PVP)-rp_GetClientStat(client, i_PVP_OnConnection));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Nombre de build: %i", rp_GetClientStat(client, i_TotalBuild));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Distance courue: %im", rp_GetClientStat(client, i_RunDistance));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Actions de job réussies: %i", rp_GetClientStat(client, i_JobSucess));
	AddMenuItem(menu, "", tmp);
	Format(tmp, sizeof(tmp), "Actions de job ratées: %i", rp_GetClientStat(client, i_JobFails));
	AddMenuItem(menu, "", tmp);
	
	DisplayMenu(menu, client, 60);
}

public int MenuNothing(Handle menu, MenuAction action, int client, int param2) {
	#if defined DEBUG
	PrintToServer("MenuNothing");
	#endif
	if( action == MenuAction_Select ) {
		if( menu != INVALID_HANDLE )
			CloseHandle(menu);
	}
	else if( action == MenuAction_End ) {
		if( menu != INVALID_HANDLE )
			CloseHandle(menu);
	}
}