// Developed by [GZA] David for German Zombie Apocalypse Servers (https://zombieapo.eu/)
private["_unit","_obj","_wogear","_charID","_objectID","_keyavailable","_keyColor","_added","_objectUID","_key"];
if(lbCurSel 3802 == -1) exitWith {hint  "No Vehicle selected"};
_unit = player;
_obj = StoreVehicleList select (lbCurSel 3802);
StoreVehicleList = nil;
_wogear = _this select 0;
closeDialog 0;



_charID	= _obj getVariable ["CharacterID","0"];
_objectID = _obj getVariable ["ObjectID","0"];
_objectUID	= _obj getVariable ["ObjectUID","0"];

if (_objectID == "1") exitWith {cutText ["Can not store mission vehicle.", "PLAIN DOWN"];}; // Check for mission vehicle WAI Script




_keyavailable = false;
_keyColor = ["ItemKeyYellow","ItemKeyBlue","ItemKeyRed","ItemKeyGreen","ItemKeyBlack"];
if(_charID != "0") then {
{
	if (configName(inheritsFrom(configFile >> "CfgWeapons" >> _x)) in _keyColor) then {
	if (str(getNumber(configFile >> "CfgWeapons" >> _x >> "keyid")) == _charID) then {
	_key = _x; _keyavailable = true;
			};
		};
} count (items _unit);


} else {_keyavailable = true;};

if (!_keyavailable) exitWith {cutText ["You need the key of the vehicle.", "PLAIN DOWN"];};

_added = false;
if (!_wogear) then {
_added = [player, Pricegear] call SC_fnc_removeCoins;
} else {_added = true;};
Pricegear = nil;

if(!_added) exitWith {cutText ["You don't have enough money.", "PLAIN DOWN"];};
if(_charID != "0") then {
[_unit,_key] call BIS_fnc_invRemove; cutText ["Key removed!", "PLAIN DOWN"];
};

_obj setvehiclelock "locked";


PVDZE_storeVehicle = [_obj, _unit, _wogear];
publicVariableServer "PVDZE_storeVehicle";
waitUntil {!isNil "PVDZE_storeVehicleResult"};

PVDZ_obj_Destroy = [_objectID,_objectUID,_unit];
publicVariableServer "PVDZ_obj_Destroy";

deleteVehicle _obj;

PVDZE_storeVehicleResult = nil;
sleep 2;
cutText ["Stored Vehicle in Garage.", "PLAIN DOWN"];
