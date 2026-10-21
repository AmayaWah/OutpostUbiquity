import { type ReactNode, useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { releaseHeldKeys } from 'tgui/hotkeys';
import {
  Box,
  Button,
  Modal,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import type { KeybindingEntry, PreferencesMenuData } from './data';
import { TabbedMenu } from './TabbedMenu';

const MODIFIERS = ['Alt', 'Ctrl', 'Shift'];

const KEY_ESCAPE = 27;

// Alt, Ctrl, Shift and the Windows/Meta keys
const MODIFIER_KEY_CODES = [16, 17, 18, 91, 92, 93];

// OEM punctuation keys, by key code
const PUNCTUATION_KEYS: Record<number, string> = {
  186: ';',
  187: '=',
  188: ',',
  189: '-',
  190: '.',
  191: '/',
  192: '`',
  219: '[',
  220: '\\',
  221: ']',
  222: "'",
};

const ARROW_AND_NAV_KEYS: Record<number, string> = {
  32: 'Space',
  33: 'Northeast',
  34: 'Southeast',
  35: 'Southwest',
  36: 'Northwest',
  37: 'West',
  38: 'North',
  39: 'East',
  40: 'South',
  45: 'Insert',
  46: 'Delete',
  106: 'Multiply',
  107: 'Add',
  109: 'Subtract',
  110: 'Decimal',
  111: 'Divide',
};

/**
 * Converts a key code to the key's BYOND name. BYOND names keys by the layout
 * the player is typing on, and so does keyCode, unlike event.code, which is
 * the physical position of the key.
 */
function keyCodeToByond(keyCode: number): string | null {
  if (ARROW_AND_NAV_KEYS[keyCode]) {
    return ARROW_AND_NAV_KEYS[keyCode];
  }
  if (PUNCTUATION_KEYS[keyCode]) {
    return PUNCTUATION_KEYS[keyCode];
  }
  if ((keyCode >= 48 && keyCode <= 57) || (keyCode >= 65 && keyCode <= 90)) {
    return String.fromCharCode(keyCode);
  }
  if (keyCode >= 96 && keyCode <= 105) {
    return `Numpad${keyCode - 96}`;
  }
  if (keyCode >= 112 && keyCode <= 123) {
    return `F${keyCode - 111}`;
  }
  return null;
}

/** Builds the key the way the server expects it: Alt, Ctrl, Shift, then the key. */
function eventToKeybind(event: KeyboardEvent): string | null {
  const key = keyCodeToByond(event.keyCode);
  if (!key) {
    return null;
  }
  return `${event.altKey ? 'Alt' : ''}${event.ctrlKey ? 'Ctrl' : ''}${
    event.shiftKey ? 'Shift' : ''
  }${key}`;
}

function prettyKey(key: string): string {
  const parts: string[] = [];
  let rest = key;
  for (const modifier of MODIFIERS) {
    if (rest.startsWith(modifier)) {
      parts.push(modifier);
      rest = rest.slice(modifier.length);
    }
  }
  parts.push(rest);
  return parts.join('+');
}

function titleCase(text: string): string {
  return text.charAt(0).toUpperCase() + text.slice(1).toLowerCase();
}

type Capture = {
  name: string;
  oldKey?: string;
};

type Conflict = {
  name: string;
  key: string;
  oldKey?: string;
  conflictsWith: string[];
};

export const KeybindingsPage = (props) => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const keybindings = data.keybindings ?? {};
  const keysByName = data.keybindings_by_name ?? {};
  const maxKeys = data.max_keys_per_keybind ?? 3;

  const [capture, setCapture] = useState<Capture | null>(null);
  const [conflict, setConflict] = useState<Conflict | null>(null);
  const [confirmResetAll, setConfirmResetAll] = useState(false);

  const entriesByName: Record<string, KeybindingEntry> = {};
  for (const entries of Object.values(keybindings)) {
    for (const entry of entries) {
      entriesByName[entry.name] = entry;
    }
  }

  function submit(current: Capture, key: string) {
    const entry = entriesByName[current.name];
    // Only one action per key, among the ones that can be active at the same time
    const conflictsWith = Object.entries(keysByName)
      .filter(
        ([name, keys]) =>
          name !== current.name &&
          entriesByName[name]?.group === entry?.group &&
          keys.includes(key),
      )
      .map(([name]) => entriesByName[name]?.full_name ?? name);

    if (conflictsWith.length) {
      setConflict({
        name: current.name,
        key,
        oldKey: current.oldKey,
        conflictsWith,
      });
      return;
    }

    act('set_keybind', {
      keybinding: current.name,
      key,
      old_key: current.oldKey,
    });
  }

  useEffect(() => {
    if (!capture) {
      return;
    }

    // Let go of anything tgui had already passed to BYOND as held, so it can't stay stuck while we swallow keys.
    releaseHeldKeys();

    // Capturing on the window stops tgui from passing the key on to BYOND, so it doesn't trigger the action.
    const onKeyDown = (event: KeyboardEvent) => {
      event.preventDefault();
      event.stopImmediatePropagation();
      if (event.repeat) {
        return;
      }
      if (event.keyCode === KEY_ESCAPE) {
        setCapture(null);
        return;
      }
      if (MODIFIER_KEY_CODES.includes(event.keyCode)) {
        return;
      }
      const key = eventToKeybind(event);
      if (!key) {
        return;
      }
      setCapture(null);
      submit(capture, key);
    };
    // Key releases are left alone: the key press was never passed on, so there is nothing for them to release.
    // If the window loses focus, stop capturing rather than waiting for a key that will go to the game.
    const onBlur = () => setCapture(null);

    window.addEventListener('keydown', onKeyDown, true);
    window.addEventListener('blur', onBlur);
    return () => {
      window.removeEventListener('keydown', onKeyDown, true);
      window.removeEventListener('blur', onBlur);
    };
  }, [capture, keysByName]);

  const categoryEntries: [string, ReactNode][] = Object.entries(keybindings)
    .map(([category, entries]) => ({
      category,
      entries: [...entries].sort(
        (a, b) => a.weight - b.weight || a.full_name.localeCompare(b.full_name),
      ),
    }))
    .sort(
      (a, b) =>
        Math.min(...a.entries.map((entry) => entry.weight)) -
          Math.min(...b.entries.map((entry) => entry.weight)) ||
        a.category.localeCompare(b.category),
    )
    .map(({ category, entries }): [string, ReactNode] => [
      titleCase(category),
      entries.map((entry) => {
        const keys = keysByName[entry.name] ?? [];
        return (
          <Stack align="center" key={entry.name} pb={1}>
            <Stack.Item grow basis={0} ml={2}>
              <Tooltip
                content={entry.description || entry.full_name}
                position="bottom-start"
              >
                <Box as="span">{entry.full_name}</Box>
              </Tooltip>
            </Stack.Item>
            <Stack.Item>
              {keys.map((key) => {
                const capturing =
                  capture?.name === entry.name && capture?.oldKey === key;
                return (
                  <Button
                    key={key}
                    inline
                    minWidth={9}
                    textAlign="center"
                    selected={capturing}
                    onClick={() =>
                      setCapture(
                        capturing ? null : { name: entry.name, oldKey: key },
                      )
                    }
                  >
                    {capturing ? 'Press a key...' : prettyKey(key)}
                  </Button>
                );
              })}
              {keys.length < maxKeys && (
                <Button
                  inline
                  icon="plus"
                  tooltip="Add another key"
                  selected={capture?.name === entry.name && !capture?.oldKey}
                  onClick={() =>
                    setCapture(
                      capture?.name === entry.name && !capture?.oldKey
                        ? null
                        : { name: entry.name },
                    )
                  }
                >
                  {capture?.name === entry.name && !capture?.oldKey
                    ? 'Press a key...'
                    : keys.length
                      ? ''
                      : 'Unbound'}
                </Button>
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="rotate-left"
                tooltip="Reset to default"
                onClick={() => act('reset_keybind', { keybinding: entry.name })}
              />
            </Stack.Item>
          </Stack>
        );
      }),
    ]);

  return (
    <>
      {conflict && (
        <Modal>
          <Box mb={2}>
            {prettyKey(conflict.key)} is already used by{' '}
            <b>{conflict.conflictsWith.join(', ')}</b>. Binding it here will
            unbind it from there.
          </Box>
          <Button
            color="good"
            onClick={() => {
              act('set_keybind', {
                keybinding: conflict.name,
                key: conflict.key,
                old_key: conflict.oldKey,
                replace: true,
              });
              setConflict(null);
            }}
          >
            Replace
          </Button>
          <Button onClick={() => setConflict(null)}>Cancel</Button>
        </Modal>
      )}
      {confirmResetAll && (
        <Modal>
          <Box mb={2}>Reset every keybinding to its default?</Box>
          <Button
            color="bad"
            onClick={() => {
              act('reset_all_keybinds');
              setConfirmResetAll(false);
            }}
          >
            Reset all
          </Button>
          <Button onClick={() => setConfirmResetAll(false)}>Cancel</Button>
        </Modal>
      )}
      <Stack vertical fill>
        <Stack.Item>
          <Stack align="center" px={2} pb={1}>
            <Stack.Item grow>
              Click a key to change it, then press the new key. Escape cancels.
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="trash-can"
                color="bad"
                onClick={() => setConfirmResetAll(true)}
              >
                Reset all
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow basis={0}>
          <TabbedMenu categoryEntries={categoryEntries} />
        </Stack.Item>
      </Stack>
    </>
  );
};
