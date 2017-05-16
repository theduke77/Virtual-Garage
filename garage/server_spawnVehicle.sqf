private ["_object","_worldspace","_unit","_id","_query","_pipe","_pipe1","_return","_class","_characterID","_inventory","_hitpoints","_fuel","_damage","_dir","_location","_uid","_key","_query1","_pipe1","_colour","_colour2","_result"];

_object = 		_this select 0;
_worldspace = 	_this select 1;
_unit =  _this select 2;
_id   = _this select 3;


_query = format["SELECT classname, CharacterID, Inventory, Hitpoints, Fuel, Damage, Colour, Colour2 FROM garage WHERE ID='%1'",_id];

_result = [_query, 2, true] call fn_asyncCall;
_return = _result select 0;

_class = 		_return select 0;
_characterID =	_return select 1;
_inventory =  _return select 2;
_hitpoints =  _return select 3;
_fuel =  _return select 4;
_damage =  _return select 5;
_colour =  _return select 6;
_colour2 =  _return select 7;






_dir = 		_worldspace select 0;
_location = _worldspace select 1;

_worldspace = [
				_dir,
				_location,
				_colour,
				_colour2
];

_uid = _worldspace call dayz_objectUID2;


//Send request
_key = format["CHILD:308:%1:%2:%3:%4:%5:%6:%7:%8:%9:",dayZ_instance, _class, _damage, _characterID, _worldspace, _inventory, _hitpoints, _fuel,_uid];
_key call server_hiveWrite;

_query1 = format["DELETE FROM garage WHERE ID='%1'",_id];

[_query1, 1, true] call fn_asyncCall;



// Switched to spawn so we can wait a bit for the ID
[_object,_uid,_characterID,_class,_dir,_location,_inventory,_hitpoints,_fuel,_damage,_colour,_colour2,_unit] spawn {
   private ["_object","_uid","_characterID","_class","_inventory","_hitpoints","_fuel","_damage","_done","_retry","_key","_result","_outcome","_oid","_selection","_dam","_objWpnTypes","_objWpnQty","_isOK","_countr","_colour","_colour2","_clrinit","_clrinit2","_unit","_clientID"];

   _object = _this select 0;
   _uid = _this select 1;
   _characterID = _this select 2;
   _class = _this select 3;
   //_dir = _this select 4;
   _location = _this select 5;
   _inventory = _this select 6;
   _hitpoints = _this select 7;
   _fuel = _this select 8;
   _damage = _this select 9;
   _colour = _this select 10;
   _colour2 = _this select 11;
 _unit = _this select 12;
   _clientID = owner _unit;

   _done = false;
	_retry = 0;
	// TODO: Needs major overhaul for 1.1
	while {_retry < 10} do {
		
		sleep 1;
		// GET DB ID
		_key = format["CHILD:388:%1:",_uid];
		diag_log ("HIVE: WRITE: "+ str(_key));
		_result = _key call server_hiveReadWrite;
		_outcome = _result select 0;
		if (_outcome == "PASS") then {
			_oid = _result select 1;
			//_object setVariable ["ObjectID", _oid, true];
			diag_log("CUSTOM: Selected " + str(_oid));
			_done = true;
			_retry = 100;

		} else {
			diag_log("CUSTOM: trying again to get id for: " + str(_uid));
			_done = false;
			_retry = _retry + 1;
		};
	};

	// Remove marker
	deleteVehicle _object;

	_object = createVehicle [_class, _location, [], 0, "CAN_COLLIDE"];
	_object addEventHandler ["HandleDamage", {false}];
	_object setposATL _location;



	clearWeaponCargoGlobal  _object;
	clearMagazineCargoGlobal  _object;
	// _object setVehicleAmmo DZE_vehicleAmmo;

	_object setFuel _fuel;
	_object setDamage _damage;



	
 if (count _inventory > 0) then {	
				
//Add weapons
					_objWpnTypes = (_inventory select 0) select 0;
					_objWpnQty = (_inventory select 0) select 1;
					_countr = 0;					
					{
						if(_x in (DZE_REPLACE_WEAPONS select 0)) then {
							_x = (DZE_REPLACE_WEAPONS select 1) select ((DZE_REPLACE_WEAPONS select 0) find _x);
						};
						_isOK = 	isClass(configFile >> "CfgWeapons" >> _x);
						if (_isOK) then {
							_object addWeaponCargoGlobal [_x,(_objWpnQty select _countr)];
						};
						_countr = _countr + 1;
					} forEach _objWpnTypes; 
				
					//Add Magazines
					_objWpnTypes = (_inventory select 1) select 0;
					_objWpnQty = (_inventory select 1) select 1;
					_countr = 0;
					{
						if (_x == "BoltSteel") then { _x = "WoodenArrow" }; // Convert BoltSteel to WoodenArrow
						if (_x == "ItemTent") then { _x = "ItemTentOld" };
						_isOK = 	isClass(configFile >> "CfgMagazines" >> _x);
						if (_isOK) then {
							_object addMagazineCargoGlobal [_x,(_objWpnQty select _countr)];
						};
						_countr = _countr + 1;
					} forEach _objWpnTypes;

					//Add Backpacks
					_objWpnTypes = (_inventory select 2) select 0;
					_objWpnQty = (_inventory select 2) select 1;
					_countr = 0;
					{
						_isOK = 	isClass(configFile >> "CfgVehicles" >> _x);
						if (_isOK) then {
							_object addBackpackCargoGlobal [_x,(_objWpnQty select _countr)];
						};
						_countr = _countr + 1;
					} forEach _objWpnTypes;

	};



	_object setVariable ["ObjectID", _oid, true];
	
	_object setVariable ["lastUpdate",time];

	if (_colour != "0") then {
			_object setVariable ["Colour",_colour,true];
			_clrinit = format ["#(argb,8,8,3)color(%1)",_colour];
			_object setVehicleInit "this setObjectTexture [0,"+str _clrinit+"];";
		};

	if (_colour2 != "0") then {			
			_object setVariable ["Colour2",_colour2,true];
			_clrinit2 = format ["#(argb,8,8,3)color(%1)",_colour2];
			_object setVehicleInit "this setObjectTexture [1,"+str _clrinit2+"];";
	};
	
	_characterID = str(_characterID);
	_object setVariable ["CharacterID", _characterID, true];

		if(_characterID != "0" && !(_object isKindOf "Bicycle")) then {
						_object setvehiclelock "locked";
					};


				{
					_selection = _x select 0;
					_dam = _x select 1;
					if (_selection in dayZ_explosiveParts && _dam > 0.8) then {_dam = 0.8};
					[_object,_selection,_dam] call fnc_veh_setFixServer;
				} forEach _hitpoints;


	dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];

	_object call fnc_veh_ResetEH;
	
	// for non JIP users this should make sure everyone has eventhandlers for vehicles.
	PVDZE_veh_Init = _object;
	publicVariable "PVDZE_veh_Init";

	PVDZE_spawnVehicleResult = _characterID;

	if(!isNull _unit) then {
	_clientID publicVariableClient "PVDZE_spawnVehicleResult";
	};

	sleep 10;

	_object addEventHandler ["HandleDamage", {true}];
	
};

