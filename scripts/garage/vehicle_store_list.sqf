// Developed by [GZA] David for German Zombie Apocalypse Servers (https://zombieapo.eu/)
private["_obj","_control","_displayName","_class"];
createDialog "vehicle_store_list";
disableSerialization;
_obj = player nearEntities [[ "Armored","Car", "Motorcycle", "Air","Tank"], 50];
waitUntil {!isNil "_obj"};

ctrlShow[3803,false];
ctrlShow[3830,false];
waitUntil {!isNull (findDisplay 3800)};


if(count _obj == 0) exitWith
{
	ctrlSetText[3811,"No Vehicles"];

};

_control = ((findDisplay 3800) displayCtrl 3802);
lbClear _control;

StoreVehicleList = [];
{
	if(local _x and !isNull _x and alive _x) then {
	_class = typeOf _x;
	_displayName = getText(configFile >> "CfgVehicles" >> _class >> "displayName");
	_control lbAdd _displayName;
	_control lbSetData [(lbSize _control)-1,_class];
	StoreVehicleList set [count StoreVehicleList,_x] //Annoying Workaround can not use lbSetData with objects
	};
} count _obj;

ctrlShow[3810,false];
ctrlShow[3811,false];

