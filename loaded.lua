-- ==============================================================
-- loaded.lua
-- GSE3-DemonHunter-Midnight | WoW Midnight 12.0.5.67451
-- Author: Bussyblastr Bargain Bin
--
-- PURPOSE:
--   1. Hard-define which sequences belong to this addon.
--   2. At load time, scan all loaded sequences and WARN loudly
--      about any DemonHunter_* sequence that is NOT in the
--      ownership registry (rogue code detection).
--   3. Confirm all owned sequences are present and loaded.
--
-- WORKFLOW ENFORCEMENT — SEE SEQUENCE_WORKFLOW.md FOR FULL RULES.
--   Rule 1: Only sequences named "DemonHunter_*" may live here.
--   Rule 2: Every sequence in sequences_manifest.lua MUST appear
--            in OWNED_SEQUENCES below. No unlisted sequences.
--   Rule 3: sequences_manifest.lua is the single source of truth.
--            Never define sequences inline in this file.
-- ==============================================================

local ADDON_NAME = "GSE3-DemonHunter-Midnight"
local COLOR_OK   = "|cFF00FF00"   -- green
local COLOR_WARN = "|cFFFFFF00"   -- yellow
local COLOR_ERR  = "|cFFFF4444"   -- red
local COLOR_END  = "|r"

-- ==============================================================
-- SEQUENCE OWNERSHIP REGISTRY
-- This is the single authoritative list of sequences owned by
-- this addon. Any DemonHunter_* sequence found in the global
-- Sequences table that is NOT listed here is ROGUE CODE and will
-- be flagged with an error message on load.
--
-- When adding a new sequence:
--   1. Define it in sequences_manifest.lua.
--   2. Add its name to OWNED_SEQUENCES here.
--   3. Commit both files together — never one without the other.
-- ==============================================================
local OWNED_SEQUENCES = {
    "DemonHunter_Vengeance_Leveling_Smart",   -- SpecID 581 Tank
    "DemonHunter_Havoc_Leveling_Smart",        -- SpecID 577 DPS PVE
}

-- Build a lookup set for O(1) membership checks
local owned_set = {}
for _, name in ipairs(OWNED_SEQUENCES) do
    owned_set[name] = true
end

-- ==============================================================
-- VALIDATION FUNCTIONS
-- ==============================================================

-- Checks every DemonHunter_* sequence in the global Sequences
-- table. Sequences not in the registry are flagged as rogue code.
local function DetectRogueSequences()
    if not Sequences then return end
    local rogue_found = false
    for seq_name, _ in pairs(Sequences) do
        if string.sub(seq_name, 1, 13) == "DemonHunter_" then
            if not owned_set[seq_name] then
                rogue_found = true
                print(COLOR_ERR
                    .. "[" .. ADDON_NAME .. "] ROGUE SEQUENCE: "
                    .. seq_name
                    .. " is not in the ownership registry. "
                    .. "Move it to the correct addon or add it to OWNED_SEQUENCES in loaded.lua."
                    .. COLOR_END)
            end
        end
    end
    if not rogue_found then
        print(COLOR_OK
            .. "[" .. ADDON_NAME .. "] Rogue-code check PASSED — no unregistered sequences."
            .. COLOR_END)
    end
end

-- Verifies every sequence in OWNED_SEQUENCES is actually present
-- in the global Sequences table (i.e., sequences_manifest.lua loaded).
local function VerifyOwnedSequencesLoaded()
    if not Sequences then
        print(COLOR_ERR
            .. "[" .. ADDON_NAME .. "] ERROR: Global Sequences table is nil. "
            .. "GSE may not be loaded or sequences_manifest.lua failed to load."
            .. COLOR_END)
        return
    end
    local missing = {}
    for _, name in ipairs(OWNED_SEQUENCES) do
        if not Sequences[name] then
            missing[#missing + 1] = name
        end
    end
    if #missing == 0 then
        print(COLOR_OK
            .. "[" .. ADDON_NAME .. "] All "
            .. #OWNED_SEQUENCES
            .. " owned sequences verified."
            .. COLOR_END)
    else
        for _, name in ipairs(missing) do
            print(COLOR_ERR
                .. "[" .. ADDON_NAME .. "] MISSING SEQUENCE: "
                .. name
                .. " is in OWNED_SEQUENCES but not found in sequences_manifest.lua."
                .. COLOR_END)
        end
    end
end

-- Validates each owned sequence has correct required fields.
local function ValidateSequenceSchema()
    if not Sequences then return end
    for _, name in ipairs(OWNED_SEQUENCES) do
        local seq = Sequences[name]
        if seq then
            if not seq.SpecID then
                print(COLOR_WARN
                    .. "[" .. ADDON_NAME .. "] SCHEMA WARNING: "
                    .. name .. " is missing SpecID."
                    .. COLOR_END)
            end
            if not seq.MacroVersions or not seq.MacroVersions[1] then
                print(COLOR_WARN
                    .. "[" .. ADDON_NAME .. "] SCHEMA WARNING: "
                    .. name .. " is missing MacroVersions[1]."
                    .. COLOR_END)
            else
                local mv = seq.MacroVersions[1]
                if not mv.StepFunction then
                    print(COLOR_WARN
                        .. "[" .. ADDON_NAME .. "] SCHEMA WARNING: "
                        .. name .. " MacroVersions[1] is missing StepFunction."
                        .. COLOR_END)
                end
                if not mv.Main or #mv.Main == 0 then
                    print(COLOR_WARN
                        .. "[" .. ADDON_NAME .. "] SCHEMA WARNING: "
                        .. name .. " MacroVersions[1] has empty Main rotation."
                        .. COLOR_END)
                end
            end
        end
    end
end

-- ==============================================================
-- ADDON LOAD EVENT
-- ==============================================================
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon_loaded)
    if addon_loaded ~= ADDON_NAME then return end

    print(COLOR_OK
        .. "[" .. ADDON_NAME .. "] Loading DemonHunter sequences..."
        .. COLOR_END)

    -- Run all validation passes in order
    VerifyOwnedSequencesLoaded()
    DetectRogueSequences()
    ValidateSequenceSchema()

    print(COLOR_OK
        .. "[" .. ADDON_NAME .. "] Ready. "
        .. #OWNED_SEQUENCES
        .. " sequences: Vengeance (Tank) + Havoc (DPS). "
        .. "See /gse to configure."
        .. COLOR_END)

    -- Unregister after first load — no need to re-run
    self:UnregisterEvent("ADDON_LOADED")
end)