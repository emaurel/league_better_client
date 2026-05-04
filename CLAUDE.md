# Context for Claude Code

A Flutter Windows desktop replacement for the official League of Legends client.
Talks to the LCU (League Client Update) over its local HTTPS + WebSocket API.

## Current state

Branch `v2` is the live branch — `main` was wiped and rewritten from scratch.
Last commit at handoff: `6ede6b4`.

**Working:**
- LCU connection layer: lockfile detection (`C:\Riot Games\League of Legends\lockfile`),
  HTTPS REST client (self-signed cert + Basic auth), WebSocket subscriber
- Auto-spawn `LeagueClient.exe` and continuously hide its windows via Win32
  `ShowWindow(SW_HIDE)`
- Riverpod providers for current summoner, friends, lobby, champ select,
  gameflow phase, ready-check, champions
- Screens: Connecting, Profile, Friends, Champions grid, Play (queue picker),
  Lobby, ChampSelect, ReadyCheck overlay
- Standard queue creation works (Ranked/Normal/ARAM/Arena)

**Not working — active blocker:**
- `POST /lol-lobby/v2/lobby` for custom games returns `LcuHttpException(500): {"errorCode":"RPC_ERROR","message":"INVALID_LOBBY"}`
- Body shape we send (in `lib/providers/lcu_actions.dart::createCustomLobby`)
  matches two community references exactly:
  - https://github.com/XHXIAIEIN/LeagueCustomLobby
  - https://github.com/sousa-andre/lcu-driver/blob/master/examples/create_custom_lobby.py
- Tried: `mutators.id` 1 and 6, `gameMode: "CLASSIC"`, `lobbyPassword` `""` and `null`,
  added DELETE before POST to clear stale lobby state
- Goal: get into champ select via custom game so the screen can be tested
  without queueing a real match

## Recommended next step

You can reach the live LCU from this machine. Query the LCU's own help endpoint
for the schema of the failing route:

```powershell
$lf = Get-Content "C:\Riot Games\League of Legends\lockfile" -Raw
$p = $lf -split ':'
$port = $p[2]
$pwd = $p[3]
$h = @{ Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("riot:$pwd")) }
Invoke-RestMethod -Uri "https://127.0.0.1:$port/help?target=POST+/lol-lobby/v2/lobby" -Headers $h -SkipCertificateCheck | ConvertTo-Json -Depth 10
```

That returns the live request schema for this client version. Compare to the body
in `lib/providers/lcu_actions.dart` and fix.

After that, also probe these endpoints (same trick, change `target=`):
- `POST /lol-lobby/v1/lobby/custom/bots` — used by `addBot()`
- `POST /lol-lobby/v1/lobby/custom/start-champ-select` — used by `startCustomChampSelect()`

Both are wired into the LobbyScreen as ADD ALLY/ENEMY BOT and FILL & START CHAMP SELECT
buttons but never tested end-to-end.

## Architecture map

```
lib/
├── main.dart                  ProviderScope + LcuPaths.load()
├── app.dart                   Root: ConnectingScreen vs HomeShell based on connection
├── lcu/
│   ├── lockfile.dart          Lockfile parser + LcuPaths (overrides, persistence)
│   ├── lockfile_watcher.dart  Polls candidate paths every 1s
│   ├── lcu_http.dart          REST client (self-signed cert + Basic auth)
│   ├── lcu_websocket.dart     WAMP-flavored subscriber to all OnJsonApiEvent
│   ├── lcu_session.dart       HTTP + WS pair
│   ├── lcu_connector.dart     Top-level lifecycle, auto-reconnect
│   └── league_launcher.dart   Spawns LeagueClient.exe, hides its windows
├── models/                    Plain Dart classes with fromJson/toJson
├── providers/
│   ├── lcu_providers.dart     connector, session, connected
│   ├── lcu_actions.dart       All POST/PATCH/PUT calls (createLobby, createCustomLobby,
│   │                          addBot, startMatchmaking, hoverChampion, lockChampion, etc.)
│   ├── _resource.dart         Generic "GET once + watch WS" helper
│   └── *_provider.dart        StreamProviders for each LCU resource
├── screens/                   ConnectingScreen, HomeShell, PlayScreen, LobbyScreen,
│                              ChampSelectScreen, ProfileScreen, FriendsScreen,
│                              ChampionsScreen
├── theme/                     League-inspired palette + Material theme
└── widgets/                   LcuImage, ConnectionIndicator, NavRail, ReadyCheckOverlay,
                               SummonerChip
```

## Stack

- Flutter 3.41 / Dart 3.11, Windows desktop only
- State: `flutter_riverpod` 2.x — each LCU resource is a `StreamProvider`
  that fetches once over HTTP then yields updates from the WS event stream
  (helper: `lib/providers/_resource.dart`)
- HTTP/WS: `http` + `web_socket_channel`, both with `HttpClient.badCertificateCallback = (_, _, _) => true`
- Win32: `win32` + `ffi` for `EnumWindows` + `ShowWindow`
- Persistence: `shared_preferences` for the install-path override
- Typography: Cinzel (headings) + Spectral (body) via `google_fonts`

## Workflow

```powershell
git pull
flutter pub get
flutter analyze       # MUST stay clean
flutter test          # unit tests in test/widget_test.dart
flutter run -d windows
```

## Conventions

- Models are immutable, plain Dart classes with `fromJson`/`toJson`. Tolerant
  parsing — never throw on missing fields, default to safe values.
- LCU paths are typed in code, not parameterized — see `LcuPaths.installRoots()`
  for adding new candidate locations.
- UI: gold (`#C8AA6E`) on navy (`#0A1428`), framed `LeaguePanel` blocks with a
  gold header strip. Use existing colors from `lib/theme/app_colors.dart`.
- No comments unless the WHY is non-obvious. No docstrings on every function.
- Run `flutter analyze` before pushing — it must report zero issues.

## Project memory

The user is Edgar (`emaurel` on GitHub). This is a personal project — not
distributable, just for him. Phase 1 requires the official client to be
running (we spawn + hide it). Phase 2 would replace it entirely; out of scope
for now because of OAuth/Vanguard complexity.
