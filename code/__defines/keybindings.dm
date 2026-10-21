// Defines for managed input/keybinding system.
/// Max length of a keypress command before it's considered to be a forged packet/bogus command
#define MAX_KEYPRESS_COMMANDLENGTH 32
/// Maximum keys that can be bound to one button
#define MAX_COMMANDS_PER_KEY 5
/// Maximum keys per keybind
#define MAX_KEYS_PER_KEYBIND 3
/// Max amount of keypress messages per second over two seconds before client is autokicked
#define MAX_KEYPRESS_AUTOKICK 150
/// Max keys that can be held down at once by a client
#define MAX_HELD_KEYS 15

/// Macroset name of hotkeys/keybind only/modern mode
#define SKIN_MACROSET_HOTKEYS "hotkeys"
/// Macroset name of classic hotkey mode
#define SKIN_MACROSET_CLASSIC_HOTKEYS "oldhotkeys"
/// Macroset name of classic input mode
#define SKIN_MACROSET_CLASSIC_INPUT "oldinput"

#define CATEGORY_MOVEMENT "MOVEMENT"
#define CATEGORY_CLIENT "CLIENT"
#define CATEGORY_ADMIN "ADMIN"
#define CATEGORY_CARBON "CARBON"
#define CATEGORY_HUMAN "HUMAN"
#define CATEGORY_MISC "MISC"
#define CATEGORY_COMMUNICATION "COMMUNICATION"
#define CATEGORY_ROBOT "ROBOT"

#define WEIGHT_HIGHEST 0
#define WEIGHT_ADMIN 10
#define WEIGHT_CLIENT 20
#define WEIGHT_ROBOT 30
#define WEIGHT_MOB 40
#define WEIGHT_LIVING 50
#define WEIGHT_LOWEST 999
