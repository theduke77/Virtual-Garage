// Developed by [GZA] David for German Zombie Apocalypse Servers (https://zombieapo.eu/)
private["_control","_index","_vehicle","_class","_magazineslots","_weaponslots","_backpackslots","_magazineCount_raw","_weaponsCount_raw","_backpackCount_raw","_magazineCount","_weaponsCount","_backpackCount","_price","_pricemagazine","_priceweapons","_pricebackpack","_pricegear"];
disableSerialization;
_control = _this select 0;
_index = _this select 1;
_vehicle = StoreVehicleList select _index;

_class = _control lbData _index;

_magazineslots = getNumber(configFile >> "CfgVehicles" >> _class >> "transportMaxMagazines");
_weaponslots = getNumber(configFile >> "CfgVehicles" >> _class >> "transportMaxWeapons");
_backpackslots = getNumber(configFile >> "CfgVehicles" >> _class >> "transportmaxbackpacks");


_magazineCount_raw = getMagazineCargo _vehicle;
_weaponsCount_raw = getWeaponCargo _vehicle;
_backpackCount_raw = getBackpackCargo _vehicle;
_magazineCount = (_magazineCount_raw select 1) call vehicle_gear_count;
_weaponsCount = (_weaponsCount_raw select 1) call vehicle_gear_count;
_backpackCount = (_backpackCount_raw select 1) call vehicle_gear_count;

_price = "Free";

_pricemagazine = 0;
switch true do {
	case (_magazineCount == 0):  {_pricemagazine = 0};
	case (_magazineCount <= 10):  {_pricemagazine = 5000};
	case (_magazineCount <= 20):  {_pricemagazine = 10000};
	case (_magazineCount <= 35):  {_pricemagazine = 17500};
	case (_magazineCount <= 50):  {_pricemagazine = 25000};
	case (_magazineCount <= 75):  {_pricemagazine = 37500};
	case (_magazineCount <= 100): {_pricemagazine = 50000};
	case (_magazineCount <= 125): {_pricemagazine = 62500};
	case (_magazineCount <= 150): {_pricemagazine = 75000};
	case (_magazineCount <= 175): {_pricemagazine = 87500};
	case (_magazineCount <= 200): {_pricemagazine = 100000};
	case (_magazineCount >= 201): {_pricemagazine = 200000};
};

_priceweapons = 0;
switch true do {
	case (_weaponsCount == 0):  {_priceweapons = 0};
	case (_weaponsCount <= 1):  {_priceweapons = 1000};
	case (_weaponsCount <= 5):  {_priceweapons = 5000};
	case (_weaponsCount <= 10):  {_priceweapons = 10000};
	case (_weaponsCount <= 15):  {_priceweapons = 15000};
	case (_weaponsCount <= 20):  {_priceweapons = 20000};
	case (_weaponsCount >= 21):  {_priceweapons = 50000};
};

_pricebackpack = 0;
switch true do {
	case (_backpackCount == 0):  {_pricebackpack = 0};	
	case (_backpackCount == 1):  {_pricebackpack = 5000};
	case (_backpackCount <= 4):  {_pricebackpack = 20000};
	case (_backpackCount <= 8):  {_pricebackpack = 40000};
	case (_backpackCount <= 10):  {_pricebackpack = 50000};
	case (_backpackCount <= 15):  {_pricebackpack = 75000};
	case (_backpackCount <= 16):  {_pricebackpack = 100000};
};

_pricegear = _pricebackpack + _priceweapons + _pricemagazine;
Pricegear = _pricegear;




((findDisplay 3800) displayCtrl 3803) ctrlSetStructuredText parseText format[
	   (" Price without gear:")+ " %1<br/>
	" +("Price with gear:")+ " %2 coins<br/>
	" +("Weapon Slots:")+ " %6/%3<br/>
	" +("Magazine Slots:")+ " %7/%4<br/>
	" +("Backpack Slots:")+ " %8/%5<br/>
	",
_price,
_pricegear,
_weaponslots,
_magazineslots,
_backpackslots,
_weaponsCount,
_magazineCount,
_backpackCount
];

ctrlShow [3803,true];
ctrlShow [3830,true];