# Roblox Asym Horror (Forsaken-like) — серверный каркас

Обновлённая структура теперь делает морфы **в готовые модели из `ServerStorage`**:

- `ServerStorage/Killers/<ModelName>`
- `ServerStorage/Survivors/<ModelName>`

На старте раунда игрок получает роль и превращается в модель, указанную в его character-definition файле.

## Структура

```text
src/
  ServerScriptService/
    Main.server.lua
    Modules/
      RoundManager.lua
      TeamService.lua
      MorphService.lua
      AbilityService.lua
      CharacterRegistry.lua
    CharacterDefinitions/
      Killers/
        Slasher.lua
        Brute.lua
      Survivors/
        Scout.lua
        Medic.lua
  ReplicatedStorage/
    Config/
      Abilities/
        AbilityCatalog.lua
    Remotes/ (создается/используется рантаймом)
  StarterPlayerScripts/
    RoundClient.client.lua
```

## Что важно подготовить в Roblox Studio

В `ServerStorage` должны быть папки и модели:

```text
ServerStorage
  Killers
    Slasher (Model)
    Brute (Model)
  Survivors
    Scout (Model)
    Medic (Model)
```

Требования к каждой модели:
- это `Model`,
- внутри есть `Humanoid`,
- есть `HumanoidRootPart` (или корректно выставлен `PrimaryPart`).

## Character-definition по файлам

Сделано по отдельному файлу на персонажа:

- убийцы:
  - `CharacterDefinitions/Killers/Slasher.lua`
  - `CharacterDefinitions/Killers/Brute.lua`
- выжившие:
  - `CharacterDefinitions/Survivors/Scout.lua`
  - `CharacterDefinitions/Survivors/Medic.lua`

В каждом файле задаются:
- `Id`
- `Role`
- `DisplayName`
- `ModelName` (имя модели в `ServerStorage`)
- `Abilities`
- `Stats`

## Поведение раунда

1. `RoundManager` запускает интермиссию.
2. При старте раунда выбирается убийца.
3. Для каждого игрока берётся его definition через `CharacterRegistry`.
4. `MorphService` клонирует нужную модель из `ServerStorage` и назначает её как `player.Character`.
5. Применяются статы и лоадаут способностей.

## Что дальше

Когда дашь имена/способности/ХП/скорости — я просто обновлю 4 definition-файла и каталоги способностей.
