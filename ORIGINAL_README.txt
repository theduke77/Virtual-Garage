Virtual Garage developed by [GZA] David for German Zombie Apocalypse Servers (https://zombieapo.eu/)
Please pm/ask me if you modify the code and want to release it!


I will not give any support for this script. It is not finished and there could be bugs. Probably i will not continue working on the script. 
NOTE: You need extDB as DB connector. (https://github.com/Torndeco/extdb) Store Vehicle with Gear is using Zupas Single Currency to remove money. 
      Script is compatible with Paint Vehicles.



This are only some basic install instructions (Only try if you know what your are doing) :



1. Add to your init.sqf:

DZE_Garage = ["Land_MBG_Garage_Single_D","Land_MBG_Garage_Single_A","Land_MBG_Garage_Single_B","Land_MBG_Garage_Single_C"];

2. Add to the bottom of description.ext:

#include "scripts\garage\common.hpp"
#include "scripts\garage\vehicle_garage.hpp"

NOTE: If you are using Zupas Single Currency you have to add the missing classes in the common.hpp manually.

3. Add to your fn_selfActions:

    //Garage
   	if(_typeOfCursorTarget in DZE_Garage && (player distance _cursorTarget < 5)) then {
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

	above:

	//Packing my tent


3.1	And in the same  file search for:

	player removeAction s_player_fuelauto;
	s_player_fuelauto = -1;
	player removeAction s_player_fuelauto2;
	s_player_fuelauto2 = -1;

	add below:

	//Garage
	player removeAction s_garage_dialog2;
	s_garage_dialog2 = -1;
	player removeAction s_garage_dialog;
	s_garage_dialog = -1;


4. Add to your compiles.sqf:

//Garage
	player_getVehicle = 			compile preprocessFileLineNumbers "scripts\garage\getvehicle.sqf";
	player_storeVehicle = 			compile preprocessFileLineNumbers "scripts\garage\player_storeVehicle.sqf";
	vehicle_info = compile preprocessFileLineNumbers "scripts\garage\vehicle_info.sqf";

5. Add to your publicEH.sqf below if (isServer) then { :

	"PVDZE_queryGarageVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_queryGarageVehicle};
	"PVDZE_spawnVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_spawnVehicle};
	"PVDZE_storeVehicle" addPublicVariableEventHandler {(_this select 1) spawn server_storeVehicle};

Next steps in dayz_server:

6. Add to your server_functions.sqf:

//DB
"extDB" callExtension "9:DATABASE:Database2";
"extDB" callExtension format["9:ADD:DB_RAW_V2:%1",1];
"extDB" callExtension "9:LOCK";

7. Also add to your server_functions.sqf:

server_queryGarageVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_queryGarageVehicle.sqf";
server_spawnVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_spawnVehicle.sqf";
server_storeVehicle = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\server_storeVehicle.sqf";
fn_asyncCall = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\garage\fn_async.sqf";


Battleye:
Add to publicvariable.txt:

!="PVDZE_queryGarageVehicle" !="PVDZE_storeVehicle" !="PVDZE_spawnVehicle" 


Infistar: 
Add to _ALLOWED_Dialogs:

2800,3800

Last Step:

Open SQL.txt and use the SQL Command to insert the garage table in your DB.



To allow players to build garages and helipads you could use Alchemical Crafting.

That's it. I hope i didn't forget anything:) 


