# Roblox Asym Horror (Forsaken-like) — серверный каркас

Проект обновлён под твои требования:

- старт раунда от **2 игроков**,
- киллер в текущей сборке всегда морфится в `ServerStorage/Killers/DEV/AKTEP`,
- выжившие получают **рандомного персонажа** из конфига выживших (модель берётся по `ModelPath` из `ServerStorage/Survivors`),
- телепорт в начале раунда на `Workspace.RoundPart`,
- по завершению раунда возврат в обычный аватар и телепорт на `SpawnLocation`,
- управление абилками через `RoundGui` (`Number1-3` для киллера, `Sprint` для выжившего),
- таймер/статус через `LobbyGui.Timer.Label`,
- добавлена система музыки `MusicSystem`: **Chase Theme** и **LMS Theme**.

## Структура способностей персонажа

Теперь каждый персонаж описывается структурой:

```lua
Abilities = {
    Ability1 = {
        Name = "",
        Type = "Attack / Dash / Stun / Utility / Passive",
        Cooldown = number,
        Damage = number,
        Range = number,
        Duration = number,
        ServerLogic = function(player,target)
        end
    },
    Ability2 = {...},
    Passive = {...}
}
```

> Для AKTEP дополнительно добавлен `Ability3` (`You Are Mine`), чтобы покрыть отдельную кнопку `Number3`.

## Реализованные персонажи

### Survivors
- Sonic
- Tails
- Knuckles
- Amy
- Silver
- Blaze

### Killers
- Fleetway Super Sonic
- Maniac Super Sonic
- Kolossos
- AKTEP (DEV killer)

Все лежат отдельными файлами в `src/ServerScriptService/CharacterDefinitions/...`.

## Музыка

`MusicSystem` управляет двумя режимами:

1. **Chase Theme**
   - если выживший ближе 60 studs к киллеру — включается chase-тема,
   - если дальше 80 studs — выключается с плавным фейдом,
   - у киллера есть поля `KillerConfig.ChaseMusic` и `KillerConfig.Volume`.

2. **LMS Theme**
   - если жив остался 1 выживший — включается LMS тема для всех,
   - выключается при изменении условия/окончании раунда.

## GUI интеграция

Нужные элементы UI:

- `LobbyGui -> Timer -> Label`
- `RoundGui -> Number1`
- `RoundGui -> Number2`
- `RoundGui -> Number3`
- `RoundGui -> Sprint`

Поведение:
- Killer: видит `Number1-3`, `Sprint` скрыт.
- Survivor: видит только `Sprint`.

## Обязательные объекты в Studio

```text
ServerStorage
  Killers
    DEV
      AKTEP (Model)
    FleetwaySuperSonic (Model)
    ManiacSuperSonic (Model)
    Kolossos (Model)
  Survivors
    Sonic (Model)
    Tails (Model)
    Knuckles (Model)
    Amy (Model)
    Silver (Model)
    Blaze (Model)

Workspace
  RoundPart (Part)
  SpawnLocation (SpawnLocation)
```

## Что можно заполнить дальше

- реальные SoundId для Chase/LMS у каждого киллера,
- точную боёвку (hitbox, stun-state machine, bleed visual effects, coins economy),
- реальное сохранение монет и инвентаря (DataStore + shop).
