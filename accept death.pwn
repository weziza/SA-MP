// Injury System by GoldenLion
#define FILTERSCRIPT
#define COLOR_GRAY 0xAFAFAFFF
#define COLOR_LIGHTRED 0xFF6347FF

#include <a_samp>
#include <zcmd>
#include <sscanf2>

#if defined FILTERSCRIPT

new Injured[MAX_PLAYERS];
new AcceptDeath[MAX_PLAYERS];
new AcceptDeathTimer[MAX_PLAYERS];
new LoseHealthTimer[MAX_PLAYERS];
new Hospitalized[MAX_PLAYERS];
new Float:x, Float:y, Float:z;
new Float:angle;

forward CanAcceptDeath(playerid);
public CanAcceptDeath(playerid)
{
    AcceptDeath[playerid] = 1;
	SendClientMessage(playerid, COLOR_GRAY, "You can now accept death.");
}

forward HospitalTimer(playerid);
public HospitalTimer(playerid)
{
    Hospitalized[playerid] = 0;
	SendClientMessage(playerid, -1, "You have recovered at the All Saints General Hospital.");
	SetPlayerPos(playerid, 1178.4012, -1323.2754, 14.1183);
	SetPlayerFacingAngle(playerid, 270.0);
	SetCameraBehindPlayer(playerid);
	SetPlayerHealth(playerid, 100.0);
	TogglePlayerControllable(playerid,1);
}

forward LoseHealth(playerid);
public LoseHealth(playerid)
{
    new Float:health;
	GetPlayerHealth(playerid,health);
	SetPlayerHealth(playerid,health-5);
}

public OnPlayerUpdate(playerid)
{
	if (Injured[playerid] == 1 && GetPlayerAnimationIndex(playerid) != 386)
	{
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1);
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if (Injured[playerid] == 0)
	{
		Injured[playerid] = 1;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, angle);
	}
	else if (Injured[playerid] == 1)
	{
		KillTimer(AcceptDeathTimer[playerid]);
	    KillTimer(LoseHealthTimer[playerid]);
		AcceptDeath[playerid] = 0;
		Injured[playerid] = 0;
		Hospitalized[playerid] = 1;
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if (Injured[playerid] == 1)
	{
		SetPlayerPos(playerid, x, y, z);
		SetPlayerFacingAngle(playerid, angle);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_LIGHTRED, "You are injured.");
		SendClientMessage(playerid, COLOR_LIGHTRED, "Either wait for assistance or /acceptdeath.");
		AcceptDeathTimer[playerid] = SetTimer("CanAcceptDeath", 60000, false);
		LoseHealthTimer[playerid] = SetTimer("LoseHealth", 10000, true);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0, 1);
	}
	
	if (Hospitalized[playerid] == 1)
	{
		SetTimer("HospitalTimer", 10000, false);
		TogglePlayerControllable(playerid,0);
		SetPlayerPos(playerid, 1169.9645, -1323.8893, 15.6929);
		SetPlayerCameraPos(playerid, 1201.5150, -1323.3530, 24.7329);
		SetPlayerCameraLookAt(playerid, 1173.2358, -1323.2872, 19.4348);
		SendClientMessage(playerid, COLOR_GRAY, "You must stay 10 seconds at the hospital to recover.");
		GameTextForPlayer(playerid, "~n~~w~Recovering...", 10000, 3);
	}
	return 1;
}

CMD:acceptdeath(playerid, params[])
{
  if (Injured[playerid] == 1)
  {
	if (AcceptDeath[playerid] == 1)
	{
		SetPlayerHealth(playerid, 0.0);
		KillTimer(LoseHealthTimer[playerid]);
		SendClientMessage(playerid, COLOR_GRAY, "You have accepted death.");
		
	}
	else if (AcceptDeath[playerid] == 0)
	{
		SendClientMessage(playerid, COLOR_GRAY, "You must wait at least 1 minute before accepting death.");
	}
  }
  else if (Injured[playerid] == 0)
  {
	SendClientMessage(playerid, COLOR_GRAY, "You are not injured right now.");
  }
  return 1; 
}

CMD:revive(playerid, params[])
{
    new targetid;
	
	if (!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_GRAY, "You are not an admin.");
	
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GRAY, "Usage: /revive [playerid]");

	if (targetid == INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GRAY, "That player is not online.");
	
	if (Injured[targetid] == 0) return SendClientMessage(playerid, COLOR_GRAY, "That player is not injured.");
	
	new playername[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playername, sizeof(playername));
	
	new targetname[MAX_PLAYER_NAME];
    GetPlayerName(targetid, targetname, sizeof(targetname));
	
	new string[24+MAX_PLAYER_NAME];
	
	format(string, sizeof(string), "You have revived %s.", targetname);
    SendClientMessage(playerid, -1, string);
	
	format(string, sizeof(string), "%s has revived you.", playername);
    SendClientMessage(targetid, -1, string);
	
	KillTimer(AcceptDeathTimer[targetid]);
	KillTimer(LoseHealthTimer[targetid]);
	AcceptDeath[targetid] = 0;
	Injured[targetid] = 0;
	ClearAnimations(targetid);
	SetPlayerHealth(targetid, 100.0);
    return 1;
}

#endif
