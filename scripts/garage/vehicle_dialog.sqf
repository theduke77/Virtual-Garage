// Developed by [GZA] David for German Zombie Apocalypse Servers (https://zombieapo.eu/)
private["_vehicles","_control","_displayName","_tmp"];
createDialog "vehicle_garage";
disableSerialization;
PVDZE_queryGarageVehicle = [player];
publicVariableServer "PVDZE_queryGarageVehicle";
waitUntil {!isNil "PVDZE_queryGarageVehicleResult"};

ctrlShow[2803,false];
ctrlShow[2830,false];
waitUntil {!isNull (findDisplay 2800)};

_vehicles = PVDZE_queryGarageVehicleResult;
PVDZE_queryGarageVehicleResult = nil;

if(count _vehicles == 0) exitWith
{
	ctrlSetText[2811,"No Vehicle"];

};

_control = ((findDisplay 2800) displayCtrl 2802);
lbClear _control;


{
	_displayName = getText(configFile >> "CfgVehicles" >> (_x select 1) >> "displayName");
	_control lbAdd _displayName;
	_tmp = str(_x);
	_control lbSetData [(lbSize _control)-1,_tmp];
} count _vehicles;

ctrlShow[2810,false];
ctrlShow[2811,false];
