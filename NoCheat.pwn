/*================== Credits =================		
	____________________________________________	
		This script has been scripted by Rajat		
			_________________________________		
			|     ANTI HACK /BOT ATTACK     |		
/* *************************************************
                    *   __________					
                    *  |           |           *	
 					*  |           |           *	
 					*  |           |           *	
 					*  |           |           *	
 					*  |          /            *	
					*  |__________             *	
				 	*  |           \           *	
				 	*  |            \          *	
 					*  |             \         *	
 					*              Rajat			
************************************************   */		


//--------------------------------------------INCLUDES-----------------------------------------
#include "a_samp"
//--------------------------------------------INCLUDES-----------------------------------------

new var[MAX_PLAYERS] = {-1,...}, warns[MAX_PLAYERS] = {0,...}, bool:npc[MAX_PLAYERS] = {false,...}, MAX_PLAYERS_ = MAX_PLAYERS;


new Float:_oldHealth, Float:_oldArmour;

new pMoney[MAX_PLAYERS];

new PlayerPressedJump[MAX_PLAYERS];

new Timer[MAX_PLAYERS];
//------------------------------------------------DEFINES-----------------------------------------------
#define MAX_PING 700
#define MAX_CAR_SPEED 450
//--------------------------------------------OnFilterScriptInit-----------------------------------------
public OnFilterScriptInit()
{
	SendRconCommand("reloadbans");
	print("------------------------------------------------------");
	print("-------------Anti Bot Attack By Ryder Now Loaded------");
	print("------------------------------------------------------");
	return 1;
}

forward CP(playerid);

forward PJ(playerid);

forward PJR(playerid);

forward CarSpeed(playerid);

//--------------------------------------------OnFilterScriptInit-----------------------------------------
//--------------------------------------------OnPlayerConnect-----------------------------------------
public OnPlayerConnect(playerid)
{
	pMoney[playerid] = 0;
	if(CountIP(GetIP(playerid)) >= 2) return BA(playerid), 0;
	MAX_PLAYERS_ = playerid > MAX_PLAYERS_ ? playerid : GetHighestID(),
	npc[playerid] = bool:IsPlayerNPC(playerid),
	var[playerid] = SetTimerEx("BSS",2500,false,"i",playerid),
	warns[playerid] = 0;
	return 1;
}
//--------------------------------------------OnPlayerConnect-----------------------------------------
//--------------------------------------------OnPlayerDisconnect-----------------------------------------
public OnPlayerDisconnect(playerid, reason)
{
	pMoney[playerid] = 0;
	MAX_PLAYERS_ = GetHighestID(playerid);
	if(npc[playerid]) npc[playerid] = false;
	if(var[playerid] != -1)
	{
		KillTimer(var[playerid]);
		var[playerid] = -1;
	}
	warns[playerid] = 0;
	return 1;
}
//--------------------------------------------OnPlayerDisconnect-----------------------------------------
//--------------------------------------------OnPlayerSpawn----------------------------------------------
public OnPlayerSpawn(playerid)
{
    Timer[playerid] = SetTimerEx("CP",990,1,"i",playerid);
    return 1;
}
//--------------------------------------------OnPlayerSpawn-----------------------------------------------
//--------------------------------------------ONPLAYERUPDATE-----------------------------------------------
public OnPlayerUpdate(playerid)
{
    new Float:health, Float:armour;
    GetPlayerHealth(playerid,health);
    GetPlayerArmour(playerid,armour);
    _oldHealth = health;
    _oldArmour = armour;
    new PlayerWeapon[MAX_PLAYERS];
    new gunname[32];
    new string[120];
    PlayerWeapon[playerid] = GetPlayerWeapon(playerid);
    if(PlayerWeapon[playerid] == 38 || PlayerWeapon[playerid] == 39 || PlayerWeapon[playerid] == 36 || PlayerWeapon[playerid] == 35 || PlayerWeapon[playerid] == 37 || PlayerWeapon[playerid] == 40)
    {
        GetWeaponName(PlayerWeapon[playerid],gunname,sizeof(gunname));
        format(string,sizeof(string),"{FF00FF}[Anti Cheat / Hack] {15FF00}Player: {FF0000}%s {15FF00}with ID: {FF0000} %d {15FF00}has been Kicked from {FF0000}The Server || {FFFF00}Reason: {15FF00}Weapon Hack",GetName(playerid),playerid,gunname);
        SendClientMessageToAll(-1,string);
        Kick(playerid);
    }
    if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK)
    {
        new string2[120];
        format(string,sizeof(string),"{FF00FF}[Anti Cheat / Hack] {15FF00}Player: {FF0000}%s {15FF00}with ID: {FF0000} %d {15FF00}has been Kicked from {FF0000}The Server || {FFFF00}Reason: {15FF00}Jetpack Hack",GetName(playerid),playerid);
        SendClientMessageToAll(-1,string2);
        Kick(playerid);
    }
    new pName[MAX_PLAYER_NAME];
    if(GetPlayerMoney(playerid) > pMoney[playerid])
    {
        GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
    }
    return 1;
}
//--------------------------------------------ONPLAYERUPDATE-----------------------------------------------
//--------------------------------------------ONPLAYERTAKENDAMAGE-----------------------------------------------
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
    if(playerid != INVALID_PLAYER_ID)
    {
	    new Float:nHealth, Float:nArmour, localString[128],pName[24];
		GetPlayerHealth(playerid,nHealth);
        GetPlayerArmour(playerid,nArmour);
        GetPlayerName(playerid,pName,24);
        if(nHealth == _oldHealth && nArmour == _oldArmour)
        {
            format(localString,sizeof(localString),"{FF00FF}[Anti Cheat / Hack] {15FF00}Player: {FF0000}%s {15FF00}with ID: {FF0000} %d {15FF00}has been Kicked from {FF0000}The Server || {FFFF00}Reason: {15FF00}Health/God/Armour Hack");
            SendClientMessageToAll(-1,localString);
            Kick(playerid);
        }
    }
    return 1;
}

//--------------------------------------------OnPlayerSpawn-----------------------------------------------
//--------------------------------------------CP-----------------------------------------------
public CP(playerid)
{
    if(GetPlayerPing(playerid) > MAX_PING) Kick(playerid);
}
//--------------------------------------------PJ-----------------------------------------------
public PJ(playerid)
{
    PlayerPressedJump[playerid] = 0;
    ClearAnimations(playerid);
    return 1;
}
//--------------------------------------------PJR-----------------------------------------------
public PJR(playerid)
{
    PlayerPressedJump[playerid] = 0; 
    return 1;
}
//--------------------------------------------A_SETPLAYERMONEY-----------------------------------------------

stock a_SetPlayerMoney(playerid, money)
{
    pMoney[playerid] = money;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, money);
}
//--------------------------------------------GETNAME-----------------------------------------------
stock GetName(playerid)
{
    new pName22[68];
    GetPlayerName(playerid, pName22, sizeof(pName22));
    return pName22;
}
//--------------------------------------------GETPLAYERSPEED-----------------------------------------------
stock GetPlayerSpeed(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    else GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 179.28625;
    return floatround(ST[3]);
}

//--------------------------------------------A_GIVEPLAYERMONEY-----------------------------------------------
stock a_GivePlayerMoney(playerid, money)
{
    pMoney[playerid] += money;
    GivePlayerMoney(playerid, money);
}
//--------------------------------------------COUNTIP-----------------------------------------------
stock CountIP(ip[])
{
	new c = 0;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !strcmp(GetIP(i),ip)) c++;
	return c;
}
//--------------------------------------------BSS-----------------------------------------------
forward BSS(playerid);
public BSS(playerid)
{
	new i = GetPlayerPing(playerid);
	if(i <= 0 || i >= 50000)
	{
		if(warns[playerid] >= 1) BA(playerid);
		else warns[playerid]++, var[playerid] = SetTimerEx("BSS",1500,false,"i",playerid);
	}
	return 0;
}
stock GetIP(playerid)
{
	new ip[16];
	GetPlayerIp(playerid,ip,sizeof(ip));
	return ip;
}
stock BA(playerid)
{
	new ip[32];
	GetPlayerIp(playerid,ip,sizeof(ip));
	for(new i = 0, p = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && !npc[i])
	{
		p = GetPlayerPing(i);
		if(i == playerid || !strcmp(ip,GetIP(i)) || p <= 0 || p >= 50000)
		{
			BanEx(i,"Bot");
			if(var[i] != -1)
			{
				KillTimer(var[i]);
				var[i] = -1;
			}
		}
	}
	format(ip,sizeof(ip),"banip %s",ip);
	return SendRconCommand(ip);
}
stock GetHighestID(exceptof = INVALID_PLAYER_ID)
{
	new h = 0;
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && i != exceptof && i > h) h = i;
	return h;
}
