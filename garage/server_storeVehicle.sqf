private ["_object","_player","_clientID","_playerUID","_class","_charID","_damage","_fuel","_hit","_inventory","_query","_pipe","_array","_hit","_selection","_colour","_colour2"];
_object =		_this select 0;
_player =		_this select 1;
_wogear = _this select 2;
_clientID = owner _player;
_playerUID = getPlayerUID _player;

_class = typeOf _object;
_charID = _object getVariable ["CharacterID","0"];
_damage = damage _object;
_fuel = fuel _object;
_colour = _object getVariable ["Colour","0"];
_colour2 = _object getVariable ["Colour2","0"];

if (isNil "_colour") then {
		_colour = "0";
		};


if (isNil "_colour2") then {
		_colour2 = "0";
		};

_hitpoints = _object call vehicle_getHitpoints;
		_array = [];
		{
			_hit = [_object,_x] call object_getHit;
			_selection = getText (configFile >> "CfgVehicles" >> (typeOf _object) >> "HitPoints" >> _x >> "name");
			if (_hit > 0) then {_array set [count _array,[_selection,_hit]]};
			_object setHit ["_selection", _hit];
		} count _hitpoints;

_inventory = [];
if (!_wogear) then {
	_inventory = [
			getWeaponCargo _object,
			getMagazineCargo _object,
			getBackpackCargo _object
];
} else {
_inventory = [];
};

_query = format["INSERT INTO garage (PlayerUID, Classname, CharacterID, Inventory, Hitpoints, Fuel, Damage, Colour, Colour2) VALUES ('%1', '%2', '%3', '%4', '%5','%6','%7','%8','%9')",_playerUID,_class,_charID,_inventory,_array,_fuel,_damage,_colour,_colour2];

[_query, 1, true] call fn_asyncCall;


PVDZE_storeVehicleResult = true;

if(!isNull _player) then {
	_clientID publicVariableClient "PVDZE_storeVehicleResult";
};

