import type { sendAct } from 'tgui/events/act';

import type { LegacyConstant } from './bay_prefs/data';

export enum GamePreferencesSelectedPage {
  Settings,
  Keybindings,
}

export const createSetPreference =
  (act: typeof sendAct, preference: string) => (value: unknown) => {
    act('set_preference', {
      preference,
      value,
    });
  };

export enum Window {
  Character = 0,
  Game = 1,
  Keybindings = 2,
}

export type KeybindingEntry = {
  name: string;
  full_name: string;
  description: string;
  group: string;
  default_keys: string[];
  weight: number;
};

export type PreferencesMenuData = {
  keybindings?: Record<string, KeybindingEntry[]>;
  keybindings_by_name?: Record<string, string[]>;
  max_keys_per_keybind?: number;

  character_profiles: (string | null)[];

  character_preferences: {
    game_preferences: Record<string, unknown>;
  };

  active_slot: number;

  window: Window;
};

export type ServerData = {
  legacy: LegacyConstant;
  [otheyKey: string]: unknown;
};
