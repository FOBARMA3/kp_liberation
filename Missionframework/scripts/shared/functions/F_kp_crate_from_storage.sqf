/*
f_kp_crate_from_storage.sqf
Author: Wyqer
Website: www.killahpotatoes.de
Date: 2017-03-27

Description:
Unloads given crate type from storage area

Parameters:
_this select 0 - STRING - Crate type
_this select 1 - OBJECT - Storage
*/

private ["_storage_positions","_unload_distance","_unload_pos","_i","_unloaded","_stored_crates","_height"];

switch (typeOf (_this select 1)) do {
	case KP_liberation_small_storage_building: {_storage_positions = KP_liberation_small_storage_positions; _unload_distance = 4;};
	case KP_liberation_large_storage_building: {_storage_positions = KP_liberation_large_storage_positions; _unload_distance = 6.5;};
	default {_storage_positions = KP_liberation_large_storage_positions; _unload_distance = 6.5;};
};

_i = 0;
_unload_pos = [(_this select 1), _unload_distance, (getDir (_this select 1)) - 180] call BIS_fnc_relPos;

while {!((nearestObjects [_unload_pos,KP_liberation_crates,1]) isEqualTo [])} do {
	_i = _i + 1;
	_unload_pos = [(_this select 1), _unload_distance + _i * 1.8, (getDir (_this select 1)) - 180] call BIS_fnc_relPos;
};

sleep 0.5;

_unloaded = false;
_stored_crates = attachedObjects (_this select 1);
reverse _stored_crates;

{
	if (typeOf _x == (_this select 0)) then {
		detach _x;
		
		clearWeaponCargoGlobal _x;
		clearMagazineCargoGlobal _x;
		clearBackpackCargoGlobal _x;
		clearItemCargoGlobal _x;
		
		_x setPos _unload_pos;
		_x enableRopeAttach true;
		_unloaded = true;
	};
	if (_unloaded) exitWith {
		_i = 0;
		{
			_height = 0.6;
			switch (typeOf _x) do {
				case KP_liberation_supply_crate: {_height = 0.4;};
				case KP_liberation_ammo_crate: {_height = 0.6;};
				case KP_liberation_fuel_crate: {_height = 0.3;};
				default {_height = 0.6;};
			};
			detach _x;
			_x attachTo [(_this select 1), [(_storage_positions select _i) select 0, (_storage_positions select _i) select 1, _height]];
			_i = _i + 1;
		} forEach attachedObjects (_this select 1);
	};
} forEach _stored_crates;
