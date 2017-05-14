

Alright so here is the virtual garage.

ALL CREDITS go to the original authors.

GZA David for the Virtual Garage script

Torndeco for the EXT Database

All i did was change a few variables to update it for 1.0.6.1

I use the script a little different than intended.

The only difference, i use vehicle and air traders to access the virtual garage, intended for use with garages, but requires gem crafting...
The original instructions are in the download in case someone wants to do it that way. The file name is ORIGINAL_ReadMe.txt

so on with the instructions..

Tools Required

Notepad ++
PBO Tool
SQL tool such as HeidiSQL

First we start with the mission folder.

copy the scripts folder from the downloads into your mission folder.

1. Open your init.sqf

look for

dayz_randomMaxFuelAmount

add this bellow

DZE_garagist = ["Profiteer4","Worker3","RU_Profiteer4","Hooker1","Worker2"];

save and close

2. Open your description.ext

add this at the bottom

#include "scripts\garage\common.hpp"
#include "scripts\garage\vehicle_garage.hpp"

save and close

4. Open your fn_selfactions.sqf

look for

//Player Deaths

add this above

//Garage
		
   	if((_typeOfCursorTarget in DZE_garagist) && (player distance _cursorTarget < 5)) then {
		if (s_garage_dialog2 < 0) then {
			s_garage_dialog2 = player addAction ["Vehicle Garage", "scripts\garage\vehicle_dialog.sqf",_cursorTarget, 3, true, true, "", ""];
		};
		if (s_garage_dialog < 0) then {
			s_garage_dialog = player addAction ["Store Vehicle in Garage", "scripts\garage\vehicle_store_list.sqf",_cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_garage_dialog2;
		s_garage_dialog2 = -1;
		player removeAction s_garage_dialog;
		s_garage_dialog = -1;
	};

still in the fn_selfactions.sqf

look for

player removeAction s_player_fuelauto2;
	s_player_fuelauto2 = -1;
	player removeAction s_player_manageDoor;
	s_player_manageDoor = -1;

add this bellow

player removeAction s_garage_dialog2;
	s_garage_dialog2 = -1;
	player removeAction s_garage_dialog;
	s_garage_dialog = -1;

save and close.

5. Open your variables.sqf

look for dayz_resetSelfActions = {

add this before the closing bracket     };

s_garage_dialog = -1;
s_garage_dialog2 = -1;

save and close

 

6. Open your compiles.sqf

look for

fn_dropItem = compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\fn_dropItem.sqf";

add this above

player_getVehicle = 			compile preprocessFileLineNumbers "scripts\garage\getvehicle.sqf";
	player_storeVehicle = 			compile preprocessFileLineNumbers "scripts\garage\player_storeVehicle.sqf";
	vehicle_info = compile preprocessFileLineNumbers "scripts\garage\vehicle_info.sqf";

Still in the compiles, add this at the bottom

SC_fnc_removeCoins=
{
	private ["_player","_amount","_wealth","_newwealth", "_result"];
	_player = _this select 0;
	_amount = _this select 1;
	_result = false;
	_wealth = _player getVariable[Z_MoneyVariable,0];  
	if(_amount > 0)then{
	if (_wealth < _amount) then {
	_result = false;
	} else {                         
	_newwealth = _wealth - _amount;
	_player setVariable[Z_MoneyVariable,_newwealth, true];
	_player setVariable ["moneychanged",1,true];    
	_result = true;
	call player_forceSave;        
	};
	}else{
	_result = true;
	};
	_result
};

SC_fnc_addCoins = 
{
	private ["_player","_amount","_wealth","_newwealth", "_result"];			
	_player =  _this select  0;
	_amount =  _this select  1;
	_result = false;	
	_wealth = _player getVariable[Z_MoneyVariable,0];
	_player setVariable[Z_MoneyVariable,_wealth + _amount, true];
	call player_forceSave;
	_player setVariable ["moneychanged",1,true];					
	_newwealth = _player getVariable[Z_MoneyVariable,0];		
	if (_newwealth >= _wealth) then { _result = true; };			
	_result
};

vehicle_gear_count = {
		private["_counter"];
		_counter = 0;
		{
			_counter = _counter + _x;
		} count _this;
		_counter
	};

save and close

7A. Open your publicEH.sqf

If you don't have a custom publicEH.sqf already, go to step 7B

look for

if (dayz_groupSystem) then {
		"PVDZ_Server_UpdateGroup" addPublicVariableEventHandler {(_this select 1) spawn server_updateGroup};
	};

add this bellow

"PVDZE_queryGarageVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_queryGarageVehicle};
    "PVDZE_spawnVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_spawnVehicle};
    "PVDZE_storeVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_storeVehicle};

7B. Only do this step if you DON'T have a custom publicEH.sqf

Open your init.sqf again

look for

call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\publicEH.sqf";

replace it with this

call compile preprocessFileLineNumbers "scripts\garage\publicEH.sqf";

Thats it for the mission file

 

Now for the server 

Copy the garage folder from the download, into the compiles folder in your dayz_server folder

1. Open your server_functions.sqf

look for this

spawn_vehicles = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_vehicles.sqf";

add this bellow

"extDB" callExtension "9:DATABASE:Database2";
"extDB" callExtension format["9:ADD:DB_RAW_V2:%1",1];
"extDB" callExtension "9:LOCK";

server_queryGarageVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_queryGarageVehicle.sqf";
server_spawnVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_spawnVehicle.sqf";
server_storeVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_storeVehicle.sqf";
fn_asyncCall = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\fn_async.sqf";

Save and close

Thats it for the server PBO

 

 

BattlEye

Add to publicvariable.txt:

!="PVDZE_queryGarageVehicle" !="PVDZE_storeVehicle" !="PVDZE_spawnVehicle" 

 

Infistar

Infistar: 
Add to _ALLOWED_Dialogs:

2800,3800

 

Now for the database

Using heidi (or your favorite sql tool)

Open SQL.txt and copy everything in there and run a query on your database.

This will create a database called extdb

Copy the @extdb folder to the root of your server.

In your server launch BAT. add @extdb; before @dayz_epoch_server

Open the @extdb folder, edit the extdb-conf.ini and change the username and password to suit your needs.

(you might need to give all permissions for that user for the new database in heidi)

 

All done.  Log in and go visit your vehicle traders!

Cheers Enjoy!

 

EDIT: updated the instructions for the fix of ANY/gear and it not taking coins. Please refer to step 6
EDIT 22/03/2017 : Added a fix for client RPT error (Step 5) Also changed the variable for the currency

