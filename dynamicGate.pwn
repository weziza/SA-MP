
// Recoded w3z, Now you can use horn when near the gates.
// Auto creation .ini file if its dont, make new one!
// 77



#define FILTERSCRIPT
#include <a_samp>
#include <dini>
#include <sscanf2>
#include <zcmd>

#define GATE_PATH "Gates/gate_%i.ini"
#define MAX_GATES 	500
#define GATE_OBJECT 980
#define CLOSED 		0
#define OPENED 		1
new killtimer1[MAX_PLAYERS];
enum GInf{
	Created,
	Password[256],
	Float:ox,
	Float:oy,
	Float:oz,
	Float:cx,
	Float:cy,
	Float:cz,
	Float:rox,
	Float:roy,
	Float:roz,
	Float:rcx,
	Float:rcy,
	Float:rcz,
	Autogate,
	Status,
	Object,
	Float:Speed

};
new GInfo[MAX_GATES][GInf];
new idob[MAX_PLAYERS];
new bool:open[MAX_PLAYERS], bool:close[MAX_PLAYERS], bool:remove[MAX_PLAYERS]; 
public OnFilterScriptInit()
{
	printf("Dynamic Gate System runned");
	new file[256];
	for(new i = 1, j = MAX_GATES; i<=j; i++)
	{
		format(file, sizeof(file), GATE_PATH, i);
		if(fexist(file))
		{
			new objectid;
			objectid = CreateObject( GATE_OBJECT, dini_Float(file, "CX"), dini_Float(file, "CY"), dini_Float(file, "CZ"), dini_Float(file, "RCX"), dini_Float(file, "RCY"), dini_Float(file, "RCZ"));
			GInfo[i][Created] = 1;
			GInfo[i][Status] = CLOSED;
			GInfo[i][ox] = dini_Float(file, "OX");
			GInfo[i][oy] = dini_Float(file, "OY");
			GInfo[i][oz] = dini_Float(file, "OZ");
			
			GInfo[i][cx] = dini_Float(file, "CX");
			GInfo[i][cy] = dini_Float(file, "CY");
			GInfo[i][cz] = dini_Float(file, "CZ");
			
			GInfo[i][rcx] = dini_Float(file, "RCX");
			GInfo[i][rcy] = dini_Float(file, "RCY");
			GInfo[i][rcz] = dini_Float(file, "RCZ");

			GInfo[i][rox] = dini_Float(file, "ROX");
			GInfo[i][roy] = dini_Float(file, "ROY");
			GInfo[i][roz] = dini_Float(file, "ROZ");
			
			GInfo[i][Autogate] = dini_Int(file, "Autogate");
			GInfo[i][Speed] = dini_Int(file, "Speed");
			GInfo[i][Object] = objectid;
			new pass[256];
			pass = dini_Get(file, "Password");
			GInfo[i][Password] = pass;
		}else{
			printf("The Gates that are created:%i", i-1);
			break;
		}
	}
	return 1;
}

public OnFilterScriptExit()
{
	printf("Dynamic Gate System has stopped");
	return 1;
}
public OnPlayerConnect(playerid) 
{
    killtimer1[playerid] = SetTimerEx("auto", 500, 1, "i", playerid);
    return 1;
} 

forward auto(playerid);

public auto(playerid)
{
	//new neargate = 0;
	for(new i = 0, j = MAX_GATES; i!=j; i++)
	{
		new file[256];
		format(file, sizeof(file), GATE_PATH, i);
		if(fexist(file))
		{
			if(dini_Int(file, "Autogate") == 1)
			{
				new pass[256];
				pass = dini_Get(file, "Password");
				if(!strcmp(pass, "None", true, 4))
				{
					for(new g = 0, k = MAX_PLAYERS; g!=k; g++)
					{
						if(IsPlayerConnected(g))
						{
							if(IsPlayerInRangeOfPoint(playerid, 6, dini_Float(file, "CX"), dini_Float(file, "CY"), dini_Float(file, "CZ")))
							{
								MoveObject( GInfo[i][Object], GInfo[i][ox], GInfo[i][oy], GInfo[i][oz], GInfo[i][Speed], GInfo[i][rox], GInfo[i][roy], GInfo[i][roz]);
								GInfo[i][Status] = OPENED;
							}else{
								MoveObject( GInfo[i][Object], GInfo[i][cx], GInfo[i][cy], GInfo[i][cz], GInfo[i][Speed], GInfo[i][rcx], GInfo[i][rcy], GInfo[i][rcz]);
								GInfo[i][Status] = CLOSED;
							}
						}
					}
				}
			}
		}
	}
	//MoveObject( GInfo[i][Object], GInfo[i][ox], GInfo[i][oy], GInfo[i][oz], GInfo[i][Speed], GInfo[i][rox], GInfo[i][roy], GInfo[i][roz]); open
	//MoveObject( GInfo[i][Object], GInfo[i][cx], GInfo[i][cy], GInfo[i][cz], GInfo[i][Speed], GInfo[i][rcx], GInfo[i][rcy], GInfo[i][rcz]); close
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	KillTimer(killtimer1[playerid]);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys ==  KEY_CROUCH)
	{
		new id = WhichGateIsNearPlayerForHorn(playerid);
		if(id == 0) return 0;
		new file[256];
		format(file, sizeof(file), GATE_PATH, id);
		new pass[256];
		pass = dini_Get(file, "Password");
		if(!strcmp(pass, "None", true, 4))
		{
			OpenOrCloseGate(id);
		}
	}
	return 1;
}
CMD:creategate(playerid, params[])
{
	new password[256], containspass, speed;
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, Float:x, Float:y, Float:z);
	if(sscanf(params, "i", containspass)) return SendClientMessage(playerid, -1, "USAGE:/creategate <1-Has password || 0-Has not password>");
	if(containspass == 0)
	{
		new autog;
		if(sscanf(params, "s[128]ii", params, speed, autog)) return SendClientMessage(playerid, -1, "USAGE:/creategate 0 <speed> <autogate: 1-ON || 0-OFF>");
		CreateGate("None", x, y, z, 0, autog, speed);
	}
	if(containspass == 1)
	{
		if(sscanf(params, "s[128]is[256]", params, speed, password)) return SendClientMessage(playerid, -1, "USAGE:/creategate 1 <speed> <password>");
		CreateGate(password, x, y, z, 0, 0, speed);
	}
	SendClientMessage(playerid, -1, "Now do /editgate open then /editgate close");
	SetPlayerPos(playerid, Float:x+1, Float:y+1, Float:z+1);

	return true;
}
CMD:gate(playerid, params[])
{
	new gatesnear = 0;
	for(new i = 1; i!=MAX_GATES; i++)
	{
		if(GInfo[i][Created] == 1)
		{
			new file[256];
			format(file, sizeof(file), GATE_PATH, i);
			if(IsPlayerInRangeOfPoint(playerid, 6, dini_Float(file, "OX"), dini_Float(file, "OY"), dini_Float(file, "OZ")))
			{
				gatesnear++;
				if(!strcmp(GInfo[i][Password], "None"))
				{
					OpenOrCloseGate(i);
					break;
				}else
				{
					new password[80];
					if(sscanf(params, "s[80]", password)) return SendClientMessage(playerid, -1, "USAGE:/gate <password>");
					if(!strcmp(password, GInfo[i][Password]))
					{
						OpenOrCloseGate(i); 
						break;
					}else return SendClientMessage(playerid, -1, "Wrong password");
				}
			}
		}
	}
	if(gatesnear < 1) return SendClientMessage(playerid, -1, "You are not near any gate.");
	return 1;
}
CMD:removegate(playerid, params[])
{
	SelectObject(playerid);
	remove[playerid] = true;
	return 1;
}
CMD:editgate(playerid, params[])
{
	new file[256], pass[256];
	pass = dini_Get(file, "Password");
	new Float:speed = 0;
	if(sscanf(params, "s[128]", params)) return SendClientMessage(playerid, -1, "USAGE:/editgate <speed || password || autogate || open || close>");
	if(!strcmp(params, "speed", true, 5))
	{
		new i;
		if(HowManyGatesNearPlayer(playerid) == 0) return SendClientMessage(playerid, -1, "You arn't near any gate");
		i = WhichGateIsNearPlayer(playerid);
		format(file, sizeof(file), GATE_PATH, i);
		if(sscanf(params, "s[128]f", params, speed)) return SendClientMessage(playerid, -1, "USAGE:/editgate speed <speed>");
		GInfo[i][Speed] = speed;
		dini_FloatSet(file, "Speed", speed);
		SendClientMessage(playerid, -1, "Gate's speed changed.");
	}
	if(!strcmp(params, "password", true, 8))
	{
		new i;
		if(HowManyGatesNearPlayer(playerid) == 0) return SendClientMessage(playerid, -1, "You arn't near any gate");
		i = WhichGateIsNearPlayer(playerid);
		format(file, sizeof(file), GATE_PATH, i);
		new pas[256];
		if(sscanf(params, "s[128]s[256]", params, pas)) return SendClientMessage(playerid, -1, "USAGE:/editgate password <password>");
		GInfo[i][Password] = pas;
		dini_Set(file, "Password", pas);
		SendClientMessage(playerid, -1, "Gate's password changed");
	}
	if(!strcmp(params, "autogate", true, 8))
	{
		new i;
		if(HowManyGatesNearPlayer(playerid) == 0) return SendClientMessage(playerid, -1, "You arn't near any gate");
		i = WhichGateIsNearPlayer(playerid);
		format(file, sizeof(file), GATE_PATH, i);
		new option;
		if(sscanf(params, "s[128]i", params, option)) return SendClientMessage(playerid, -1, "USAGE:/editgate autogate <1=ON || 0= OFF>");
		if(!strcmp(GInfo[i][Password], "None", true, 4))
		{
			GInfo[i][Autogate] = option;
			dini_IntSet(file, "Autogate", option);
			SendClientMessage(playerid, -1, "Gate's autogate has been changed.");
		}else{
			return SendClientMessage(playerid, -1, "You can't set autogate for a gate that have password.");
		}
	}
	if(!strcmp(params, "open", true, 4))
	{
		SelectObject(playerid);
		open[playerid] = true;
		close[playerid] = false;
	}
	if(!strcmp(params, "close", true, 5))
	{
		SelectObject(playerid);
		open[playerid] = false;
		close[playerid] = true;
	}

	return 1;
}
CMD:gotogate(playerid, params[])
{
	new gateid;
	if(sscanf(params, "i", gateid)) return SendClientMessage(playerid, -1, "USAGE:/gotogate <gate_id>");
	new file[256];
	format(file, sizeof(file), GATE_PATH, gateid);
	if(GInfo[gateid][Created] == 1 && fexist(file))
	{
		SetPlayerPos(playerid, dini_Float(file, "CX")+1, dini_Float(file, "CY")+1, dini_Float(file, "CZ")+1);
		SendClientMessage(playerid, -1, "You have been teleported to your choosen gate location.");
	}else{
		SendClientMessage(playerid, -1, "Gate not found.");
	}
	return 1;
}
CMD:nearestgate(playerid)
{
	new str[180], id = WhichGateIsNearPlayer(playerid);
	if(id == 0) return SendClientMessage(playerid, -1, "No gates near you");
	format(str, sizeof(str), "Gate's id that is near you: %i", id);
	SendClientMessage(playerid, -1, str);
	return true;
}
CreateGate(password[256], Float:x, Float:y, Float:z, Float:a, Auto, Float:speed)
{
	new file[256];
	for(new i = 1, j = MAX_GATES; i<=j; i++)
	{
		format(file, sizeof(file), GATE_PATH, i);
		if(GInfo[i][Created] == 0)
		{
			new objectid;
			objectid = CreateObject( GATE_OBJECT, x, y, z+1.5, 0, 0, a );
			dini_Create(file);
			dini_Set(file, "Password", password);
			dini_FloatSet(file, "OX", x);
			dini_FloatSet(file, "OY", y);
			dini_FloatSet(file, "OZ", z);

			dini_FloatSet(file, "CX", x);
			dini_FloatSet(file, "CY", y);
			dini_FloatSet(file, "CZ", z);
			
			dini_FloatSet(file, "ROX", 0.0);
			dini_FloatSet(file, "ROY", 0.0);
			dini_FloatSet(file, "ROZ", 0.0);

			dini_FloatSet(file, "RCX", 0.0);
			dini_FloatSet(file, "RCY", 0.0);
			dini_FloatSet(file, "RCZ", 0.0);	

			dini_IntSet(file, "Autogate", Auto);
			dini_FloatSet(file, "Speed", speed);
			GInfo[i][Created] = 1;
			GInfo[i][Status] = CLOSED;
			GInfo[i][ox] = x;
			GInfo[i][oy] = y;
			GInfo[i][oz] = z;

			GInfo[i][cx] = x;
			GInfo[i][cy] = y;
			GInfo[i][cz] = z;

			GInfo[i][rcx] = x;
			GInfo[i][rcy] = z;
			GInfo[i][rcz] = y;

			GInfo[i][rox] = x;
			GInfo[i][roy] = y;
			GInfo[i][roz] = z;
		
			GInfo[i][Autogate] = Auto;
			GInfo[i][Object] = objectid;
			GInfo[i][Password] = password;
			GInfo[i][Speed] = speed;
			break;
		}
	}
	return 1;	
}
OpenOrCloseGate(i)
{
	if(GInfo[i][Status] == CLOSED)
	{
		MoveObject( GInfo[i][Object], GInfo[i][ox], GInfo[i][oy], GInfo[i][oz], GInfo[i][Speed], GInfo[i][rox], GInfo[i][roy], GInfo[i][roz]);
		GInfo[i][Status] = OPENED;
		return 1;
	}
	if(GInfo[i][Status] == OPENED)
	{
			MoveObject( GInfo[i][Object], GInfo[i][cx], GInfo[i][cy], GInfo[i][cz], GInfo[i][Speed], GInfo[i][rcx], GInfo[i][rcy], GInfo[i][rcz]);
			GInfo[i][Status] = CLOSED;
			return 1;
	}
	return 1;
}
WhichGateIsNearPlayer(playerid)
{
	new gate = 0;
	for(new i = 0; i!=MAX_GATES; i++)
	{
		if(GInfo[i][Created] == 1)
		{
			new file[256];
			format(file, sizeof(file), GATE_PATH, i);
			if(fexist(file))
			{
				if(IsPlayerInRangeOfPoint(playerid, 4.0, dini_Float(file, "CX"), dini_Float(file, "CY"), dini_Float(file, "CZ")))
				{
					gate = i;
					break;
				}
			}
		}
	}
	return gate;
}
WhichGateIsNearPlayerForHorn(playerid)
{
	new gate = 0;
	for(new i = 0; i!=MAX_GATES; i++)
	{
		if(GInfo[i][Created] == 1)
		{
			new file[256];
			format(file, sizeof(file), GATE_PATH, i);
			if(fexist(file))
			{
				if(IsPlayerInRangeOfPoint(playerid, 7.0, dini_Float(file, "CX"), dini_Float(file, "CY"), dini_Float(file, "CZ")))
				{
					gate = i;
					break;
				}
			}
		}
	}
	return gate;
}
HowManyGatesNearPlayer(playerid)
{
	new gatesnear = 0;
	for(new i = 0; i!=MAX_GATES; i++)
	{
		if(GInfo[i][Created] == 1)
		{
			new file[256];
			format(file, sizeof(file), GATE_PATH, i);
			if(fexist(file))
			{
				if(IsPlayerInRangeOfPoint(playerid, 4.0, dini_Float(file, "CX"), dini_Float(file, "CY"), dini_Float(file, "CZ")))
				{
					gatesnear++;
				}
			}
		}
	}
	return gatesnear;
}

public OnPlayerEditObject(playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ )
{
	objectid = idob[playerid];
	new Float:pos[3], Float:rpos[3];
	GetObjectPos(objectid, pos[0], pos[1], pos[2]);
	GetObjectRot(objectid, rpos[0], rpos[1], rpos[2]);
	if(response == EDIT_RESPONSE_FINAL)
	{
		SetObjectPos(objectid, Float:fX, Float:fY, Float:fZ);
		SetObjectRot(objectid, Float:fRotX, Float:fRotY, Float:fRotZ);
		if(open[playerid] == true)
		{
			new file[256];
			format(file, sizeof(file), GATE_PATH, objectid);
			GInfo[objectid][ox] = fX;
			GInfo[objectid][oy] = fY;
			GInfo[objectid][oz] = fZ;

			GInfo[objectid][rox] = fRotX;
			GInfo[objectid][roy] = fRotY;
			GInfo[objectid][roz] = fRotZ;

			dini_FloatSet(file, "ROX", fRotX);
			dini_FloatSet(file, "ROY", fRotY);
			dini_FloatSet(file, "ROZ", fRotZ);	

			dini_FloatSet(file, "OX", fX);
			dini_FloatSet(file, "OY", fY);
			dini_FloatSet(file, "OZ", fZ); 
			GInfo[objectid][Status] = OPENED;
			open[playerid] = false;
			SendClientMessage(playerid, -1, "You have changed gate's open position");
		}
		if(close[playerid] == true)
		{
			new file[256];
			format(file, sizeof(file), GATE_PATH, objectid);
			GInfo[objectid][cx] = fX;
			GInfo[objectid][cy] = fY;
			GInfo[objectid][cz] = fZ;

			GInfo[objectid][rcx] = fRotX;
			GInfo[objectid][rcy] = fRotY;
			GInfo[objectid][rcz] = fRotZ;

			dini_FloatSet(file, "RCX", fRotX);
			dini_FloatSet(file, "RCY", fRotY);
			dini_FloatSet(file, "RCZ", fRotZ);	

			dini_FloatSet(file, "CX", fX);
			dini_FloatSet(file, "CY", fY);
			dini_FloatSet(file, "CZ", fZ);
			GInfo[objectid][Status] = CLOSED;
			close[playerid] = false;
			SendClientMessage(playerid, -1, "You have changed gate's close position");
		}
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
		SetObjectPos(objectid, pos[0], pos[1], pos[2]);
		SetObjectRot(objectid, rpos[0], rpos[1], rpos[2]);
	}
	return 1;
}
public OnPlayerSelectObject(playerid, type, objectid, modelid, Float:fX, Float:fY, Float:fZ)
{
	if(open[playerid] == true || close[playerid] == true)
	{
		EditObject(playerid, objectid);
		idob[playerid] = objectid;
	}
	if(remove[playerid] == true)
	{
		new file[256], i;
		i = WhichGateIsNearPlayer(playerid);
		format(file, sizeof(file), GATE_PATH, i);
		if(fexist(file))
		{
				DestroyObject(GInfo[i][Object]);
				dini_Remove(file);
				GInfo[i][Created] = 0;
			    GInfo[i][ox] = 0.0;
			    GInfo[i][oy] = 0.0;
			    GInfo[i][oz] = 0.0;
			   
			    GInfo[i][cx] = 0.0;
			    GInfo[i][cy] = 0.0;
			    GInfo[i][cz] = 0.0;

			    GInfo[i][rcx] = 0.0;
				GInfo[i][rcy] = 0.0;
				GInfo[i][rcz] = 0.0;

				GInfo[i][rox] = 0.0;
				GInfo[i][roy] = 0.0;
				GInfo[i][roz] = 0.0;

			    GInfo[i][Password] = 0;
			    GInfo[i][Status] = CLOSED;

			    remove[playerid] = false;
			    SendClientMessage(playerid, -1, "You have removed the gate.");
		}
	}
	
	return 1;
}
