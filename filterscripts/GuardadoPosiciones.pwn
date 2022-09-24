/**************** [FS] Simple Guardado de Posiciones by HERMES ****************/

#include <a_samp>

// Defines
#define ARCHIVO_POSICIONES "SavedPositions.txt" // Nombre del Archivo

#define SOLO_RCON // Borrar si quieres que los usuarios normales puedan guardar posiciones.

// Colores
#define Rojo 0xFF0000AA
#define Verde 0x789664FF

public OnFilterScriptInit()
{
	// Archivo
	new File: ArchivoPosiciones = fopen(ARCHIVO_POSICIONES, io_readwrite);
	fclose(ArchivoPosiciones);
	//
	print("  ---------------------------------------------");
	print("  | Guardado de Posiciones by HERMES | Cargado |");
	print("  ---------------------------------------------");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[128], idx;
    cmd = strtok(cmdtext, idx);
    
	if(strcmp(cmd, "/guardarpos", true) == 0 || strcmp(cmd, "/savepos", true) == 0)
	{
	    #if defined SOLO_RCON
		if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, Rojo, "<!> No eres Administrador RCON."), PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		#endif
		new Linea[256], Float:X, Float:Y, Float:Z, Float:Angulo;
		cmd = strrest(cmdtext, idx);
		if(IsPlayerInAnyVehicle(playerid))
		{
			new VID = GetPlayerVehicleID(playerid);
	        GetVehiclePos(VID, X, Y, Z);
			GetVehicleZAngle(VID, Angulo);
			format(Linea, sizeof(Linea), "AddStaticVehicle(%d, %f, %f, %f, %f, Color1, Color2); // %s\r\n", GetVehicleModel(VID), X, Y, Z, Angulo, cmd);
			SendClientMessage(playerid, Verde, "-> Posición en vehículo guardada.");
		} else {
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, Angulo);
			format(Linea, sizeof(Linea), "%f, %f, %f, %f // %s\r\n", X, Y, Z, Angulo, cmd);
			SendClientMessage(playerid, Verde, "-> Posición a pie guardada.");
		}
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		new File: ArchivoPosiciones = fopen(ARCHIVO_POSICIONES, io_append);
 	 	fwrite(ArchivoPosiciones, Linea);
	 	fclose(ArchivoPosiciones);
		return 1;
	}
	return 0;
}

strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[64];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

strrest(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[128];
	while ((index < length) && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
