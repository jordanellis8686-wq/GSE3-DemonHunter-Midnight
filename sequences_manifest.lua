-- ==============================================================
-- sequences_manifest.lua
-- GSE3-DemonHunter-Midnight | WoW Midnight 12.0.5.67451
-- Author: Bussyblastr Bargain Bin
--
-- OWNERSHIP REGISTRY — every sequence this addon contains.
-- loaded.lua enforces this list at runtime.
-- Adding a sequence here without updating loaded.lua is ROGUE CODE.
--
-- Owned sequences:
--   [1] DemonHunter_Vengeance_Leveling_Smart  (SpecID 581 — Tank)
--   [2] DemonHunter_Havoc_Leveling_Smart      (SpecID 577 — DPS)
-- ==============================================================

Sequences = Sequences or {}

-- ==============================================================
-- VENGEANCE DEMON HUNTER — TANK — SMART LEVELING
-- SpecID 581
-- Priority order (audited):
--   SURVIVAL FIRST → RESOURCE SUSTAIN → SOUL GENERATION → FILLER
--
-- Defensive CDs    : Demon Spikes (mod:ctrl), Metamorphosis (mod:shift),
--                    Darkness (mod:alt) — all off-GCD or mod-keyed
-- PreMacro          : Immolation Aura (keep up), Fiery Brand (on-CD)
-- Main priority:
--   1  Soul Cleave         — primary heal+threat spender (ALWAYS first)
--   2  Spirit Bomb         — soul-frag absorb shield (talent-gated)
--   3  Fel Devastation     — major heal+dmg channel CD
--   4  Fracture            — 2-soul-frag gen (talent, replaces Shear)
--   5  Burn It Out         — Midnight: bonus soul dmg
--   6  Soul Carver         — burst soul frags (talent)
--   7  Felblade            — fury+soul gen, gap-closer (talent)
--   8  Sigil of Flame      — AoE threat+dot
--   9  Soul Cleanse        — Midnight: targeted cleanse+heal
--   10 Wings of Wrath      — Midnight: wing-burst defensive
--   11 Final Breath        — Midnight: execute/finish
--   12 Reaper's Toll       — Midnight: stacking debuff+dmg
--   13 Hungering Slash     — Midnight: slash+soul-frag
--   14 Soul Barrier        — Midnight: absorb shield CD
--   15 Shear               — baseline soul-frag gen (fallback if no Fracture)
--   16 Throw Glaive        — ranged filler
-- PostMacro: re-attempt Soul Cleave + Fracture each cycle
-- ==============================================================
Sequences["DemonHunter_Vengeance_Leveling_Smart"] = {
    SpecID = 581,
    Author = "Bussyblastr Bargain Bin",
    Help = "Vengeance DH Smart Leveling — Tank. Fully adaptive [known:] gating covers all talents and Midnight abilities. Correct priority: survival first, sustain second, soul generation third. Modifier keys: Ctrl=Demon Spikes, Shift=Metamorphosis, Alt=Darkness. Patch 12.0.5.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",

            -- --------------------------------------------------------
            -- KEY PRESS — fires on every button press before main step
            -- Used for: targeting, auto-attack, trinkets, off-GCD CDs
            -- --------------------------------------------------------
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/startattack",
                "/use 13",
                "/use 14",
                -- Demon Spikes: off-GCD defensive parry buff — Ctrl to use
                "/cast [mod:ctrl,@player][known:Demon Spikes] Demon Spikes",
                -- Metamorphosis (Vengeance): major tank CD — Shift to use
                "/cast [mod:shift,@player][known:Metamorphosis] Metamorphosis",
                -- Darkness: raid-wide absorb bubble — Alt to use
                "/cast [mod:alt,@player][known:Darkness] Darkness",
                -- Consume Magic: interrupt magic on target (always available)
                "/cast [mod:alt,@target,harm][known:Consume Magic] Consume Magic",
            },

            -- --------------------------------------------------------
            -- PRE MACRO — fires every click, before main rotation step
            -- Keep Immolation Aura up (soul gen + damage passive).
            -- Fiery Brand on cooldown (reduces damage taken 40%).
            -- --------------------------------------------------------
            PreMacro = {
                "/cast [nochanneling][known:Immolation Aura] Immolation Aura",
                "/cast [nochanneling][known:Fiery Brand] Fiery Brand",
            },

            -- --------------------------------------------------------
            -- MAIN ROTATION — Priority loop
            -- Each entry tried in order; first one that can fire, fires.
            -- [nochanneling] skips entry while a channel is active.
            -- [known:X] skips entry if player does not know the spell
            --   (handles talent-gating and level-gating automatically).
            -- --------------------------------------------------------
            Main = {
                -- 1. SOUL CLEAVE — primary heal, threat, and fury spender
                --    Always first: it is the core of Vengeance sustain.
                "/cast [nochanneling][known:Soul Cleave] Soul Cleave",

                -- 2. SPIRIT BOMB — consumes 4+ soul fragments for massive absorb
                --    Talent-gated; [known:] ensures it only fires when talented.
                "/cast [nochanneling][known:Spirit Bomb] Spirit Bomb",

                -- 3. FEL DEVASTATION — 2s channel: major heal + AoE damage burst
                --    Major CD; use on cooldown, high heal value.
                "/cast [nochanneling][known:Fel Devastation] Fel Devastation",

                -- 4. FRACTURE — 2 soul fragments, instant fury gen
                --    Talent-gated; replaces Shear when talented.
                "/cast [nochanneling][known:Fracture] Fracture",

                -- 5. BURN IT OUT — Midnight: bonus soul damage
                "/cast [nochanneling][known:Burn It Out] Burn It Out",

                -- 6. SOUL CARVER — burst soul fragments, AoE damage
                "/cast [nochanneling][known:Soul Carver] Soul Carver",

                -- 7. FELBLADE — fury + soul generation, instant gap-closer
                "/cast [nochanneling][known:Felblade] Felblade",

                -- 8. SIGIL OF FLAME — AoE threat + damage over time
                "/cast [nochanneling][known:Sigil of Flame] Sigil of Flame",

                -- 9. SOUL CLEANSE — Midnight: targeted cleanse + heal
                "/cast [nochanneling][known:Soul Cleanse] Soul Cleanse",

                -- 10. WINGS OF WRATH — Midnight: wing-burst defensive
                "/cast [nochanneling][known:Wings of Wrath] Wings of Wrath",

                -- 11. FINAL BREATH — Midnight: execute/finish
                "/cast [nochanneling][known:Final Breath] Final Breath",

                -- 12. REAPER'S TOLL — Midnight: stacking debuff + damage
                "/cast [nochanneling][known:Reaper's Toll] Reaper's Toll",

                -- 13. HUNGERING SLASH — Midnight: slash + soul-frag
                "/cast [nochanneling][known:Hungering Slash] Hungering Slash",

                -- 14. SOUL BARRIER — Midnight: absorb shield cooldown
                "/cast [nochanneling][known:Soul Barrier] Soul Barrier",

                -- 15. SHEAR — baseline soul fragment generator
                --    Fallback when Fracture is not talented.
                "/cast [nochanneling][known:Shear] Shear",

                -- 16. THROW GLAIVE — ranged filler, useful on moving targets
                "/cast [nochanneling][known:Throw Glaive] Throw Glaive",
            },

            -- --------------------------------------------------------
            -- POST MACRO — re-attempt core abilities each cycle
            -- Helps maintain priority when GCD timing allows.
            -- --------------------------------------------------------
            PostMacro = {
                "/cast [nochanneling][known:Soul Cleave] Soul Cleave",
                "/cast [nochanneling][known:Fracture] Fracture",
            },

            -- --------------------------------------------------------
            -- KEY RELEASE — fires on button release
            -- Used for: startattack confirmation, cleanup
            -- --------------------------------------------------------
            KeyRelease = {
                "/startattack",
            },
        },
    },
}

-- ==============================================================
-- HAVOC DEMON HUNTER — DPS (PVE) — SMART LEVELING
-- SpecID 577
-- Priority order (audited):
--   BURST CDs → DAMAGE AMPLIFIERS → FURY SPENDERS → BUILDERS → FILLER
--
-- Modifier keys   : Shift=Metamorphosis, Ctrl=The Hunt, Alt=Darkness
-- PreMacro        : Immolation Aura (keep up), Eye Beam (on-CD)
-- Main priority:
--   1  Eye Beam               — major CD 120s, highest damage
--   2  Essence Break          — damage amp; use before Chaos Strike burst
--   3  The Hunt               — mobility+damage CD (talent)
--   4  Death Sweep            — Metamorphosis-enhanced Blade Dance
--   5  Blade Dance            — high damage multi-hit (non-meta)
--   6  Annihilation           — Metamorphosis-enhanced Chaos Strike
--   7  Chaos Strike           — primary fury spender (non-meta)
--   8  Reaver's Glaive        — Midnight: Aldrachi spec core ability
--   9  Art of the Glaive      — Midnight: Aldrachi combo builder
--   10 Glaive Flurry          — Midnight: multi-target glaive
--   11 Rending Strike         — Midnight: bleed+glaive combo
--   12 Reaver's Mark          — Midnight: stacking debuff
--   13 Void Metamorphosis     — Midnight: alternate void meta form
--   14 Demonsurge             — Midnight: fel surge burst
--   15 Void Ray               — Midnight: void-energy beam
--   16 Dark Matter            — Midnight: shadow damage proc
--   17 Eradicate              — Midnight: execute finisher
--   18 Devourer's Bite        — Midnight: life drain finisher
--   19 Voidrush               — Midnight: void gap-closer
--   20 Felblade               — fury gen + mobility (talent)
--   21 Fel Rush               — mobility + damage
--   22 Demon's Bite           — baseline fury generator (filler)
--   23 Throw Glaive           — ranged filler
-- PostMacro: re-attempt Chaos Strike + Demon's Bite each cycle
-- ==============================================================
Sequences["DemonHunter_Havoc_Leveling_Smart"] = {
    SpecID = 577,
    Author = "Bussyblastr Bargain Bin",
    Help = "Havoc DH Smart Leveling — DPS. Fully adaptive [known:] gating covers all talents and Midnight abilities. Optimized priority: CDs first, damage amps second, spenders third, builders fourth. Modifier keys: Shift=Metamorphosis, Ctrl=The Hunt, Alt=Darkness. Patch 12.0.5.",
    MacroVersions = {
        [1] = {
            StepFunction = "Priority",

            -- --------------------------------------------------------
            -- KEY PRESS — targeting, auto-attack, trinkets, CDs
            -- --------------------------------------------------------
            KeyPress = {
                "/targetenemy [noharm][dead]",
                "/startattack",
                "/use 13",
                "/use 14",
                -- Metamorphosis (Havoc): major DPS CD — Shift to use
                "/cast [mod:shift,@player][known:Metamorphosis] Metamorphosis",
                -- The Hunt: mobility+damage CD — Ctrl to use
                "/cast [mod:ctrl,@player][known:The Hunt] The Hunt",
                -- Darkness: defensive CD — Alt to use
                "/cast [mod:alt,@player][known:Darkness] Darkness",
                -- Consume Magic: interrupt
                "/cast [mod:alt,@target,harm][known:Consume Magic] Consume Magic",
            },

            -- --------------------------------------------------------
            -- PRE MACRO — maintain buffs, use Eye Beam on CD
            -- --------------------------------------------------------
            PreMacro = {
                "/cast [nochanneling][known:Immolation Aura] Immolation Aura",
                "/cast [nochanneling][known:Eye Beam] Eye Beam",
            },

            -- --------------------------------------------------------
            -- MAIN ROTATION — 23-step priority system
            -- --------------------------------------------------------
            Main = {
                -- 1. EYE BEAM — major 120s CD, highest damage ability
                "/cast [nochanneling][known:Eye Beam] Eye Beam",

                -- 2. ESSENCE BREAK — damage amplifier, use before spender burst
                "/cast [nochanneling][known:Essence Break] Essence Break",

                -- 3. THE HUNT — mobility + damage CD (talent)
                "/cast [nochanneling][known:The Hunt] The Hunt",

                -- 4. DEATH SWEEP — Metamorphosis-enhanced Blade Dance
                "/cast [nochanneling][known:Death Sweep] Death Sweep",

                -- 5. BLADE DANCE — high damage multi-hit (non-Meta)
                "/cast [nochanneling][known:Blade Dance] Blade Dance",

                -- 6. ANNIHILATION — Metamorphosis-enhanced Chaos Strike
                "/cast [nochanneling][known:Annihilation] Annihilation",

                -- 7. CHAOS STRIKE — primary fury spender (non-Meta)
                "/cast [nochanneling][known:Chaos Strike] Chaos Strike",

                -- 8. REAVER'S GLAIVE — Midnight: Aldrachi core ability
                "/cast [nochanneling][known:Reaver's Glaive] Reaver's Glaive",

                -- 9. ART OF THE GLAIVE — Midnight: Aldrachi combo builder
                "/cast [nochanneling][known:Art of the Glaive] Art of the Glaive",

                -- 10. GLAIVE FLURRY — Midnight: multi-target glaive
                "/cast [nochanneling][known:Glaive Flurry] Glaive Flurry",

                -- 11. RENDING STRIKE — Midnight: bleed + glaive combo
                "/cast [nochanneling][known:Rending Strike] Rending Strike",

                -- 12. REAVER'S MARK — Midnight: stacking debuff
                "/cast [nochanneling][known:Reaver's Mark] Reaver's Mark",

                -- 13. VOID METAMORPHOSIS — Midnight: alternate void meta form
                "/cast [nochanneling][known:Void Metamorphosis] Void Metamorphosis",

                -- 14. DEMONSURGE — Midnight: fel surge burst
                "/cast [nochanneling][known:Demonsurge] Demonsurge",

                -- 15. VOID RAY — Midnight: void-energy beam
                "/cast [nochanneling][known:Void Ray] Void Ray",

                -- 16. DARK MATTER — Midnight: shadow damage proc
                "/cast [nochanneling][known:Dark Matter] Dark Matter",

                -- 17. ERADICATE — Midnight: execute finisher
                "/cast [nochanneling][known:Eradicate] Eradicate",

                -- 18. DEVOURER'S BITE — Midnight: life drain finisher
                "/cast [nochanneling][known:Devourer's Bite] Devourer's Bite",

                -- 19. VOIDRUSH — Midnight: void gap-closer
                "/cast [nochanneling][known:Voidrush] Voidrush",

                -- 20. FELBLADE — fury gen + instant gap-closer (talent)
                "/cast [nochanneling][known:Felblade] Felblade",

                -- 21. FEL RUSH — mobility + damage; use as filler
                "/cast [nochanneling][known:Fel Rush] Fel Rush",

                -- 22. DEMON'S BITE — baseline fury generator (40 fury), filler
                "/cast [nochanneling][known:Demon's Bite] Demon's Bite",

                -- 23. THROW GLAIVE — ranged filler; useful on moving targets
                "/cast [nochanneling][known:Throw Glaive] Throw Glaive",
            },

            -- --------------------------------------------------------
            -- POST MACRO — re-attempt spender and generator each cycle
            -- --------------------------------------------------------
            PostMacro = {
                "/cast [nochanneling][known:Chaos Strike] Chaos Strike",
                "/cast [nochanneling][known:Demon's Bite] Demon's Bite",
            },

            -- --------------------------------------------------------
            -- KEY RELEASE
            -- --------------------------------------------------------
            KeyRelease = {
                "/startattack",
            },
        },
    },
}