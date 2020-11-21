#include <a_samp>
#include <ZCMD>

new clearshock[MAX_PLAYERS];
new knocked[MAX_PLAYERS];
new bleeding[MAX_PLAYERS];
CMD:cure(playerid, params[])
{
    if (IsPlayerInRangeOfPoint(playerid, 7.0, -325.4840,1063.5975,19.7990))
    {
        SendClientMessage(playerid, -1,"You are not near the hospital!");
    }
    if (GetPlayerMoney(playerid) >= 500)
    {
        SendClientMessage(playerid, -1,"You can't afford the cure, it costs $500.");
    }
    SetTimerEx("bandage", 3000, false, "i", playerid);
    SendClientMessage(playerid, -1, "Curing, please wait!");
    GivePlayerMoney(playerid, -500);
    return 1;
}
forward bandage(playerid);
public bandage(playerid)
{
    KillTimer(bleeding[playerid]);
    SendClientMessage(playerid, -1, "You are no longer bleeding");
    return 1;
}
forward Knocked(playerid);
public Knocked(playerid)
{
    SendClientMessage(playerid, -1, "You are able to move now");
    TogglePlayerControllable(playerid, 1);
    KillTimer(knocked[playerid]);
    return 1;
}
forward ClearShock(playerid);
public ClearShock(playerid)
{
    SetPlayerDrunkLevel(playerid, 1);
    KillTimer(clearshock[playerid]);
    return 1;
}
forward Bleeding(playerid, Float:amount);
public Bleeding(playerid, Float:amount)
{
    SendClientMessage(playerid, -1, "You are bleeding, please cure at the hospital or you might die soon");
    SetTimerEx("Bleeding", 10000, false, "i", playerid);
    return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
    new Float:HP;
    new Float:Armor;
    GetPlayerHealth(playerid, HP);
    GetPlayerArmour(playerid, Armor);
    if(Armor < 1)
    {
        if(weaponid == 31 || weaponid == 30)
        {
            // SendClientMessage(playerid, -1, " You have been shot by assault machine.");
            // SetPlayerHealth(playerid, HP-15);
            new hitrand = random(10);
            if(hitrand <= 3)
            {
                SendClientMessage(playerid, -1, " You have been shot by assault machine multiple times and you are now injured.");
                ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,0,0,0,0);
                SetTimerEx("Knocked", 30000, false, "i", playerid);
                TogglePlayerControllable(playerid, 0);
                SetPlayerDrunkLevel(playerid, 8000);
                SetTimerEx("ClearShock", 10000, false, "i", playerid);
                SetTimerEx("Bleeding", 10000, false, "i", playerid);
            }
            SetPlayerHealth(playerid, HP-(amount*3));
            SendClientMessage(playerid, -1, "You were shot by assault machine and you are now bleeding.");
            SetPlayerDrunkLevel(playerid, 8000);
            SetTimerEx("ClearShock", 30000, false, "i", playerid);
            SetTimerEx("Bleeding", 10000, false, "i", playerid);
        }
        else if(weaponid == 22)
        {
            new hitrand = random(10);
            if(hitrand <= 3)
            {
                SendClientMessage(playerid, -1, " You have been shot by glock.49 multiple times and you're now injured.");
                ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,0,0,0,0);
                SetTimerEx("Knocked", 30000, false, "i", playerid);
                TogglePlayerControllable(playerid, 0);
                SetPlayerDrunkLevel(playerid, 8000);
                SetTimerEx("ClearShock", 10000, false, "i", playerid);
                SetTimerEx("Bleeding", 10000, false, "i", playerid);
            }
            SetPlayerHealth(playerid, HP-20);
            SendClientMessage(playerid, -1, "You were shot by glock.49 and got shocked and you are now bleeding.");
            SetTimerEx("Bleeding", 10000, false, "i", playerid);
            SetPlayerDrunkLevel(playerid, 8000);
            SetTimerEx("ClearShock", 20000, false, "i", playerid);
            SetTimerEx("Bleeding", 10000, false, "i", playerid);
        }
        else if(weaponid == 24)
        {
            new hitrand = random(10);
            if(hitrand <= 3)
            {
                SendClientMessage(playerid, -1, " You have been shot by Desert Eagle multiple times and you're now injured.");
                ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,0,0,0,0);
                SetTimerEx("Knocked", 30000, false, "i", playerid);
                TogglePlayerControllable(playerid, 0);
                SetPlayerDrunkLevel(playerid, 8000);
                SetTimerEx("ClearShock", 10000, false, "i", playerid);
                SetTimerEx("Bleeding", 10000, false, "i", playerid);
            }
            SetPlayerHealth(playerid, HP-35);
            SendClientMessage(playerid, -1, "You were shot by a Desert Eagle, and you're now bleeding heavily.");
            SetPlayerDrunkLevel(playerid, 8000);
            SetTimerEx("ClearShock", 30000, false, "i", playerid);
            SetTimerEx("Bleeding", 10000, false, "i", playerid);
        }
        else if(weaponid == 25 || weaponid == 29 || weaponid == 28 || weaponid == 27)
        {
            new hitrand = random(10);
            if(hitrand <= 2)
            {
                SendClientMessage(playerid, -1, " You were shot two by a strong gun machine and you're not injured.");
                ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,0,0,0,0);
                SetTimerEx("Knocked", 60000, false, "i", playerid);
                TogglePlayerControllable(playerid, 0);
                SetPlayerDrunkLevel(playerid, 8000);
                SetTimerEx("ClearShock", 10000, false, "i", playerid);
                SetTimerEx("Bleeding", 10000, false, "i", playerid);
            }
            SetPlayerHealth(playerid, HP-45);
            SendClientMessage(playerid, -1, "You were shot heavily by a strong weapon, and you're now bleeding.");
            SetPlayerDrunkLevel(playerid, 8000);
            SetTimerEx("ClearShock", 30000, false, "i", playerid);
            SetTimerEx("Bleeding", 10000, false, "i", playerid);
        }
        else if(weaponid == 34)
        {
            SetPlayerHealth(playerid, HP-100);
            SendClientMessage(playerid, -1, "You were shot by a sniper rifle.");
            //SetPlayerDrunkLevel(playerid, 8000);
            //SetTimerEx("ClearShock", 100000, false, "i", playerid);
        }
        else if(weaponid == 8)
        {
            SetPlayerHealth(playerid, HP-40);
            SendClientMessage(playerid, -1, "You have been knocked to the floor by a melee gun.");
            ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,0,0,0,0);
            SetTimerEx("Knocked", 10000, false, "i", playerid);
            TogglePlayerControllable(playerid, 0);
            SetPlayerDrunkLevel(playerid, 8000);
            SetTimerEx("ClearShock", 10000, false, "i", playerid);
            SetTimerEx("Bleeding", 10000, false, "i", playerid);
        }
        else if(weaponid == 5)
        {
            SetPlayerHealth(playerid, HP-40);
            new hitrand = random(10);
            if(hitrand <= 1)
            {
                SendClientMessage(playerid, -1, " You have been knocked to the floor by a baseball bat.");
                ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,0,0,0,0);
                SetTimerEx("Knocked", 10000, false, "i", playerid);
                TogglePlayerControllable(playerid, 0);
                SetPlayerDrunkLevel(playerid, 8000);
                SetTimerEx("ClearShock", 10000, false, "i", playerid);
                // SetTimerEx("Bleeding", 10000, false, "i", playerid);
            }
        }
        else if(weaponid == 3)
        {
            SetPlayerHealth(playerid, HP-40);
            new hitrand = random(10);
            if(hitrand <= 1)
            {
                SendClientMessage(playerid, -1, " You have been knocked to the floor by an ASP Baton and you are bleeding now.");
                ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,0,0,0,0);
                SetTimerEx("Knocked", 10000, false, "i", playerid);
                TogglePlayerControllable(playerid, 0);
                SetPlayerDrunkLevel(playerid, 8000);
                SetTimerEx("ClearShock", 10000, false, "i", playerid);
                SetTimerEx("Bleeding", 10000, false, "i", playerid);
            }
        }
        else if(weaponid == 15 || weaponid == 4 || weaponid == 2 || weaponid == 6 || weaponid == 7)
        {
            SetPlayerHealth(playerid, HP-30);
            SendClientMessage(playerid, -1, "You have been knocked to the floor by a melee gun.");
            ApplyAnimation(playerid,"PED","KO_skid_front",4.1,0,0,0,0,0);
            SetTimerEx("Knocked", 5000, false, "i", playerid);
            TogglePlayerControllable(playerid, 0);
            // SetPlayerDrunkLevel(playerid, 8000);
            // SetTimerEx("ClearShock", 100000, false, "i", playerid);
        }
    }
    return 1;
}
