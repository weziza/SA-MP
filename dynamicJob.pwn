/*

	• Dynamic creating jobs by Shomy v0.2
	• Commands /createjob /createvehicle /deletejob and /deletecar
	• Required files in scriptfiles - "Jobs" and "VehicleForJobs"
	
	• Recoded now its work on your newest server, weziza. Need help just go on my dc weziza#0006

*/

#include < a_samp >
#include < YSI\y_ini >
#include < YSI\y_commands >
#include < sscanf2 >

#define JOBS_FILE       "/Jobs/%d.ini"
#define JOBVEH_FILE     "/VehiclesForJobs/%d.ini"
#define MAX_JOBS        50
#define MAX_JOBVEH      300
#undef MAX_PLAYERS
#define MAX_PLAYERS     50

#define COL_Job       "{FF1414}"
#define COL_BELA        "{FFFFFF}"

#define SCM             SendClientMessage
#define SPD             ShowPlayerDialog

#define DIALOG_JOB      1

enum jInfo {

	Float:PosX,
	Float:PosY,
	Float:PosZ,
	Float:uPosX,
	Float:uPosY,
	Float:uPosZ,
	jName[ 40 ],
	Pay,
	uSkin,
	jID
}
enum vInfo {

	Float:vPosX,
	Float:vPosY,
	Float:vPosZ,
	Float:vRotA,
	Color1,
	Color2,
	vModel,
	forJob
}

new JobInfo[ MAX_JOBS ][ jInfo ], JobPickup[ sizeof(JobInfo) ], Text3D:JobLabel[ sizeof(JobInfo) ],
	JobVehInfo[ MAX_JOBVEH ][ vInfo ], VehC[ sizeof(JobVehInfo) ], Text3D:VehLabel[ sizeof(JobVehInfo) ], UniformaPickup[ sizeof(JobInfo) ], Text3D:UniformaLabel[ sizeof(JobInfo) ];
new Job[ MAX_PLAYERS ], TookUniform[ MAX_PLAYERS ], CreatingJob[ MAX_PLAYERS ];

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {

	if(dialogid == DIALOG_JOB) {
		if(response) {
			for(new i; i < MAX_JOBS; i++) {
			    if(IsPlayerInRangeOfPoint(playerid, 6.0, JobInfo[ i ][ PosX ], JobInfo[ i ][ PosY ], JobInfo[ i ][ PosZ ])) {
					if(Job[ playerid ] != 0) return SCM(playerid, -1, "You aleardy have a job !");
		    		new str[ 70 ];
		    		format(str, sizeof(str), "Congratulations ! You've earned a job as a "COL_Job"%s.", JobInfo[ i ][ jName ]);
		    		SCM(playerid, -1, str);
		    		Job[ playerid ] = JobInfo[ i ][ jID ];
				}
		    }
		}
	}
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid) {

	for(new i; i < MAX_JOBS; i++) {
		if(pickupid == JobPickup[ i ]) {
		    if(IsPlayerInRangeOfPoint(playerid, 6.0, JobInfo[ i ][ PosX ], JobInfo[ i ][ PosY ], JobInfo[ i ][ PosZ ])) {
		        if(CreatingJob[ playerid ] == 0) {
					new str[ 65 ];
					format(str, sizeof(str), ""COL_Job"%s "COL_BELA"\nContract - 3h\nPay - %d$", JobInfo[ i ][ jName ], JobInfo[ i ][ Pay ]);
					SPD(playerid, DIALOG_JOB, DIALOG_STYLE_MSGBOX, ""COL_BELA"Job", str, "Accept","Exit");
				}
			}
		}
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

	if(newkeys == KEY_YES) {
	    if(CreatingJob[ playerid ] != 0) {
	        new Float:X,Float:Y,Float:Z, i = CreatingJob[ playerid ];
	        GetPlayerPos(playerid, X,Y,Z);
	        UniformaPickup[ i ] = CreatePickup(1275, 1, X,Y,Z, -1);
	        UniformaLabel[ i ] = Create3DTextLabel("/uniform", 0x007799FF, X,Y,Z, 15.0, 0, 0);
			JobInfo[ i ][ uPosX ] = X;
			JobInfo[ i ][ uPosY ] = Y;
			JobInfo[ i ][ uPosZ ] = Z;
			SaveJob(i);
			CreatingJob[ playerid ] = 0;
			SCM(playerid, -1, "You have successfully created a job. To create a vehicle - /createvehicle");
	    }
	}
	return 1;
}
forward LoadJob(id, name[], value[]);
public LoadJob(id, name[], value[]) {

	INI_Float("X", JobInfo[ id ][ PosX ]);
	INI_Float("Y", JobInfo[ id ][ PosY ]);
	INI_Float("Z", JobInfo[ id ][ PosZ ]);
	INI_Float("uX", JobInfo[ id ][ uPosX ]);
	INI_Float("uY", JobInfo[ id ][ uPosY ]);
	INI_Float("uZ", JobInfo[ id ][ uPosZ ]);
	INI_String("Job_Name", JobInfo[ id ][ jName ], 40);
	INI_Int("Pay", JobInfo[ id ][ Pay ]);
	INI_Int("Skin", JobInfo[ id ][ uSkin ]);
	INI_Int("ID", JobInfo[ id ][ jID ]);
	return 1;
}
forward LoadVehJob(id, name[], value[]);
public LoadVehJob(id, name[], value[]) {

    INI_Float("X", JobVehInfo[ id ][ vPosX ]);
	INI_Float("Y", JobVehInfo[ id ][ vPosY ]);
	INI_Float("Z", JobVehInfo[ id ][ vPosZ ]);
	INI_Float("A", JobVehInfo[ id ][ vRotA ]);
	INI_Int("For_Job", JobVehInfo[ id ][ forJob ]);
	INI_Int("Model", JobVehInfo[ id ][ vModel ]);
	INI_Int("Color_1", JobVehInfo[ id ][ Color1 ]);
	INI_Int("Color_2", JobVehInfo[ id ][ Color2 ]);
	return 1;
}
public OnFilterScriptInit() {

	print("= Dynamic Creating Jobs =\n\n     = = = by Shomy = = =\n\n= Dynamic Creating Jobs =\n");
	for(new i; i < MAX_JOBS; i++) {
	    new jFile[ 50 ], str[ 80 ];
        format(jFile, sizeof(jFile), JOBS_FILE, i);
        if(fexist(jFile)) {
		    INI_ParseFile(jFile, "LoadJob", .bExtra = true, .extra = i);
		    JobPickup[ i ] = CreatePickup(1210, 1, JobInfo[ i ][ PosX ],JobInfo[ i ][ PosY ],JobInfo[ i ][ PosZ ], -1);
			format(str,sizeof(str), ""COL_Job"[ "COL_BELA"%s "COL_Job"]\n"COL_BELA"Contract - "COL_Job"3h", JobInfo[ i ][ jName ]);
			JobLabel[ i ] = Create3DTextLabel(str, 0xFFFFFFFF, JobInfo[ i ][ PosX ],JobInfo[ i ][ PosY ],JobInfo[ i ][ PosZ ], 15.0, 0, 0);
			UniformaPickup[ i ] = CreatePickup(1275, 1, JobInfo[ i ][ uPosX ],JobInfo[ i ][ uPosY ],JobInfo[ i ][ uPosZ ], -1);
	        UniformaLabel[ i ] = Create3DTextLabel("/uniform", 0x007799FF, JobInfo[ i ][ uPosX ],JobInfo[ i ][ uPosY ],JobInfo[ i ][ uPosZ ], 15.0, 0, 0);
		}
	}
	for(new i; i < MAX_JOBVEH; i++) {
	    new jFile[ 50 ], str[ 55 ];
        format(jFile, sizeof(jFile), JOBVEH_FILE, i);
        if(fexist(jFile)) {
            INI_ParseFile(jFile, "LoadVehJob", .bExtra = true, .extra = i);
            VehC[ i ] = CreateVehicle(JobVehInfo[ i ][ vModel ], JobVehInfo[ i ][ vPosX ],JobVehInfo[ i ][ vPosY ],JobVehInfo[ i ][ vPosZ ],JobVehInfo[ i ][ vRotA ], JobVehInfo[ i ][ Color1 ], JobVehInfo[ i ][ Color2 ], -1);
			format(str, sizeof(str), ""COL_Job"[ "COL_BELA"%s "COL_Job"]", JobInfo[ i ][ jName ]);
			VehLabel[ i ] = Create3DTextLabel(str, 0xFFFFFFFF, JobVehInfo[ i ][ vPosX ],JobVehInfo[ i ][ vPosY ],JobVehInfo[ i ][ vPosZ ], 15.0, 0, 0);
			Attach3DTextLabelToVehicle( VehLabel[ i ], VehC[ i ], 0.0, 0.0, 0.0);
		}
	}
	return 1;
}
public OnPlayerStateChange(playerid, newstate, oldstate) {
	if(newstate == PLAYER_STATE_DRIVER) { if(Job[ playerid ] != JobVehInfo[ GetPlayerVehicleID(playerid) ][ forJob ]) { SCM(playerid, -1, "You can't drive this vehicle."); RemovePlayerFromVehicle(playerid); } }
	return 1;
}
public OnPlayerConnect(playerid) {

	CreatingJob[ playerid ] = 0;
	TookUniform[ playerid ] = -1;
	return 1;
}

YCMD:uniform(playerid, params[], help) {

    for(new id; id < MAX_JOBS; id++) {
    	if(IsPlayerInRangeOfPoint(playerid, 6.0, JobInfo[ id ][ uPosX ], JobInfo[ id ][ uPosY ], JobInfo[ id ][ uPosZ ])) {
    	    if(Job[ playerid ] == JobInfo[ id ][ jID ])
			{
				if(TookUniform[ playerid ] == -1) {
					TookUniform[ playerid ] = GetPlayerSkin(playerid);
					SetPlayerSkin(playerid, JobInfo[ id ][ uSkin ]);
					SCM(playerid, -1, "You took a uniform.");
				}
				else {
				    SetPlayerSkin(playerid, TookUniform[ playerid ]);
				    TookUniform[ playerid ] = -1;
				    SCM(playerid, -1, "You took off your uniform.");
				}
			}
			else { new str[ 55 ]; format(str, sizeof(str), "You are not employed as %s.", JobInfo[ id ][ jName ]); SCM(playerid, -1, str); }
		}
	}
	return 1;
}
YCMD:createvehicle(playerid, params[], help) {

	#pragma unused help
	if(!IsPlayerAdmin(playerid)) return SCM(playerid, -1, "You aren't RCON admin.");
	new jid = NextJobVehID(MAX_JOBVEH), model, b1, b2, Float:X,Float:Y,Float:Z,Float:A, str[ 55 ], jFile[ 50 ], id;
	GetPlayerPos(playerid, X,Y,Z);
	GetPlayerFacingAngle(playerid, A);
	if(sscanf(params, "dddd", id, model, b1, b2)) return SCM(playerid, -1, "/createvehicle [ Job ID ] [ ID Vehicle ] [ Color 1 ] [ Color 2 ]");
 	format(jFile, sizeof(jFile), JOBS_FILE, id);
  	if(!fexist(jFile)) return SCM(playerid, -1, "ID of that job does not exists.");
	VehC[ jid ] = CreateVehicle(model, X, Y, Z, A, b1, b2, -1);
	format(str, sizeof(str), ""COL_Job"[ "COL_BELA"%s "COL_Job"]", JobInfo[ jid ][ jName ]);
	VehLabel[ jid ] = Create3DTextLabel(str, 0xFFFFFFFF, X,Y,Z, 15.0, 0, 0);
	Attach3DTextLabelToVehicle( VehLabel[ jid ], VehC[ jid ], 0.0, 0.0, 0.0);
	PutPlayerInVehicle(playerid, VehC[ jid ], 0);
	JobVehInfo[ jid ][ vPosX ] = X;
	JobVehInfo[ jid ][ vPosY ] = Y;
	JobVehInfo[ jid ][ vPosZ ] = Z;
	JobVehInfo[ jid ][ vRotA ] = A;
	JobVehInfo[ jid ][ forJob ] = id;
	JobVehInfo[ jid ][ vModel ] = model;
	JobVehInfo[ jid ][ Color1 ] = b1;
	JobVehInfo[ jid ][ Color2 ] = b2;
	SaveJobVeh(jid);
	SCM(playerid, -1, "You've created successfully a vehicle for job.");
	return 1;
}
YCMD:deletevehicle(playerid, params[], help) {

	#pragma unused help
	#pragma unused params
	if(!IsPlayerAdmin(playerid)) return SCM(playerid, -1, "You are not RCON admin.");
	if(!IsPlayerInAnyVehicle(playerid)) return SCM(playerid, -1, "You must be in the vehicle.");
	new vid = GetPlayerVehicleID(playerid), jFile[ 50 ];
	format(jFile, sizeof(jFile), JOBVEH_FILE, vid);
  	if(!fexist(jFile)) return SCM(playerid, -1, "That car isn't for jobs.");
  	fremove(jFile);
  	DestroyVehicle(vid);
  	Delete3DTextLabel(VehLabel[ vid ]);
  	SCM(playerid, -1, "You've successfully deleted a vehicle.");
	return 1;
}
YCMD:deletejob(playerid, params[], help) {

	new jid, jFile[ 50 ];
	if(sscanf(params, "d", jid)) return SCM(playerid, -1, "/deletejob [ ID ]");
	format(jFile, sizeof(jFile), JOBS_FILE, jid);
  	if(!fexist(jFile)) return SCM(playerid, -1, "ID of that job doesn't exists.");
	fremove(jFile);
	DestroyPickup(JobPickup[ jid ]);
	Delete3DTextLabel(JobLabel[ jid ]);
	DestroyPickup(UniformaPickup[ jid ]);
	Delete3DTextLabel(UniformaLabel[ jid ]);
	SCM(playerid, -1, "You've successfully deleted a job.");
	return 1;
}
YCMD:createjob(playerid, params[], help) {

	#pragma unused help
	if(!IsPlayerAdmin(playerid)) return SCM(playerid, -1, "You are not RCON admin.");
	if(CreatingJob[ playerid ] != 0) return SCM(playerid, -1, "You're already creating a job. Go to the position of the uniform and press Y.");
	new ime[ 40 ], Float:X, Float:Y, Float:Z, i = NextJobID(MAX_JOBS), str[ 80 ], pay, uskin;
	if(sscanf(params, "dds[40]", pay, uskin, ime)) return SCM(playerid, -1, "/createjob [ Pay ] [ Uniform Skin ] [ Name ]");
	if(uskin < 1 || uskin > 399) return SCM(playerid, -1, "Skin ID can not be less than 1 or greater than 399.");
	GetPlayerPos(playerid, X,Y,Z);
	JobPickup[ i ] = CreatePickup(1210, 1, X,Y,Z, -1);
	format(str,sizeof(str), ""COL_Job"[ "COL_BELA"%s "COL_Job"]\n"COL_BELA"Contract - "COL_Job"3h", ime);
	JobLabel[ i ] = Create3DTextLabel(str, 0xFFFFFFFF, X,Y,Z, 15.0, 0, 0);
	JobInfo[ i ][ PosX ] = X;
	JobInfo[ i ][ PosY ] = Y;
	JobInfo[ i ][ PosZ ] = Z;
	JobInfo[ i ][ jName ] = ime;
	JobInfo[ i ][ Pay ] = pay;
	JobInfo[ i ][ uSkin ] = uskin;
	JobInfo[ i ][ jID ] = i;
	CreatingJob[ playerid ] = i;
	SCM(playerid, -1, "Now go to the position of the uniform and press the Y button.");
	SaveJob(i);
	return 1;
}

stock SaveJob(id) {

	new jFile[ 60 ];
    format(jFile, sizeof(jFile), JOBS_FILE, id);
	new INI:File = INI_Open(jFile);
	INI_WriteFloat(File, "X", JobInfo[ id ][ PosX ]);
	INI_WriteFloat(File, "Y", JobInfo[ id ][ PosY ]);
	INI_WriteFloat(File, "Z", JobInfo[ id ][ PosZ ]);
	INI_WriteFloat(File, "uX", JobInfo[ id ][ uPosX ]);
	INI_WriteFloat(File, "uY", JobInfo[ id ][ uPosY ]);
	INI_WriteFloat(File, "uZ", JobInfo[ id ][ uPosZ ]);
	INI_WriteString(File, "Job_Name", JobInfo[ id ][ jName ]);
	INI_WriteInt(File, "Pay", JobInfo[ id ][ Pay ]);
	INI_WriteInt(File, "Skin", JobInfo[ id ][ uSkin ]);
	INI_WriteInt(File, "ID", JobInfo[ id ][ jID ]);
	INI_Close(File);
}
stock SaveJobVeh(id) {

    new vFile[ 60 ];
    format(vFile, sizeof(vFile), JOBVEH_FILE, id);
	new INI:File = INI_Open(vFile);
	INI_WriteFloat(File, "X", JobVehInfo[ id ][ vPosX ]);
	INI_WriteFloat(File, "Y", JobVehInfo[ id ][ vPosY ]);
	INI_WriteFloat(File, "Z", JobVehInfo[ id ][ vPosZ ]);
	INI_WriteFloat(File, "A", JobVehInfo[ id ][ vRotA ]);
	INI_WriteInt(File, "For_Job", JobVehInfo[ id ][ forJob ]);
	INI_WriteInt(File, "Model", JobVehInfo[ id ][ vModel ]);
	INI_WriteInt(File, "Color_1", JobVehInfo[ id ][ Color1 ]);
	INI_WriteInt(File, "Color_2", JobVehInfo[ id ][ Color2 ]);
	INI_Close(File);
}
// Not my stocks
stock NextJobID(const len) {
    new id = (-1);
    for( new loop = ( 0 ), provjera = ( -1 ), Data_[ 64 ] = "\0"; loop != len; ++ loop ) {
       provjera = ( loop+1 );
       format( Data_, ( sizeof Data_ ), JOBS_FILE, provjera );
       if(!fexist(Data_)) {
          id = ( provjera );
          break; } }
  	return ( id );
}
stock NextJobVehID(const len) {
    new id = (-1);
    for( new loop = ( 0 ), provjera = ( -1 ), Data_[ 64 ] = "\0"; loop != len; ++ loop ) {
       provjera = ( loop+1 );
       format( Data_, ( sizeof Data_ ), JOBVEH_FILE, provjera );
       if(!fexist(Data_)) {
          id = ( provjera );
          break; } }
  	return ( id );
}
