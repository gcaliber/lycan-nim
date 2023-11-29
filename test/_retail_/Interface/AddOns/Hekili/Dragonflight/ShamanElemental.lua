-- ShamanElemental.lua
-- October 2022

if UnitClassBase( "player" ) ~= "SHAMAN" then return end

local addon, ns = ...
local Hekili = _G[ addon ]
local class, state = Hekili.Class, Hekili.State

local GetWeaponEnchantInfo = GetWeaponEnchantInfo
local strformat = string.format

local spec = Hekili:NewSpecialization( 262 )

spec:RegisterResource( Enum.PowerType.Maelstrom )
spec:RegisterResource( Enum.PowerType.Mana )

spec:RegisterTalents( {
    -- Shaman Talents
    ancestral_defense            = { 92682, 382947, 1 }, -- Increases Leech by $s2% and reduces damage taken from area-of-effect attacks by $s1%.
    ancestral_guidance           = { 81102, 108281, 1 }, -- For the next $d, $s1% of your healing done and $s2% of your damage done is converted to healing on up to $s4 nearby injured party or raid members, up to ${$MHP*$s3/100} healing to each target per second.
    ancestral_wolf_affinity      = { 81058, 382197, 1 }, -- Cleanse Spirit, Wind Shear, Purge, and totem casts no longer cancel Ghost Wolf.
    astral_bulwark               = { 81056, 377933, 1 }, -- Astral Shift reduces damage taken by an additional $s1%.
    astral_shift                 = { 81057, 108271, 1 }, -- Shift partially into the elemental planes, taking $s1% less damage for $d.
    brimming_with_life           = { 81085, 381689, 1 }, -- Maximum health increased by $s1%, and while you are at full health, Reincarnation cools down $381684s1% faster.;
    call_of_the_elements         = { 81090, 383011, 1 }, -- Reduces the cooldown of $@spellname108285 by ${$s1/-1000} sec.
    capacitor_totem              = { 81071, 192058, 1 }, -- Summons a totem at the target location that gathers electrical energy from the surrounding air and explodes after $s2 sec, stunning all enemies within $118905A1 yards for $118905d.
    chain_heal                   = { 81063, 1064  , 1 }, -- Heals the friendly target for $s1, then jumps up to $?a236502[${$s3*(($236502s2/100)+1)}][$s3] yards to heal the $<jumps> most injured nearby allies. Healing is reduced by $s2% with each jump.
    chain_lightning              = { 81061, 188443, 1 }, -- Hurls a lightning bolt at the enemy, dealing $s1 Nature damage and then jumping to additional nearby enemies. Affects $x1 total targets.$?s187874[; If Chain Lightning hits more than 1 target, each target hit by your Chain Lightning increases the damage of your next Crash Lightning by $333964s1%.][]$?s187874[; Each target hit by Chain Lightning reduces the cooldown of Crash Lightning by ${$s3/1000}.1 sec.][]$?a343725[; Generates $343725s5 Maelstrom per target hit.][]
    creation_core                = { 81090, 383012, 1 }, -- $@spellname108285 affects an additional totem.
    earth_elemental              = { 81064, 198103, 1 }, -- Calls forth a Greater Earth Elemental to protect you and your allies for $188616d.; While this elemental is active, your maximum health is increased by $381755s1%.
    earth_shield                 = { 81106, 974   , 1 }, -- Protects the target with an earthen shield, increasing your healing on them by $s1% and healing them for ${$379s1*(1+$s1/100)} when they take damage. This heal can only occur once every few seconds. Maximum $n charges.; $?s383010[Earth Shield can only be placed on the Shaman and one other target at a time. The Shaman can have up to two Elemental Shields active on them.][Earth Shield can only be placed on one target at a time. Only one Elemental Shield can be active on the Shaman.]
    earthgrab_totem              = { 81082, 51485 , 1 }, -- Summons a totem at the target location for $d. The totem pulses every $116943t1 sec, rooting all enemies within $64695A1 yards for $64695d. Enemies previously rooted by the totem instead suffer $116947s1% movement speed reduction.
    elemental_orbit              = { 81105, 383010, 1 }, -- Increases the number of Elemental Shields you can have active on yourself by 1.; You can have Earth Shield on yourself and one ally at the same time.
    elemental_warding            = { 81084, 381650, 2 }, -- Reduces all magic damage taken by $s1%.
    enfeeblement                 = { 81078, 378079, 1 }, -- Your Hex target is slowed by $378080s1% during Hex and for $378080d after it ends.
    fire_and_ice                 = { 81067, 382886, 1 }, -- Increases all Fire and Frost damage you deal by $s1%.
    flurry                       = { 81059, 382888, 1 }, -- Increases your attack speed by $382889s1% for your next $382889n melee swings after dealing a critical strike with a spell or ability.
    frost_shock                  = { 81074, 196840, 1 }, -- Chills the target with frost, causing $s1 Frost damage and reducing the target's movement speed by $s2% for $d.
    go_with_the_flow             = { 81089, 381678, 2 }, -- Reduces the cooldown of Spirit Walk by ${$s1/-1000} sec.; Reduces the cooldown of Gust of Wind by ${$s2/-1000} sec.;
    graceful_spirit              = { 81065, 192088, 1 }, -- Reduces the cooldown of Spiritwalker's Grace by ${$m1/-1000} sec and increases your movement speed by $s2% while it is active.
    greater_purge                = { 81076, 378773, 1 }, -- Purges the enemy target, removing $m1 beneficial Magic effects.
    guardians_cudgel             = { 81070, 381819, 1 }, -- When Capacitor Totem fades or is destroyed, another Capacitor Totem is automatically dropped in the same place.
    gust_of_wind                 = { 81088, 192063, 1 }, -- A gust of wind hurls you forward.
    healing_stream_totem         = { 81100, 392915, 1 }, -- $@spelltooltip5394
    hex                          = { 81079, 51514 , 1 }, -- Transforms the enemy into a frog for $d. While hexed, the victim is incapacitated, and cannot attack or cast spells. Damage may cancel the effect. Limit 1. Only works on Humanoids and Beasts.
    lava_burst                   = { 81062, 51505 , 1 }, -- Hurls molten lava at the target, dealing $285452s1 Fire damage. Lava Burst will always critically strike if the target is affected by Flame Shock.$?a343725[; Generates $343725s3 Maelstrom.][]
    lightning_lasso              = { 81096, 305483, 1 }, -- Grips the target in lightning, stunning and dealing $305485o1 Nature damage over $305485d while the target is lassoed. Can move while channeling.
    maelstrom_weapon             = { 81060, 187880, 1 }, -- When you deal damage with a melee weapon, you have a chance to gain Maelstrom Weapon, stacking up to $344179u times. Each stack of Maelstrom Weapon reduces the cast time of your next damage or healing spell by $187881s1%$?s383303[ and increase its damage by $187881s2% or its healing by $187881s3%][].; A maximum of $s2 stacks of Maelstrom Weapon can be consumed at a time.
    mana_spring                  = { 81103, 381930, 1 }, -- Your $?!s137041[Lava Burst][]$?s137039[ and Riptide][]$?s137041[Stormstrike][] casts restore $?a137040[$381931s1]?a137041[$404550s1][$404551s1] mana to you and $s1 allies nearest to you within $s2 yards.; Allies can only benefit from one Shaman's Mana Spring effect at a time, prioritizing healers.
    natures_fury                 = { 81086, 381655, 2 }, -- Increases the critical strike chance of your Nature spells and abilities by $s1%.
    natures_guardian             = { 81081, 30884 , 2 }, -- When your health is brought below $s1%, you instantly heal for ${$31616s1*(1+$s2/100)}% of your maximum health.  Cannot occur more than once every $proccooldown sec.
    natures_swiftness            = { 81099, 378081, 1 }, -- Your next healing or damaging Nature spell is instant cast and costs no mana.
    planes_traveler              = { 81056, 381647, 1 }, -- Reduces the cooldown of Astral Shift by ${$s1/-1000} sec.
    poison_cleansing_totem       = { 81093, 383013, 1 }, -- Summons a totem at your feet that removes all Poison effects from a nearby party or raid member within $403922a yards every $383014t1 sec for $d.
    purge                        = { 81076, 370   , 1 }, -- Purges the enemy target, removing $m1 beneficial Magic $leffect:effects;.$?(s147762&s51530); [ Successfully purging a target grants a stack of Maelstrom Weapon.][]
    spirit_walk                  = { 81088, 58875 , 1 }, -- Removes all movement impairing effects and increases your movement speed by $58875s1% for $58875d.
    spirit_wolf                  = { 81072, 260878, 1 }, -- While transformed into a Ghost Wolf, you gain $260881s1% increased movement speed and $260881s2% damage reduction every $260882t1 sec, stacking up to $260881u times.
    spiritwalkers_aegis          = { 81065, 378077, 1 }, -- When you cast Spiritwalker's Grace, you become immune to Silence and Interrupt effects for $378078d.
    spiritwalkers_grace          = { 81066, 79206 , 1 }, -- Calls upon the guidance of the spirits for $d, permitting movement while casting Shaman spells. Castable while casting.$?a192088[ Increases movement speed by $192088s2%.][]
    static_charge                = { 81070, 265046, 1 }, -- Reduces the cooldown of Capacitor Totem by $s1 sec for each enemy it stuns, up to a maximum reduction of $s2 sec.
    stoneskin_totem              = { 81095, 383017, 1 }, -- Summons a totem at your feet for $d that grants $383018s1% physical damage reduction to you and the $s1 allies nearest to the totem within $?s382201[${$s2*(1+$382201s3/100)}][$s2] yards.
    surging_shields              = { 81092, 382033, 2 }, -- Increases the damage dealt by Lightning Shield by $s3%$?s137040[ and causes it to generate an additional $s1 Maelstrom when triggered][]$?s137041[ and it has an additional $s2% chance to trigger Maelstrom Weapon when triggered][].; Increases the healing done by Earth Shield by $s4%.; $?s137039[Increases the amount of mana recovered when Water Shield is triggered by $s5%.][]
    swirling_currents            = { 81101, 378094, 2 }, -- Increases the healing done by Healing Stream Totem$?a137039[ and Cloudburst Totem by $s1]?a137040[ by ${$s1*(1+$137040s21/100)}][ by ${$s1*(1+$137041s17/100)}]%.
    thunderous_paws              = { 81072, 378075, 1 }, -- Ghost Wolf removes snares and increases your movement speed by an additional $s1% for the first $338036d. May only occur once every $proccooldown sec.
    thundershock                 = { 81096, 378779, 1 }, -- Thunderstorm knocks enemies up instead of away and its cooldown is reduced by ${$s1/-1000} sec.
    thunderstorm                 = { 81097, 51490 , 1 }, -- Calls down a bolt of lightning, dealing $s1 Nature damage to all enemies within $A1 yards, reducing their movement speed by $s3% for $d, and knocking them $?s378779[upward][away from the Shaman]. Usable while stunned.
    totemic_focus                = { 81094, 382201, 2 }, -- Increases the radius of your totem effects by $s3%.; Increases the duration of your Earthbind and Earthgrab Totems by ${$s1/1000} sec.; Increases the duration of your $?s157153[Cloudburst][Healing Stream], Tremor, Poison Cleansing, $?s137039[Ancestral Protection, Earthen Wall, ][]and Wind Rush Totems by ${$s2/1000}.1 sec.
    totemic_projection           = { 81080, 108287, 1 }, -- Relocates your active totems to the specified location.
    totemic_recall               = { 81091, 108285, 1 }, -- Resets the cooldown of your most recently used totem with a base cooldown shorter than 3 minutes.
    totemic_surge                = { 81104, 381867, 2 }, -- Reduces the cooldown of your totems by ${$s1/-1000} sec.
    tranquil_air_totem           = { 81095, 383019, 1 }, -- Summons a totem at your feet for $d that prevents cast pushback and reduces the duration of all incoming interrupt effects by $383020s2% for you and the $s1 allies nearest to the totem within $?s382201[${$s2*(1+$382201s3/100)}][$s2] yards.
    tremor_totem                 = { 81069, 8143  , 1 }, -- Summons a totem at your feet that shakes the ground around it for $d, removing Fear, Charm and Sleep effects from party and raid members within $8146a1 yards.
    voodoo_mastery               = { 81078, 204268, 1 }, -- Reduces the cooldown of Hex by ${($m1/1000)*-1} sec.
    wind_rush_totem              = { 81082, 192077, 1 }, -- Summons a totem at the target location for $d, continually granting all allies who pass within $a1 yards $192082s1% increased movement speed for $192082d.
    wind_shear                   = { 81068, 57994 , 1 }, -- Disrupts the target's concentration with a burst of wind, interrupting spellcasting and preventing any spell in that school from being cast for $d.
    winds_of_alakir              = { 81087, 382215, 2 }, -- Increases the movement speed bonus of Ghost Wolf by $s3%.; When you have $s4 or more totems active, your movement speed is increased by $s2%.

    -- Elemental Talents
    aftershock                   = { 81000, 273221, 1 }, -- Earth Shock, Elemental Blast, and Earthquake have a $s1% chance to refund all Maelstrom spent.
    ascendance                   = { 81003, 114050, 1 }, -- Transform into a Flame Ascendant for $d, replacing Chain Lightning with Lava Beam, removing the cooldown on Lava Burst, and increasing the damage of Lava Burst by an amount equal to your critical strike chance.; When you transform into the Flame Ascendant, instantly cast a Lava Burst at all enemies affected by your Flame Shock, and refresh your Flame Shock durations to $188389d.
    call_of_fire                 = { 81011, 378255, 1 }, -- Increases the damage of your Flame Shock, Lava Burst, Lava Beam, and Fire Elemental by $s1%.
    call_of_thunder              = { 80987, 378241, 1 }, -- Increases the damage of your Lightning Bolt$?c3[ and Chain Lightning] ?c1[, Chain Lightning, and Storm Elemental] by $s1%.
    cleanse_spirit               = { 81075, 51886 , 1 }, -- Removes all Curse effects from a friendly target.
    deeply_rooted_elements       = { 81003, 378270, 1 }, -- [114052] Transform into a Water Ascendant, duplicating all healing you deal at $s4% effectiveness for $114051d and immediately healing for $294020s1. Ascendant healing is distributed evenly among allies within $114083A1 yds.
    earth_shock                  = { 80984, 8042  , 1 }, -- Instantly shocks the target with concussive force, causing $s1 Nature damage.$?a190493[; Earth Shock will consume all stacks of Fulmination to deal extra Nature damage to your target.][]
    earthquake                   = { 80985, 61882 , 1 }, -- Causes the earth within $a1 yards of the target location to tremble and break, dealing $<damage> Physical damage over $d and has a $?s381743[${$77478s2+$381743S1)}.1][$77478s2]% chance to knock the enemy down. Multiple uses of Earthquake may overlap.
    echo_chamber                 = { 81013, 382032, 2 }, -- Increases the damage dealt by your Elemental Overloads by $s1%.
    echo_of_the_elements         = { 80999, 333919, 1 }, -- $?s137039[Riptide and Lava Burst have][Lava Burst has] an additional charge.
    echoes_of_great_sundering    = { 80991, 384087, 2 }, -- After casting Earth Shock, your next Earthquake deals $s1% additional damage.; After casting Elemental Blast, your next Earthquake deals $s2% additional damage.
    electrified_shocks           = { 80996, 382086, 1 }, -- Icefury causes your Frost Shocks to damage up to $s1 additional enemies and targets hit take $382089s1% increased Nature damage from your spells for $382089d.
    elemental_blast              = { 80994, 117014, 1 }, -- Harnesses the raw power of the elements, dealing $s1 Elemental damage and increasing your Critical Strike or Haste by $118522s1% or Mastery by ${$173184s1*$168534bc1}% for $118522d.$?s137041[; If Lava Burst is known, Elemental Blast replaces Lava Burst and gains $394152s2 additional $Lcharge:charges;.][]
    elemental_equilibrium        = { 80993, 378271, 2 }, -- Dealing direct Fire, Frost, and Nature damage within $378272d will increase all damage dealt by $s4% for $378275d. This can only occur once every $378277d.
    elemental_fury               = { 80983, 60188 , 1 }, -- Your damaging $?a343190[and healing ][]critical strikes deal ${$m1+200}% damage $?a343190[or healing ][]instead of the usual 200%.
    eye_of_the_storm             = { 80995, 381708, 2 }, -- Reduces the Maelstrom cost of Earth Shock and Earthquake by $s1.; Reduces the Maelstrom cost of Elemental Blast by $s3.
    fire_elemental               = { 80981, 198067, 1 }, -- Calls forth a Greater Fire Elemental to rain destruction on your enemies for $188592d. ; While the Fire Elemental is active, Flame Shock deals damage ; ${100*(1/(1+$188592s2/100)-1)}% faster, and newly applied Flame Shocks last $188592s3% longer.
    flames_of_the_cauldron       = { 81010, 378266, 1 }, -- Reduces the cooldown of Flame Shock by ${$s2/-1000}.1 sec and Flame Shock deals damage ${100*(1/(1+$m1/100)-1)}% faster.
    flash_of_lightning           = { 80990, 381936, 1 }, -- Casting Lightning Bolt or Chain Lightning reduces the cooldown of your Nature spells by ${$381937s1/-1000}.1 sec.
    flow_of_power                = { 80998, 385923, 1 }, -- Increases the Maelstrom generated by Lightning Bolt and Lava Burst by $s3, and their Elemental Overloads by $s4.
    flux_melting                 = { 80996, 381776, 1 }, -- Casting Frost Shock increases the damage of your next Lava Burst by $381777s1%.
    focused_insight              = { 80982, 381666, 1 }, -- Casting Flame Shock reduces the mana cost of your next heal by $s2% and increases its healing effectiveness by $?s137039[${$s5/10}.1][$s3]%.
    further_beyond               = { 81001, 381787, 1 }, -- Casting Earth Shock or Earthquake while Ascendance is active extends the duration of Ascendance by ${$s1/1000}.1 sec.; Casting Elemental Blast while Ascendance is active extends the duration of Ascendance by ${$s2/1000}.1 sec.; Ascendance can only be extended up to $s3% of its original duration.
    icefury                      = { 80997, 210714, 1 }, -- Hurls frigid ice at the target, dealing $s1 Frost damage and causing your next $n Frost Shocks to deal $s2% increased damage and generate $343725s7 Maelstrom.; Generates $343725s8 Maelstrom.
    improved_flametongue_weapon  = { 81009, 382027, 1 }, -- Imbuing your weapon with Flametongue increases your Fire spell damage by 5% for 1 hour.
    inundate                     = { 80986, 378776, 1 }, -- Your successful Purge, Cleanse Spirit, Healing Stream Totem, Hex, and Wind Shear casts generate $378777s1 Maelstrom during combat.
    lava_surge                   = { 80979, 77756 , 1 }, -- $?a408572[; Your Flame Shock damage over time has a $<chance>% chance to reduce the cast time of your next Lightning Bolt, Chain Lightning, or Lava Burst by $408575s1%, stacking up to $408575U times.; ][Your Flame Shock damage over time has a $<chance>% chance to reset the remaining cooldown on Lava Burst and cause your next Lava Burst to be instant.]
    lightning_rod                = { 80992, 210689, 1 }, -- Earth Shock, Elemental Blast, and Earthquake make your target a Lightning Rod for $197209d. Lightning Rods take $s2% of all damage you deal with Lightning Bolt and Chain Lightning.
    liquid_magma_totem           = { 81008, 192222, 1 }, -- Summons a totem at the target location that erupts dealing $383061s1 Fire damage and applying Flame Shock to $383061s2 enemies within $383061A1 yards. Continues hurling liquid magma at a random nearby target every $192226t1 sec for $d, dealing ${$192231s1*(1+($137040s3/100))} Fire damage to all enemies within $192223A1 yards.;
    magma_chamber                = { 81007, 381932, 2 }, -- Flame Shock damage increases the damage of your next Earth Shock, Elemental Blast, or Earthquake by ${$S2/10}.1%, stacking up to $381933u times.
    master_of_the_elements       = { 81004, 16166 , 2 }, -- Casting Lava Burst increases the damage or healing of your next Nature$?a137039[][, Physical,] or Frost spell by $s2%.
    mountains_will_fall          = { 81012, 381726, 1 }, -- Earth Shock, Elemental Blast, and Earthquake can trigger your Mastery: Elemental Overload at $s1% effectiveness.; Overloaded Earthquakes do not knock enemies down.
    oath_of_the_far_seer         = { 81002, 381785, 2 }, -- Reduces the cooldown of Ascendance by ${$s2/-1000} sec, and you gain $s1% additional Haste while Ascendance is active.
    power_of_the_maelstrom       = { 81015, 191861, 2 }, -- Casting Lava Burst has a $s2% chance to cause your next $191877n Lightning Bolt or Chain Lightning casts to trigger Elemental Overload an additional time.
    primal_elementalist          = { 81008, 117013, 1 }, -- Your Earth, Fire, and Storm Elementals are drawn from primal elementals $s1% more powerful than regular elementals, with additional abilities, and you gain direct control over them.
    primordial_bond              = { 80980, 381764, 1 }, -- [381761] While you have an elemental active, your damage taken is reduced by $s1%.
    primordial_fury              = { 80982, 378193, 1 }, -- Your healing critical strikes heal for ${$m1+200}% healing instead of the usual 200%.;
    primordial_surge             = { 80978, 386474, 1 }, -- Casting Primordial Wave triggers $?a408572[Volcanic][Lava] Surge immediately and every $387622T sec for $387622d. $?a408572[Volcanic][Lava] Surges triggered by Primordial Wave increase the damage of your next Lava Burst by $396484s1%.
    primordial_wave              = { 81014, 375982, 1 }, -- Blast your target with a Primordial Wave, dealing $375984s1 Shadow damage and apply Flame Shock to them.; Your next $?a137040[Lava Burst]?a137041[Lightning Bolt][Healing Wave] will also hit all targets affected by your $?a137040|a137041[Flame Shock][Riptide] for $?a137039[$s2%]?a137040[$s3%][$s4%] of normal $?a137039[healing][damage].$?s384405[; Primordial Wave generates $s5 stacks of Maelstrom Weapon.][]
    refreshing_waters            = { 80980, 378211, 1 }, -- Your Healing Surge is $s1% more effective on yourself.;
    rolling_magma                = { 80977, 386443, 2 }, -- Lava Burst and Lava Burst Overload damage reduces the cooldown of Primordial Wave by ${$s1/-1000}.1 sec.
    searing_flames               = { 81005, 381782, 2 }, -- Flame Shock damage has a $s2% chance to generate $s1 Maelstrom.
    skybreakers_fiery_demise     = { 81006, 378310, 1 }, -- Flame Shock damage over time critical strikes reduce the cooldown of your Fire and Storm Elemental by $?s192249[${$m1/1000}.1][${$m2/1000}.1] sec, and Flame Shock has a $s3% increased critical strike chance.
    splintered_elements          = { 80978, 382042, 1 }, -- Primordial Wave grants you $s1% Haste plus $s2% for each additional $?a137039[Healing Wave]?a137040[Lava Burst][Lightning Bolt] generated by Primordial Wave for $382043d.
    storm_elemental              = { 80981, 192249, 1 }, -- Calls forth a Greater Storm Elemental to hurl gusts of wind that damage the Shaman's enemies for $157299d.; While the Storm Elemental is active, each time you cast Lightning Bolt or Chain Lightning, the cast time of Lightning Bolt and Chain Lightning is reduced by $263806s1%, stacking up to $263806u times.
    stormkeeper                  = { 80989, 392714, 1 }, -- $@spelltooltip191634
    surge_of_power               = { 81000, 262303, 1 }, -- Earth Shock, Elemental Blast, and Earthquake enhance your next spell cast within $285514d:; Flame Shock: The next cast also applies Flame Shock to $287185s1 additional target within $287185A1 yards of the target.; Lightning Bolt: Your next cast will cause $s2 additional Elemental Overload$L$:s;.; Chain Lightning: Your next cast will chain to $s4 additional target.; Lava Burst: Reduces the cooldown of your Fire and Storm Elemental by ${$m1/1000}.1 sec.; Frost Shock: Freezes the target in place for $285515d.
    swelling_maelstrom           = { 81016, 381707, 1 }, -- Increases your maximum Maelstrom by $s1.
    tumultuous_fissures          = { 80986, 381743, 1 }, -- Increases the chance for Earthquake to knock enemies down by ${$s1}.1%.;
    unrelenting_calamity         = { 80988, 382685, 1 }, -- Reduces the cast time of Lightning Bolt and Chain Lightning by ${$s1/-1000}.2 sec.; Increases the duration of Earthquake by ${$s2/1000} sec.
    windspeakers_lava_resurgence = { 81006, 378268, 1 }, -- When you cast Earth Shock, Elemental Blast, or Earthquake, gain $?a408572[Volcanic][Lava] Surge and increase the damage of your next Lava Burst by $378269s1%.
} )

-- PvP Talents
spec:RegisterPvpTalents( {
    burrow              = 5574, -- (409293) Burrow beneath the ground, becoming unattackable, removing movement impairing effects, and increasing your movement speed by ${$s3-100}% for $d.; When the effect ends, enemies within $409304A1 yards are knocked in the air and take $<damage> Physical damage.
    counterstrike_totem = 3490, -- (204331) Summons a totem at your feet for $d.; Whenever enemies within $?s382201[${$s2*(1+$382201s3/100)}][$s2] yards of the totem deal direct damage, the totem will deal $208997s1% of the damage dealt back to attacker.
    grounding_totem     = 3620, -- (204336) Summons a totem at your feet that will redirect all harmful spells cast within $8178A1 yards on a nearby party or raid member to itself. Will not redirect area of effect spells. Lasts $d.
    seasoned_winds      = 5415, -- (355630) Interrupting a spell with Wind Shear decreases your damage taken from that spell school by $s1% for $355634d. Stacks up to $355634U times.
    skyfury_totem       = 3488, -- (204330) Summons a totem at your feet for $d that increases the critical effect of damage and healing spells of all nearby allies within $?s382201[${$s2*(1+$382201s3/100)}][$s2] yards by $208963s1% for $208963d.
    static_field_totem  = 727, -- (355580) Summons a totem with $s2% of your health at the target location for $d that forms a circuit of electricity that enemies cannot pass through.
    traveling_storms    = 730, -- (204403) Thunderstorm now can be cast on allies within $204406r yards, reduces enemies movement speed by $204408s3% and knocks enemies $s2% further.; Thundershock knocks enemies $s3% higher.
    unleash_shield      = 3491, -- (356736) Unleash your Elemental Shield's energy on an enemy target:; $@spellicon192106$@spellname192106: Knocks them away.; $@spellicon974$@spellname974: Roots them in place for $356738d.; $@spellicon52127$@spellname52127: Summons a whirlpool for $356739d, reducing damage and healing by $356824s1% while they stand within it.
    volcanic_surge      = 5571, -- (408572) Increases the damage of Lightning Bolt and Chain Lightning by $s1% and the damage of Lava Burst by $s4%.; Lava Surge has an additional $s2% chance to trigger and instead reduces the cast time of your next Lightning Bolt or Chain Lightning by $408575s1%, stacking up to $408575U times.
} )


-- Auras
spec:RegisterAuras( {
    -- Talent: A percentage of damage or healing dealt is copied as healing to up to 3 nearby injured party or raid members.
    -- https://wowhead.com/beta/spell=108281
    ancestral_guidance = {
        id = 108281,
        duration = 10,
        tick_time = 0.5,
        max_stack = 1
    },
    -- Health increased by $s1%.    If you die, the protection of the ancestors will allow you to return to life.
    -- https://wowhead.com/beta/spell=207498
    ancestral_protection = {
        id = 207498,
        duration = 30,
        max_stack = 1
    },
    -- Talent: Transformed into a powerful Fire ascendant. Chain Lightning is transformed into Lava Beam.
    -- https://wowhead.com/beta/spell=114050
    ascendance = {
        id = 114050,
        duration = 15,
        max_stack = 1,
        copy = { 114051, 114052 }
    },
    -- Talent: Damage taken reduced by $w1%.
    -- https://wowhead.com/beta/spell=108271
    astral_shift = {
        id = 108271,
        duration = 12,
        max_stack = 1
    },
    -- Haste increased by $w1%.
    -- https://wowhead.com/beta/spell=2825
    bloodlust = {
        id = 2825,
        duration = 40,
        max_stack = 1,
        shared = "player",
        copy = { 32182, "heroism" }
    },
    -- Chance to activate Windfury Weapon increased to ${$319773h}.1%.  Damage dealt by Windfury Weapon increased by $s2%.
    -- https://wowhead.com/beta/spell=384352
    doom_winds = {
        id = 384352,
        duration = 8,
        max_stack = 1
    },
    -- Talent:
    -- https://wowhead.com/beta/spell=198103
    earth_elemental = {
        id = 198103,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Heals for ${$w2*(1+$w1/100)} upon taking damage.
    -- https://wowhead.com/beta/spell=974
    earth_shield = {
        id = function () return talent.elemental_orbit.enabled and 383648 or 974 end,
        duration = 600,
        type = "Magic",
        max_stack = 9,
        dot = "buff",
        shared = "player",
        copy = { 383648, 974 }
    },
    -- Movement speed reduced by $s1%.
    -- https://wowhead.com/beta/spell=3600
    earthbind = {
        id = 3600,
        duration = 5,
        mechanic = "snare",
        type = "Magic",
        max_stack = 1
    },
    -- Rooted.
    -- https://wowhead.com/beta/spell=64695
    earthgrab = {
        id = 64695,
        duration = 8,
        mechanic = "root",
        type = "Magic",
        max_stack = 1
    },
    -- Heals $w1 every $t1 sec.
    -- https://wowhead.com/beta/spell=382024
    earthliving_weapon = {
        id = 382024,
        duration = 12,
        max_stack = 1
    },
    echoes_of_great_sundering = {
        id = 384088,
        duration = 25,
        max_stack = 1,
        copy = 336217
    },
    -- Your next damage or healing spell will be cast a second time ${$s2/1000}.1 sec later for free.
    -- https://wowhead.com/beta/spell=320125
    echoing_shock = {
        id = 320125,
        duration = 8,
        type = "Magic",
        max_stack = 1
    },
    elemental_blast = {
        alias = { "elemental_blast_critical_strike", "elemental_blast_haste", "elemental_blast_mastery" },
        aliasMode = "first", -- use duration info from the first buff that's up, as they should all be equal.
        aliasType = "buff",
    },
    electrified_shocks = {
        id = 382089,
        duration = 9,
        type = "Magic",
        max_stack = 1
    },
    elemental_blast_critical_strike = {
        id = 118522,
        duration = 10,
        type = "Magic",
        pandemic = true,
        max_stack = 1,
    },
    elemental_blast_haste = {
        id = 173183,
        duration = 10,
        type = "Magic",
        pandemic = true,
        max_stack = 1,
    },
    elemental_blast_mastery = {
        id = 173184,
        duration = 10,
        type = "Magic",
        pandemic = true,
        max_stack = 1,
    },
    -- Talent: Damage dealt increased by $s1%.
    -- https://wowhead.com/beta/spell=378275
    elemental_equilibrium = {
        id = 378275,
        duration = 10,
        max_stack = 1,
        copy = 347348
    },
    elemental_equilibrium_debuff = {
        id = 378277,
        duration = 30,
        max_stack = 1,
        copy = 347349,
    },
    enfeeblement = {
        id = 378080,
        duration = 6,
        max_stack = 1
    },
    -- Cannot move while using Far Sight.
    -- https://wowhead.com/beta/spell=6196
    far_sight = {
        id = 6196,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: $188592s2%
    -- https://wowhead.com/beta/spell=198067
    fire_elemental = {
        id = 198067,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Suffering $w2 Fire damage every $t2 sec.
    -- https://wowhead.com/beta/spell=188389
    flame_shock = {
        id = 188389,
        duration = 18,
        tick_time = function() return 2 * haste * ( talent.flame_of_the_cauldron.enabled and 0.85 or 1 ) end,
        type = "Magic",
        max_stack = 1
    },
    -- Each of your weapon attacks causes up to ${$max(($<coeff>*$AP),1)} additional Fire damage.
    -- https://wowhead.com/beta/spell=319778
    flametongue_weapon = {
        id = 319778,
        duration = 3600,
        max_stack = 1
    },
    -- Talent: Attack speed increased by $w1%.
    -- https://wowhead.com/beta/spell=382889
    flurry = {
        id = 382889,
        duration = 15,
        max_stack = 3
    },
    -- Talent: Your next Lava Burst will deal $s1% increased damage.
    -- https://wowhead.com/beta/spell=381777
    flux_melting = {
        id = 381777,
        duration = 12,
        max_stack = 1
    },
    -- Talent: The mana cost of your next heal is reduced by $w1% and its effectiveness is increased by $?s137039[${$W2}.1][$w2]%.
    -- https://wowhead.com/beta/spell=381668
    focused_insight = {
        id = 381668,
        duration = 12,
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $s2%.
    -- https://wowhead.com/beta/spell=196840
    frost_shock = {
        id = 196840,
        duration = 6,
        type = "Magic",
        max_stack = 1
    },
    -- Increases movement speed by $?s382215[${$382216s1+$w2}][$w2]%.$?$w3!=0[  Less hindered by effects that reduce movement speed.][]
    -- https://wowhead.com/beta/spell=2645
    ghost_wolf = {
        id = 2645,
        duration = 3600,
        type = "Magic",
        max_stack = 1
    },
    -- Your next Frost Shock will deal $s1% additional damage, and hit up to ${$334195s1/$s2} additional $Ltarget:targets;.
    -- https://wowhead.com/beta/spell=334196
    hailstorm = {
        id = 334196,
        duration = 20,
        max_stack = 5
    },
    -- Your Healing Rain is currently active.  $?$w1!=0[Magic damage taken reduced by $w1%.][]
    -- https://wowhead.com/beta/spell=73920
    healing_rain = {
        id = 73920,
        duration = 10,
        max_stack = 1
    },
    -- Healing $?s147074[two injured party or raid members][an injured party or raid member] every $t1 sec.
    -- https://wowhead.com/beta/spell=5672
    healing_stream = {
        id = 5672,
        duration = 15,
        tick_time = 2,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Incapacitated.
    -- https://wowhead.com/beta/spell=51514
    hex = {
        id = 51514,
        duration = 60,
        mechanic = "polymorph",
        type = "Magic",
        max_stack = 1
    },
    -- Movement speed reduced by $s2%.
    -- https://wowhead.com/beta/spell=342240
    ice_strike = {
        id = 342240,
        duration = 6,
        max_stack = 1
    },
    -- Talent: Frost Shock damage increased by $w2%.
    -- https://wowhead.com/beta/spell=210714
    icefury = {
        id = 210714,
        duration = 25,
        type = "Magic",
        max_stack = 4
    },
    -- Fire damage inflicted every $t2 sec.
    -- https://wowhead.com/beta/spell=118297
    immolate = {
        id = 118297,
        duration = 21,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Your next Lava Burst casts instantly.
    -- https://wowhead.com/beta/spell=77762
    lava_surge = {
        id = 77762,
        duration = 10,
        max_stack = 1
    },
    -- Talent: Stunned. Suffering $w1 Nature damage every $t1 sec.
    -- https://wowhead.com/beta/spell=305485
    lightning_lasso = {
        id = 305485,
        duration = 5,
        tick_time = 1,
        mechanic = "stun",
        type = "Magic",
        max_stack = 1
    },
    lightning_rod = {
        id = 197209,
        duration = 8,
        max_stack = 1
    },
    -- Chance to deal $192109s1 Nature damage when you take melee damage$?a137041[ and have a $s3% chance to generate a stack of Maelstrom Weapon]?a137040[ and have a $s4% chance to generate $s5 Maelstrom][].
    -- https://wowhead.com/beta/spell=192106
    lightning_shield = {
        id = 192106,
        duration = 1800,
        max_stack = 1
    },
    -- Talent: Flame Shock damage increases the damage of your next Earth Shock, Elemental Blast, or Earthquake by 0.8%, stacking up to 20 times.
    -- https://www.wowhead.com/beta/spell=381933
    magma_chamber = {
        id = 381933,
        duration = 20,
        type = "magic",
        max_stack = 20
    },
    --[[ Removed in 10.0.5 -- Talent:
    -- https://wowhead.com/beta/spell=381930
    mana_spring_totem = {
        id = 381930,
        duration = 120,
        type = "Magic",
        max_stack = 1
    }, ]]
    -- Talent: Your next Nature, Physical, or Frost spell will deal $s1% increased damage or healing.
    -- https://wowhead.com/beta/spell=260734
    master_of_the_elements = {
        id = 260734,
        duration = 15,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Your next healing or damaging Nature spell is instant cast and costs no mana.
    -- https://wowhead.com/beta/spell=378081
    natures_swiftness = {
        id = 378081,
        duration = 3600,
        type = "Magic",
        max_stack = 1,
        onRemove = function( t )
            setCooldown( "natures_swiftness", action.natures_swiftness.cooldown )
        end
    },
    -- Heals $w1 damage every $t1 seconds.
    -- https://wowhead.com/beta/spell=280205
    pack_spirit = {
        id = 280205,
        duration = 3600,
        max_stack = 1
    },
    -- Cleansing $383015s1 poison effect from a nearby party or raid member every $t1 sec.
    -- https://wowhead.com/beta/spell=383014
    poison_cleansing = {
        id = 383014,
        duration = 6,
        tick_time = 1.5,
        type = "Magic",
        max_stack = 1
    },
    -- Talent: Lightning Bolt and Chain Lightning will trigger Elemental Overload an additional time.
    -- https://wowhead.com/beta/spell=191877
    power_of_the_maelstrom = {
        id = 191877,
        duration = 20,
        max_stack = 2
    },
    -- Heals $w2 every $t2 seconds.
    -- https://wowhead.com/beta/spell=61295
    riptide = {
        id = 61295,
        duration = 18,
        type = "Magic",
        max_stack = 1
    },
    spirit_wolf = {
        id = 260881,
        duration = 3600,
        max_stack = 4
    },
    -- Talent: Increases movement speed by $s1%.
    -- https://wowhead.com/beta/spell=58875
    spirit_walk = {
        id = 58875,
        duration = 8,
        max_stack = 1
    },
    -- Talent: Immune to Silence/Interrupt.
    -- https://wowhead.com/beta/spell=378078
    spiritwalkers_aegis = {
        id = 378078,
        duration = 5,
        max_stack = 1
    },
    -- Talent: Able to move while casting all Shaman spells.
    -- https://wowhead.com/beta/spell=79206
    spiritwalkers_grace = {
        id = 79206,
        duration = 15,
        type = "Magic",
        max_stack = 1,
    },
    -- Talent
    splintered_elements = {
        id = 382043,
        duration = 12,
        max_stack = 10,
        copy = { 382042, 354648 } -- Old spell ID, just in case.
    },
    -- Talent: Stunned.
    -- https://wowhead.com/beta/spell=118905
    static_charge = {
        id = 118905,
        duration = 3,
        mechanic = "stun",
        type = "Magic",
        max_stack = 1
    },
    stoneskin = {
        id = 383018,
        duration = 15,
        max_stack = 1
    },
    -- Talent:
    -- https://wowhead.com/beta/spell=192249
    storm_elemental = {
        id = 192249,
        duration = 60,
        type = "Magic",
        max_stack = 1
    },
    -- Stormstrike cooldown has been reset$?$?a319930[ and will deal $319930w1% additional damage as Nature][].
    -- https://wowhead.com/beta/spell=201846
    stormbringer = {
        id = 201846,
        duration = 12,
        max_stack = 1
    },
    -- Talent: Your next Chain Lightning will deal $s2% increased damage and be instant cast.
    -- https://wowhead.com/beta/spell=320137
    stormkeeper = {
        -- Elemental: 191634
        -- Enhancement: 320137
        -- Restoration: 383009
        id = 191634,
        duration = 15,
        type = "Magic",
        max_stack = 2,
        copy = { 320137, 383009 }
    },
    -- Incapacitated.
    -- https://wowhead.com/beta/spell=197214
    sundering = {
        id = 197214,
        duration = 2,
        max_stack = 1
    },
    -- Talent: Your next spell cast will be enhanced.
    -- https://wowhead.com/beta/spell=285514
    surge_of_power = {
        id = 285514,
        duration = 15,
        max_stack = 1
    },
    surge_of_power_debuff = {
        id = 285515,
        duration = 6,
        max_stack = 1,
    },
    -- Talent: Your next Healing Surge$?s137039[, Healing Wave, or Riptide][] will be $w1% more effective.
    -- https://wowhead.com/beta/spell=378102
    swirling_currents = {
        id = 378102,
        duration = 15,
        type = "Magic",
        max_stack = 3,
        copy = 338340
    },
    -- Talent: Movement speed increased by $378075s1%.
    -- https://wowhead.com/beta/spell=378076
    thunderous_paws = {
        id = 378076,
        duration = 3,
        max_stack = 1
    },
    -- Talent: Movement speed reduced by $s3%.
    -- https://wowhead.com/beta/spell=51490
    thunderstorm = {
        id = 51490,
        duration = 5,
        type = "Magic",
        max_stack = 1
    },
    water_walking = {
        id = 546,
        duration = 600,
        max_stack = 1,
    },
    wind_rush = {
        id = 192082,
        duration = 5,
        max_stack = 1,
    },
    wind_gust = {
        id = 263806,
        duration = 30,
        max_stack = 20
    },
    -- Talent: Lava Burst damage increased by $s1%.
    -- https://wowhead.com/beta/spell=378269
    windspeakers_lava_resurgence = {
        id = 378269,
        duration = 15,
        max_stack = 1,
        copy = 336065
    },

    -- Pet aura.
    call_lightning = {
        duration = 15,
        generate = function( t, db )
            if storm_elemental.up then
                local name, _, count, _, duration, expires = FindUnitBuffByID( "pet", 157348 )

                if name then
                    t.count = count
                    t.expires = expires
                    t.applied = expires - duration
                    t.caster = "pet"
                    return
                end
            end

            t.count = 0
            t.expires = 0
            t.applied = 0
            t.caster = "nobody"
        end,
    },

    -- Conduit
    vital_accretion = {
        id = 337984,
        duration = 60,
        max_stack = 1
    },
} )


-- Pets
spec:RegisterPet( "primal_storm_elemental", 77942, "storm_elemental",
    function()
        if not talent.primal_elementalist.enabled then return 0 end
        return 30 * ( 1 + ( 0.01 * conduit.call_of_flame.mod ) )
    end )
spec:RegisterTotem( "greater_storm_elemental", 1020304 ) -- Texture ID

spec:RegisterPet( "primal_fire_elemental", 61029, "fire_elemental",
    function()
        if not talent.primal_elementalist.enabled then return 0 end
        return 30 * ( 1 + ( 0.01 * conduit.call_of_flame.mod ) )
    end )
spec:RegisterTotem( "greater_fire_elemental", 135790 ) -- Texture ID

spec:RegisterPet( "primal_earth_elemental", 61056, "earth_elemental",
    function()
        if not talent.primal_elementalist.enabled then return 0 end
        return 60
    end )
spec:RegisterTotem( "greater_earth_elemental", 136024 ) -- Texture ID

local elementals = {
    [77942] = { "primal_storm_elemental", function() return 30 * ( 1 + ( 0.01 * state.conduit.call_of_flame.mod ) ) end, true },
    [61029] = { "primal_fire_elemental", function() return 30 * ( 1 + ( 0.01 * state.conduit.call_of_flame.mod ) ) end, true },
    [61056] = { "primal_earth_elemental", function () return 60 end, false }
}

local death_events = {
    UNIT_DIED               = true,
    UNIT_DESTROYED          = true,
    UNIT_DISSIPATES         = true,
    PARTY_KILL              = true,
    SPELL_INSTAKILL         = true,
}

local summon = {}
local wipe = table.wipe

local vesper_heal = 0
local vesper_damage = 0
local vesper_used = 0

local vesper_expires = 0
local vesper_guid
local vesper_last_proc = 0

local recall_totems = {
    capacitor_totem = 1,
    earthbind_totem = 1,
    earthgrab_totem = 1,
    grounding_totem = 1,
    healing_stream_totem = 1,
    liquid_magma_totem = 1,
    poison_cleansing_totem = 1,
    skyfury_totem = 1,
    stoneskin_totem = 1,
    tranquil_air_totem = 1,
    tremor_totem = 1,
    wind_rush_totem = 1,
}

local ancestral_wolf_affinity_spells = {
    cleanse_spirit = 1,
    wind_shear = 1,
    purge = 1,
    -- TODO: List totems?
}

local recallTotem1
local recallTotem2

spec:RegisterStateExpr( "recall_totem_1", function()
    return recallTotem1
end )

spec:RegisterStateExpr( "recall_totem_2", function()
    return recallTotem2
end )

spec:RegisterHook( "runHandler", function( action )
    if buff.ghost_wolf.up then
        if talent.ancestral_wolf_affinity.enabled then
            local ability = class.abilities[ action ]
            if not ancestral_wolf_affinity_spells[ action ] and not ability.gcd == "totem" then
                removeBuff( "ghost_wolf" )
            end
        else
            removeBuff( "ghost_wolf" )
        end
    end

    if talent.totemic_recall.enabled and recall_totems[ action ] then
        recall_totem_2 = recall_totem_1
        recall_totem_1 = action
    end

    if talent.elemental_equilibrium.enabled and debuff.elemental_equilibrium_debuff.down then
        local ability = class.abilities[ action ]
        if ability and ability.startsCombat and ability.school then
            if ability.school == "fire" then last_ee_fire = query_time
            elseif ability.school == "frost" then last_ee_frost = query_time
            elseif ability.school == "nature" then last_ee_nature = query_time end

            if max( last_ee_fire, last_ee_frost, last_ee_nature ) - min( last_ee_fire, last_ee_frost, last_ee_nature ) < 10 then
                applyBuff( "elemental_equilibrium" )
                applyDebuff( "player", "elemental_equilibrium_debuff" )
            end
        end
    end
end )


local fireDamage, frostDamage, natureDamage = 0, 0, 0
local stormkeeperCastStart, stormkeeperLastProc = 0, 0

local further_beyond_duration_remains, fbSpells = 0, {
    earth_shock = 1,
    earthquake = 1,
    elemental_blast = 1,
    ascendance = 1
}
spec:RegisterStateExpr( "fb_extension_remaining", function()
    return further_beyond_duration_remains
end )

spec:RegisterCombatLogEvent( function( _, subtype, _,  sourceGUID, sourceName, _, _, destGUID, destName, destFlags, _, spellID, spellName, school )
    -- Deaths/despawns.
    if death_events[ subtype ] then
        if destGUID == summon.guid then
            wipe( summon )
        elseif destGUID == vesper_guid then
            vesper_guid = nil
        end
        return
    end

    if sourceGUID == state.GUID then
        -- Summons.
        if subtype == "SPELL_SUMMON" then
            local npcid = destGUID:match("(%d+)-%x-$")
            npcid = npcid and tonumber( npcid ) or -1
            local elem = elementals[ npcid ]

            if elem then
                summon.guid = destGUID
                summon.type = elem[1]
                summon.duration = elem[2]()
                summon.expires = GetTime() + summon.duration
                summon.extends = elem[3]
            end

            if spellID == 324386 then
                vesper_guid = destGUID
                vesper_expires = GetTime() + 30

                vesper_heal = 3
                vesper_damage = 3
                vesper_used = 0
            end

        --[[ Tier 28
        elseif summon.extends and state.set_bonus.tier28_4pc > 0 and subtype == "SPELL_ENERGIZE" and ( spellID == 51505 or spellID == 285466 ) then
            summon.expires = summon.expires + 1.5
            summon.duration = summon.duration + 1.5 ]]

        elseif spellID == 191634 then
            -- Stormkeeper.
            if subtype == "SPELL_CAST_START" then stormkeeperCastStart = GetTime()
            elseif subtype == "SPELL_CAST_SUCCESS" or subtype == "SPELL_CAST_FAILED" then stormkeeperCastStart = 0
            elseif subtype == "SPELL_AURA_APPLIED" and stormkeeperCastStart == 0 then
                stormkeeperLastProc = GetTime()
            end

        -- Vesper Totem heal
        elseif spellID == 324522 then
            local now = GetTime()

            if vesper_last_proc + 0.75 < now then
                vesper_last_proc = now
                vesper_used = vesper_used + 1
                vesper_heal = vesper_heal - 1
            end

        -- Vesper Totem damage; only fires on SPELL_DAMAGE...
        elseif spellID == 324520 then
            local now = GetTime()

            if vesper_last_proc + 0.75 < now then
                vesper_last_proc = now
                vesper_used = vesper_used + 1
                vesper_damage = vesper_damage - 1
            end

        end

        if subtype == "SPELL_CAST_SUCCESS" then
            -- Reset in case we need to deal with an instant after a hardcast.
            vesper_last_proc = 0

            local ability = class.abilities[ spellID ]
            local key = ability and ability.key

            if key and recall_totems[ key ] then
                recallTotem2 = recallTotem1
                recallTotem1 = key
            end

            if state.talent.further_beyond.enabled and subtype == "SPELL_CAST_SUCCESS" and fbSpells[ key ] then
                if key == "ascendance" then further_beyond_duration_remains = spec.auras.ascendance.duration
                elseif further_beyond_duration_remains > 0 then
                    if key == "earth_shock" or key == "earthquake" then further_beyond_duration_remains = max( 0, further_beyond_duration_remains - 2.5 )
                    elseif key == "elemental_blast" then further_beyond_duration_remains = max( 0, further_beyond_duration_remains - 3.5 ) end
                end
            end
        end

        if ( subtype == "SPELL_DAMAGE" or subtype == "SPELL_PERIODIC_DAMAGE" ) and state.talent.elemental_equilibrium.enabled then
            if bit.band( school, 4  ) == 1 then fireDamage   = GetTime() end
            if bit.band( school, 16 ) == 1 then frostDamage  = GetTime() end
            if bit.band( school, 8  ) == 1 then natureDamage = GetTime() end
        end
    end
end )

spec:RegisterStateExpr( "vesper_totem_heal_charges", function()
    return vesper_heal
end )

spec:RegisterStateExpr( "vesper_totem_dmg_charges", function ()
    return vesper_damage
end )

spec:RegisterStateExpr( "vesper_totem_used_charges", function ()
    return vesper_used
end )

spec:RegisterStateFunction( "trigger_vesper_heal", function ()
    if vesper_totem_heal_charges > 0 then
        vesper_totem_heal_charges = vesper_totem_heal_charges - 1
        vesper_totem_used_charges = vesper_totem_used_charges + 1
    end
end )

spec:RegisterStateFunction( "trigger_vesper_damage", function ()
    if vesper_totem_dmg_charges > 0 then
        vesper_totem_dmg_charges = vesper_totem_dmg_charges - 1
        vesper_totem_used_charges = vesper_totem_used_charges + 1
    end
end )

spec:RegisterStateExpr( "last_ee_fire", function ()
    return fireDamage
end )

spec:RegisterStateExpr( "last_ee_frost", function ()
    return frostDamage
end )

spec:RegisterStateExpr( "last_ee_nature", function ()
    return natureDamage
end )


spec:RegisterStateTable( "t30_2pc_timer", setmetatable( {}, {
    __index = setfenv( function( t, k )
        if set_bonus.tier30_2pc == 0 then return 0 end

        if k == "next_tick" then
            return max( 0, t.last_tick + 50 - query_time )
        elseif k == "last_tick" then
            return 0
        end
    end, state )
} ) )


spec:RegisterTotem( "liquid_magma_totem", 971079 )
spec:RegisterTotem( "tremor_totem", 136108 )
spec:RegisterTotem( "wind_rush_totem", 538576 )

spec:RegisterTotem( "vesper_totem", 3565451 )


spec:RegisterStateTable( "fire_elemental", setmetatable( { onReset = function( self ) self.cast_time = nil end }, {
    __index = function( t, k )
        if k == "cast_time" then
            t.cast_time = class.abilities.fire_elemental.lastCast or 0
            return t.cast_time
        end

        local elem = talent.primal_elementalist.enabled and pet.primal_fire_elemental or pet.greater_fire_elemental

        if k == "active" or k == "up" then
            return elem.up

        elseif k == "down" then
            return not elem.up

        elseif k == "remains" then
            return max( 0, elem.remains )

        end

        return false
    end
} ) )

spec:RegisterStateTable( "storm_elemental", setmetatable( { onReset = function( self ) self.cast_time = nil end }, {
    __index = function( t, k )
        if k == "cast_time" then
            t.cast_time = class.abilities.storm_elemental.lastCast or 0
            return t.cast_time
        end

        local elem = talent.primal_elementalist.enabled and pet.primal_storm_elemental or pet.greater_storm_elemental

        if k == "active" or k == "up" then
            return elem.up

        elseif k == "down" then
            return not elem.up

        elseif k == "remains" then
            return max( 0, elem.remains )

        end

        return false
    end
} ) )

spec:RegisterStateTable( "earth_elemental", setmetatable( { onReset = function( self ) self.cast_time = nil end }, {
    __index = function( t, k )
        if k == "cast_time" then
            t.cast_time = class.abilities.earth_elemental.lastCast or 0
            return t.cast_time
        end

        local elem = talent.primal_elementalist.enabled and pet.primal_earth_elemental or pet.greater_earth_elemental

        if k == "active" or k == "up" then
            return elem.up

        elseif k == "down" then
            return not elem.up

        elseif k == "remains" then
            return max( 0, elem.remains )

        end

        return false
    end
} ) )



-- Tier 29
spec:RegisterGear( "tier29", 200396, 200398, 200400, 200401, 200399 )
spec:RegisterSetBonuses( "tier29_2pc", 393688, "tier29_4pc", 393690 )
-- 2-Set: - https://www.wowhead.com/beta/spell=393688
-- 4-Set: - https://www.wowhead.com/beta/spell=393690
spec:RegisterAuras( {
    seismic_accumulation = {
        id = 394651,
        duration = 15,
        max_stack = 5,
    },
    elemental_mastery = {
        id = 394670,
        duration = 5,
        max_stack = 1,
    }
} )


-- Tier 30
spec:RegisterGear( "tier30", 202473, 202471, 202470, 202469, 202468 )
spec:RegisterAura( "primal_fracture", {
    id = 410018,
    duration = 8,
    max_stack = 1,
    copy = "t30_4pc_ele"
} )

spec:RegisterGear( "tier31", 207207, 207208, 207209, 207210, 207212 )
spec:RegisterAuras( {
    molten_slag = {
        id = 426577,
        duration = 4,
        max_stack = 1,
    },
    molten_charge = {
        id = 426578,
        duration = 20,
        max_stack = 1
    }
} )


local TriggerHeatWave = setfenv( function()
    applyBuff( "lava_surge" )
end, state )

local TriggerStaticAccumulation = setfenv( function()
    addStack( "maelstrom_weapon", nil, talent.static_accumulation.rank )
end, state )

local TriggerStormkeeperTier30 = setfenv( function()
    addStack( "stormkeeper" )
    t30_2pc_timer.last_tick = query_time
end, state )

spec:RegisterHook( "reset_precast", function ()
    local mh, _, _, mh_enchant, oh, _, _, oh_enchant = GetWeaponEnchantInfo()

    if mh and mh_enchant == 5400 then applyBuff( "flametongue_weapon" ) end
    if buff.flametongue_weapon.down and ( now - action.flametongue_weapon.lastCast < 1 ) then applyBuff( "flametongue_weapon" ) end

    if talent.master_of_the_elements.enabled and action.lava_burst.in_flight and buff.master_of_the_elements.down then
        applyBuff( "master_of_the_elements" )
    end

    if vesper_expires > 0 and now > vesper_expires then
        vesper_expires = 0
        vesper_heal = 0
        vesper_damage = 0
        vesper_used = 0
    end

    vesper_totem_heal_charges = nil
    vesper_totem_dmg_charges = nil
    vesper_totem_used_charges = nil

    recall_totem_1 = nil
    recall_totem_2 = nil

    if totem.vesper_totem.up then
        applyBuff( "vesper_totem", totem.vesper_totem.remains )
    end

    rawset( state.pet, "earth_elemental", talent.primal_elementalist.enabled and state.pet.primal_earth_elemental or state.pet.greater_earth_elemental )
    rawset( state.pet, "fire_elemental",  talent.primal_elementalist.enabled and state.pet.primal_fire_elemental  or state.pet.greater_fire_elemental  )
    rawset( state.pet, "storm_elemental", talent.primal_elementalist.enabled and state.pet.primal_storm_elemental or state.pet.greater_storm_elemental )

    if talent.primal_elementalist.enabled then
        dismissPet( "primal_fire_elemental" )
        dismissPet( "primal_storm_elemental" )
        dismissPet( "primal_earth_elemental" )

        if summon.expires then
            if summon.expires <= now then
                wipe( summon )
            else
                summonPet( summon.type, summon.expires - now )
            end
        end
    end

    if talent.primordial_surge.enabled and query_time - action.primordial_wave.lastCast < 12 then
        local expires = action.primordial_wave.lastCast + 12
        while expires > query_time do
            state:QueueAuraEvent( "primordial_surge", TriggerHeatWave, expires, "AURA_PERIODIC" )
            expires = expires - 3
        end
    end

    if set_bonus.tier30_2pc > 0 then
        t30_2pc_timer.last_tick = stormkeeperLastProc
        if t30_2pc_timer.next_tick > 0 then
            state:QueueAuraEvent( "stormkeeper", TriggerStormkeeperTier30, query_time + t30_2pc_timer.next_tick, "AURA_PERIODIC" )
        end
    end

    if buff.ascendance.down or not talent.further_beyond.enabled then
        fb_extension_remaining = 0
    end

    --[[ TODO: Not really needed; shift to Enhancement module.
    if talent.static_accumulation.enabled and buff.ascendance.up then
        local expires = buff.ascendance.expires
        while expires > query_time do
            state:QueueAuraEvent( "ascendance", TriggerStaticAccumulation, query_time + expires )
            expires = expires - 1
        end
    end ]]
end )


local fol_spells = {}

spec:RegisterStateFunction( "flash_of_lightning", function()
    if #fol_spells == 0 then
        for k, v in pairs( class.abilityList ) do
            if v.school == "nature" then table.insert( fol_spells, k ) end
        end
    end

    for _, spell in ipairs( fol_spells ) do
        reduceCooldown( spell, 1 )
    end
end )


-- Abilities
spec:RegisterAbilities( {
    -- Talent: For the next $d, $s1% of your damage and healing is converted to healing on up to 3 nearby injured party or raid members.
    ancestral_guidance = {
        id = 108281,
        cast = 0,
        cooldown = 120,
        gcd = "off",
        school = "nature",

        talent = "ancestral_guidance",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            applyBuff( "ancestral_guidance" )
        end,
    },

    -- Talent: Transform into a Flame Ascendant for $d, replacing Chain Lightning with Lava Beam, removing the cooldown on Lava Burst, and increasing the damage of Lava Burst by an amount equal to your critical strike chance.    When you transform into the Flame Ascendant, instantly cast a Lava Burst at all enemies affected by your Flame Shock, and refresh your Flame Shock durations to $188389d.
    ascendance = {
        id = function()
            if state.spec.elemental then return 114050 end
            if state.spec.enhancement then return 114051 end
            return 114052
        end,
        cast = 0,
        cooldown = function () return 180 - 30 * talent.oath_of_the_far_seer.rank end,
        gcd = "spell",
        school = function()
            if spec.elemental then return "fire" end
            return "nature"
        end,
        talent = "ascendance",
        startsCombat = function()
            if state.spec.elemental and active_dot.flame_shock > 0 then return true end
            return false
        end,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "ascendance" )
            if state.spec.elemental and dot.flame_shock.up then dot.flame_shock.expires = query_time + class.auras.flame_shock.duration
            elseif state.spec.enhancement and talent.static_accumulation.enabled then
                for i = 1, class.auras.ascendance.duration do
                    state:QueueAuraEvent( "ascendance", TriggerStaticAccumulation, query_time + i, "AURA_PERIODIC" )
                end
            end
        end,

        copy = { 114050, 114051, 114052 }
    },


    astral_recall = {
        id = 556,
        cast = 10,
        cooldown = 600,
        gcd = "spell",

        startsCombat = false,
        texture = 136010,

        handler = function () end,
    },


    astral_shift = {
        id = 108271,
        cast = 0,
        cooldown = function () return talent.planes_traveler.enabled and 90 or 120 end,
        gcd = "off",
        school = "nature",

        talent = "astral_shift",
        startsCombat = false,
        nopvptalent = "ethereal_form",

        toggle = "defensives",

        handler = function ()
            applyBuff( "astral_shift" )
        end,
    },

    -- Increases haste by $s1% for all party and raid members for $d.    Allies receiving this effect will become Sated and unable to benefit from Bloodlust or Time Warp again for $57724d.
    bloodlust = {
        id = function() return state.faction == "Alliance" and 32182 or 2825 end,
        cast = 0,
        cooldown = 300,
        gcd = "off",
        school = "nature",

        spend = 0.02,
        spendType = "mana",

        startsCombat = false,
        toggle = "cooldowns",
        nodebuff = "sated",

        handler = function ()
            applyBuff( "bloodlust" )
            applyDebuff( "player", "sated" )
            stat.haste = state.haste + 0.4
        end,

        copy = { 2825, "heroism" }
    },

    -- PvP Talent: Burrow beneath the ground, becoming unattackable, removing movement impairing effects, and increasing your movement speed by ${$s3-100}% for $d.; When the effect ends, enemies within $409304A1 yards are knocked in the air and take $<damage> Physical damage.
    burrow = {
        id = 409293,
        cast = 0,
        cooldown = 120,
        gcd = "spell",

        startsCombat = false,
        pvptalent = "burrow",

        handler = function()
            applyBuff( "burrow" )
            setCooldown( "global_cooldown", 5 )
        end,

        auras = {
            burrow = {
                id = 409293,
                duration = 5,
                max_stack = 1
            }
        }

        -- Effects:
        -- #0: { 'type': APPLY_AURA, 'subtype': INTERFERE_TARGETTING, 'target': TARGET_UNIT_CASTER, }
        -- #1: { 'type': APPLY_AURA, 'subtype': KEYBOUND_OVERRIDE, 'value': 244, 'schools': ['fire', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #2: { 'type': APPLY_AURA, 'subtype': MOD_MINIMUM_SPEED, 'points': 150.0, 'target': TARGET_UNIT_CASTER, }
        -- #3: { 'type': APPLY_AURA, 'subtype': USE_NORMAL_MOVEMENT_SPEED, 'points': 10.5, 'target': TARGET_UNIT_CASTER, }
        -- #4: { 'type': APPLY_AURA, 'subtype': MOD_ATTACKER_MELEE_HIT_CHANCE, 'sp_bonus': 0.25, 'points': -200.0, 'target': TARGET_UNIT_CASTER, }
        -- #5: { 'type': APPLY_AURA, 'subtype': MOD_ATTACKER_RANGED_HIT_CHANCE, 'points': -200.0, 'target': TARGET_UNIT_CASTER, }
        -- #6: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 7, }
        -- #7: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 11, }
        -- #8: { 'type': APPLY_AURA, 'subtype': MECHANIC_IMMUNITY, 'target': TARGET_UNIT_CASTER, 'mechanic': 13, }
        -- #9: { 'type': APPLY_AURA, 'subtype': MOD_NO_ACTIONS, 'target': TARGET_UNIT_CASTER, }
        -- #10: { 'type': APPLY_AURA, 'subtype': MOD_PACIFY_SILENCE, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
        -- #11: { 'type': APPLY_AURA, 'subtype': MOD_FLYING_RESTRICTIONS, 'target': TARGET_UNIT_CASTER, }
        -- #12: { 'type': APPLY_AURA, 'subtype': MOD_ATTACKER_SPELL_HIT_CHANCE, 'points': -200.0, 'value': 127, 'schools': ['physical', 'holy', 'fire', 'nature', 'frost', 'shadow', 'arcane'], 'target': TARGET_UNIT_CASTER, }
    },

    -- Talent: Summons a totem at the target location that gathers electrical energy from the surrounding air and explodes after $s2 sec, stunning all enemies within $118905A1 yards for $118905d.
    capacitor_totem = {
        id = 192058,
        cast = 0,
        cooldown = function () return 60 - 3 * talent.totemic_surge.rank + conduit.totemic_surge.mod * 0.001 end,
        gcd = "totem",
        school = "nature",

        spend = 0.1,
        spendType = "mana",

        talent = "capacitor_totem",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            summonTotem( "capacitor_totem" )
        end,
    },

    -- Talent: Heals the friendly target for $s1, then jumps to heal the $<jumps> most injured nearby allies. Healing is reduced by $s2% with each jump.
    chain_heal = {
        id = 1064,
        cast = function ()
            if buff.chains_of_devastation_ch.up then return 0 end
            if buff.natures_swiftness.up then return 0 end
            return 2.5 * ( 1 - 0.2 * min( 5, buff.maelstrom_weapon.stack ) )
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return buff.natures_swiftness.up and 0 or 0.15 end,
        spendType = "mana",

        talent = "chain_heal",
        startsCombat = false,

        handler = function ()
            removeBuff( "focused_insight" )
            removeBuff( "chains_of_devastation_ch" )
            removeBuff( "natures_swiftness" ) -- TODO: Determine order of instant cast effect consumption.

            if legendary.chains_of_devastation.enabled then
                applyBuff( "chains_of_devastation_cl" )
            end

            if buff.vesper_totem.up and vesper_totem_heal_charges > 0 then trigger_vesper_heal() end
        end,
    },

    -- Talent: Hurls a lightning bolt at the enemy, dealing $s1 Nature damage and then jumping to additional nearby enemies. Affects $x1 total targets.$?s187874[    If Chain Lightning hits more than 1 target, each target hit by your Chain Lightning increases the damage of your next Crash Lightning by $333964s1%.][]$?s187874[    Each target hit by Chain Lightning reduces the cooldown of Crash Lightning by ${$s3/1000}.1 sec.][]$?a343725[    |cFFFFFFFFGenerates $343725s5 Maelstrom per target hit.|r][]
    chain_lightning = {
        id = 188443,
        cast = function ()
            if buff.chains_of_devastation_cl.up then return 0 end
            if buff.natures_swiftness.up then return 0 end
            if buff.stormkeeper.up then return 0 end
            return ( talent.unrelenting_calamity.enabled and 1.75 or 2 ) * ( 1 - 0.03 * min( 10, buff.wind_gust.stacks ) ) * ( 1 - 0.2 * min( 5, buff.maelstrom_weapon.stack ) )
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return buff.natures_swiftness.up and 0 or 0.01 end,
        spendType = "mana",

        talent = "chain_lightning",
        startsCombat = true,

        nobuff = "ascendance",
        bind = "lava_beam",

        handler = function ()
            removeBuff( "chains_of_devastation_cl" )
            removeBuff( "natures_swiftness" )
            removeBuff( "master_of_the_elements" )

            if legendary.chains_of_devastation.enabled then
                applyBuff( "chains_of_devastation_ch" )
            end

            -- 4 MS per target, direct.
            -- 3 MS per target, overload.
            -- stormkeeper guarantees overload on every target hit
            -- power of the maelstrom guarantees 1 extra overload on the initial target
            -- surge of power adds 1 extra target to total potential enemies hit

            gain( ( buff.stormkeeper.up and 4 + ( min( (buff.surge_of_power.up and 6 or 5),active_enemies ) * 3) or 4 ) * min( (buff.surge_of_power.up and 6 or 5), active_enemies ), "maelstrom" )
            if buff.power_of_the_maelstrom.up then
                gain( 3 * min( ( buff.surge_of_power.up and 6 or 5 ), active_enemies ), "maelstrom" )
            end

            if buff.stormkeeper.up then
                removeStack( "stormkeeper" )
                if set_bonus.tier30_4pc > 0 then applyBuff( "primal_fracture" ) end
            end

            removeStack( "power_of_the_maelstrom" )
            removeBuff( "surge_of_power" )

            if pet.storm_elemental.up then
                addStack( "wind_gust" )
            end

            if talent.flash_of_lightning.enabled then flash_of_lightning() end

            if set_bonus.tier29_2pc > 0 then
                addStack( "seismic_accumulation" )
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Talent: Removes all Curse effects from a friendly target.
    cleanse_spirit = {
        id = 51886,
        cast = 0,
        cooldown = 8,
        gcd = "spell",
        school = "nature",

        spend = 0.10,
        spendType = "mana",

        talent = "cleanse_spirit",
        startsCombat = false,

        toggle = "interrupts",
        buff = "dispellable_curse",

        handler = function ()
            removeBuff( "dispellable_curse" )
            if state.spec.elemental and time > 0 and talent.inundate.enabled then gain( 8, "maelstrom" ) end
        end,
    },


    counterstrike_totem = {
        id = 204331,
        cast = 0,
        cooldown = function () return 45 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "fire",

        spend = 0.03,
        spendType = "mana",

        pvptalent = "counterstrike_totem",
        startsCombat = false,
        texture = 511726,

        handler = function ()
            summonTotem( "counterstrike_totem" )
        end,
    },

    -- Talent: Calls forth a Greater Earth Elemental to protect you and your allies for $188616d.    While this elemental is active, your maximum health is increased by $381755s1%.
    earth_elemental = {
        id = 198103,
        cast = 0,
        cooldown = function () return 300 * ( buff.deadened_earth.up and 0.6 or 1 ) end,
        gcd = "spell",
        school = "nature",

        talent = "earth_elemental",
        startsCombat = false,

        toggle = "defensives",

        handler = function ()
            summonPet( talent.primal_elementalist.enabled and "primal_earth_elemental" or "greater_earth_elemental", 60 )
            if conduit.vital_accretion.enabled then
                applyBuff( "vital_accretion" )
                health.max = health.max * ( 1 + ( conduit.vital_accretion.mod * 0.01 ) )
            end
        end,

        usable = function ()
            return max( cooldown.fire_elemental.true_remains, cooldown.storm_elemental.true_remains ) > 0, "DPS elementals must be on CD first"
        end,

        timeToReady = function ()
            return max( pet.fire_elemental.remains, pet.storm_elemental.remains, pet.primal_fire_elemental.remains, pet.primal_storm_elemental.remains )
        end,
    },

    -- Talent: Protects the target with an earthen shield, increasing your healing on them by $s1% and healing them for ${$379s1*(1+$s1/100)} when they take damage. This heal can only occur once every few seconds. Maximum $n charges.    $?s383010[Earth Shield can only be placed on the Shaman and one other target at a time. The Shaman can have up to two Elemental Shields active on them.][Earth Shield can only be placed on one target at a time. Only one Elemental Shield can be active on the Shaman.]
    earth_shield = {
        id = 974,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = 0.05,
        spendType = "mana",

        talent = "earth_shield",
        startsCombat = false,

        --This can be fine, as long as the APL doesn't recommend casting both unless elemental orbit is picked.
        handler = function ()
            applyBuff( "earth_shield", nil, 9 )
            if not talent.elemental_orbit.enabled then removeBuff( "lightning_shield" ) end
            if buff.vesper_totem.up and vesper_totem_heal_charges > 0 then trigger_vesper_heal() end
        end,
    },

    -- Talent: Instantly shocks the target with concussive force, causing $s1 Nature damage.$?a190493[    Earth Shock will consume all stacks of Fulmination to deal extra Nature damage to your target.][]
    earth_shock = {
        id = 8042,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return 60 - 5 * talent.eye_of_the_storm.rank end,
        spendType = "maelstrom",

        talent = "earth_shock",
        notalent = "elemental_blast",
        startsCombat = true,
        cycle = function() return talent.lightning_rod.enabled and "lightning_rod" or nil end,

        handler = function ()
            removeBuff( "master_of_the_elements" )
            removeBuff( "magma_chamber" )

            if talent.surge_of_power.enabled then
                applyBuff( "surge_of_power" )
            end

            if talent.echoes_of_great_sundering.enabled or runeforge.echoes_of_great_sundering.enabled then
                applyBuff( "echoes_of_great_sundering" )
            end

            if talent.windspeakers_lava_resurgence.enabled or runeforge.windspeakers_lava_resurgence.enabled then
                applyBuff( "lava_surge" )
                gainCharges( "lava_burst", 1 )
                applyBuff( "windspeakers_lava_resurgence" )
            end

            if talent.further_beyond.enabled and buff.ascendance.up then
                local extension = min( 2.5, fb_extension_remaining )
                buff.ascendance.expires = buff.ascendance.expires + extension
                fb_extension_remaining = fb_extension_remaining - extension
            end
            if talent.lightning_rod.enabled then applyDebuff( "target", "lightning_rod" ) end

            if set_bonus.tier29_2pc > 0 then
                removeBuff( "seismic_accumulation" )
            end

            if set_bonus.tier29_4pc > 0 then
                applyBuff( "elemental_mastery" )
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Summons a totem at the target location for $d that slows the movement speed of enemies within $3600A1 yards by $3600s1%.
    earthbind_totem = {
        id = 2484,
        cast = 0,
        cooldown = function () return 30 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.025,
        spendType = "mana",

        startsCombat = false,
        notalent = "earthgrab_totem",
        toggle = "interrupts",

        handler = function ()
            summonTotem( "earthbind_totem" )
        end,
    },

    -- Talent: Summons a totem at the target location for $d. The totem pulses every $116943t1 sec, rooting all enemies within $64695A1 yards for $64695d. Enemies previously rooted by the totem instead suffer $116947s1% movement speed reduction.
    earthgrab_totem = {
        id = 51485,
        cast = 0,
        cooldown = function () return 30 - 3 * talent.totemic_surge.rank end,
        gcd = "spell",
        school = "nature",

        spend = 0.025,
        spendType = "mana",

        talent = "earthgrab_totem",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            summonTotem( "earthgrab_totem" )
        end,
    },

    -- Talent: Causes the earth within $a1 yards of the target location to tremble and break, dealing $<damage> Physical damage over $d and has a $?s381743[${$77478s2+$381743S1)}.1][$77478s2]% chance to knock the enemy down.
    earthquake = {
        id = 61882,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return 60 - 5 * talent.eye_of_the_storm.rank end,
        spendType = "maelstrom",

        talent = "earthquake",
        startsCombat = true,

        handler = function ()
            removeBuff( "echoes_of_great_sundering" )
            removeBuff( "master_of_the_elements" )
            removeBuff( "magma_chamber" )

            if talent.lightning_rod.enabled then applyDebuff( "target", "lightning_rod" ) end
            if talent.further_beyond.enabled and buff.ascendance.up then
                local extension = min( 2.5, fb_extension_remaining )
                buff.ascendance.expires = buff.ascendance.expires + extension
                fb_extension_remaining = fb_extension_remaining - extension
            end

            if talent.windspeakers_lava_resurgence.enabled then
                addStack( "lava_surge" )
                gainCharges( "lava_burst", 1 )
                applyBuff( "windspeakers_lava_resurgence" )
            end

            if talent.surge_of_power.enabled then
                applyBuff( "surge_of_power" )
            end

            if set_bonus.tier29_2pc > 0 then
                removeBuff( "seismic_accumulation" )
            end

            if set_bonus.tier29_4pc > 0 then
                applyBuff( "elemental_mastery" )
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Talent: Harnesses the raw power of the elements, dealing $s1 Elemental damage and increasing your Critical Strike or Haste by $118522s1% or Mastery by ${$173184s1*$168534bc1}% for $118522d.$?s137041[    If Lava Burst is known, Elemental Blast replaces Lava Burst and gains $394152s2 additional $Lcharge:charges;.][]
    elemental_blast = {
        id = 117014,
        cast = function ()
            if buff.natures_swiftness.up then return 0 end
            return 2 * ( 1 - 0.2 * min( 5, buff.maelstrom_weapon.stack ) )
        end,
        gcd = "spell",
        school = "elemental",

        spend = function () return 90 - 7.5 * talent.eye_of_the_storm.rank end,
        spendType = "maelstrom",

        talent = "elemental_blast",
        startsCombat = true,
        cycle = function() return talent.lightning_rod.enabled and "lightning_rod" or nil end,

        handler = function ()
            removeBuff( "master_of_the_elements" )
            applyBuff( "elemental_blast" )
            removeBuff( "magma_chamber" )

            if talent.surge_of_power.enabled then
                applyBuff( "surge_of_power" )
            end

            if talent.echoes_of_great_sundering.enabled or runeforge.echoes_of_great_sundering.enabled then
                applyBuff( "echoes_of_great_sundering" )
            end

            if talent.windspeakers_lava_resurgence.enabled or runeforge.windspeakers_lava_resurgence.enabled then
                applyBuff( "lava_surge" )
                gainCharges( "lava_burst", 1 )
                applyBuff( "windspeakers_lava_resurgence" )
            end

            if talent.further_beyond.enabled and buff.ascendance.up then
                local extension = min( 3.5, fb_extension_remaining )
                buff.ascendance.expires = buff.ascendance.expires + extension
                fb_extension_remaining = fb_extension_remaining - extension
            end

            if set_bonus.tier29_2pc > 0 then
                removeBuff( "seismic_accumulation" )
            end

            if set_bonus.tier29_4pc > 0 then
                applyBuff( "elemental_mastery" )
            end

            if talent.lightning_rod.enabled then applyDebuff( "target", "lightning_rod" ) end
            if talent.further_beyond.enabled and buff.ascendance.up then buff.ascendance.expires = buff.ascendance.expires + 3.5 end
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Changes your viewpoint to the targeted location for $d.
    far_sight = {
        id = 6196,
        cast = 2,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        startsCombat = false,

        handler = function ()
            applyBuff( "far_sight" )
        end,
    },

    -- Talent: Calls forth a Greater Fire Elemental to rain destruction on your enemies for $188592d.     While the Fire Elemental is active, Flame Shock deals damage   ${100*(1/(1+$188592s2/100)-1)}% faster, and newly applied Flame Shocks last $188592s3% longer.
    fire_elemental = {
        id = 198067,
        cast = 0,
        charges = 1,
        cooldown = 150,
        recharge = 150,
        gcd = "spell",
        school = "fire",

        spend = 0.05,
        spendType = "mana",

        talent = "fire_elemental",
        startsCombat = false,

        toggle = "cooldowns",

        timeToReady = function ()
            return max( pet.earth_elemental.remains, pet.primal_earth_elemental.remains, pet.storm_elemental.remains, pet.primal_storm_elemental.remains )
        end,

        handler = function ()
            summonPet( talent.primal_elementalist.enabled and "primal_fire_elemental" or "greater_fire_elemental" )
        end,
    },

    -- Sears the target with fire, causing $s1 Fire damage and then an additional $o2 Fire damage over $d.    Flame Shock can be applied to a maximum of $I targets.
    flame_shock = {
        id = 188389,
        cast = 0,
        cooldown = function () return talent.flames_of_the_cauldron.enabled and 4.5 or 6 end,
        gcd = "spell",
        school = "fire",

        spend = 0.015,
        spendType = "mana",

        startsCombat = true,

        cycle = "flame_shock",
        min_ttd = function () return debuff.flame_shock.duration / 3 end,

        handler = function ()
            applyDebuff( "target", "flame_shock" )
            if talent.focused_insight.enabled then applyBuff( "focused_insight" ) end
            if talent.magma_chamber.enabled then addStack( "magma_chamber" ) end

            if buff.surge_of_power.up then
                active_dot.surge_of_power_debuff = min( active_enemies, active_dot.flame_shock + 1 )
                removeBuff( "surge_of_power" )
            end

            -- TODO: should also gain on every tick of damage.
            if talent.searing_flames.enabled then gain( talent.searing_flames.rank, "maelstrom" ) end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Imbue your $?s33757[off-hand ][]weapon with the element of Fire for $319778d, causing each of your attacks to deal ${$max(($<coeff>*$AP),1)} additional Fire damage$?s382027[ and increasing the damage of your Fire spells by $382028s1%][].
    flametongue_weapon = {
        id = 318038,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "fire",

        startsCombat = false,
        nobuff = "flametongue_weapon",

        handler = function ()
            applyBuff( "flametongue_weapon" )
        end,
    },

    -- Talent: Chills the target with frost, causing $s1 Frost damage and reducing the target's movement speed by $s2% for $d.
    frost_shock = {
        id = 196840,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "frost",

        spend = 0.01,
        spendType = "mana",

        talent = "frost_shock",
        startsCombat = true,

        handler = function ()
            removeBuff( "master_of_the_elements" )
            applyDebuff( "target", "frost_shock" )

            if talent.flux_melting.enabled then applyBuff( "flux_melting" ) end

            if buff.icefury.up then
                gain( buff.primal_fracture.up and 12 or 8, "maelstrom" )
                removeStack( "icefury", 1 )

                if talent.electrified_shocks.enabled then
                    applyDebuff( "target", "electrified_shocks" )
                    active_dot.electrified_shocks = min( true_active_enemies, active_dot.electrified_shocks + 2 )
                end
            end

            if buff.surge_of_power.up then
                applyDebuff( "target", "surge_of_power_debuff" )
                removeBuff( "surge_of_power" )
            end

            if talent.flux_melting.enabled then
                applyBuff( "flux_melting" )
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Turn into a Ghost Wolf, increasing movement speed by $?s382215[${$s2+$382216s1}][$s2]% and preventing movement speed from being reduced below $s3%.
    ghost_wolf = {
        id = 2645,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        startsCombat = false,

        handler = function ()
            applyBuff( "ghost_wolf" )
            if talent.spirit_wolf.enabled then applyBuff( "spirit_wolf" ) end
        end,
    },

    -- Talent: Purges the enemy target, removing $m1 beneficial Magic effects.
    greater_purge = {
        id = 378773,
        cast = 0,
        cooldown = 12,
        gcd = "spell",
        school = "nature",

        spend = 0.2,
        spendType = "mana",

        talent = "greater_purge",
        startsCombat = function()
            if talent.elemental_equilibrium.enabled then return false end
            return true
        end,

        toggle = "interrupts",
        debuff = "dispellable_magic",

        handler = function ()
            removeDebuff( "target", "dispellable_magic" )
        end,
    },


    grounding_totem = {
        id = 204336,
        cast = 0,
        cooldown = function () return 30 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.06,
        spendType = "mana",

        pvptalent = "grounding_totem",
        startsCombat = false,
        texture = 136039,

        handler = function ()
            summonTotem( "grounding_totem" )
        end,
    },

    -- Talent: A gust of wind hurls you forward.
    gust_of_wind = {
        id = 192063,
        cast = 0,
        cooldown = function() return 30 - 5 * talent.go_with_the_flow.rank end,
        gcd = "spell",
        school = "nature",

        talent = "gust_of_wind",
        startsCombat = false,

        toggle = "interrupts",

        handler = function () end,
    },

    -- Talent: Summons a totem at your feet for $d that heals $?s147074[two injured party or raid members][an injured party or raid member] within $52042A1 yards for $52042s1 every $5672t1 sec.    If you already know $?s157153[$@spellname157153][$@spellname5394], instead gain $392915s1 additional $Lcharge:charges; of $?s157153[$@spellname157153][$@spellname5394].
    healing_stream_totem = {
        id = 5394,
        cast = 0,
        charges = 1,
        cooldown = function () return 30 - 3 * talent.totemic_surge.rank end,
        recharge = 30,
        gcd = "totem",

        spend = 0.05,
        spendType = "mana",

        talent = "healing_stream_totem",
        startsCombat = false,

        handler = function ()
            summonTotem( "healing_stream_totem" )
            if buff.vesper_totem.up and vesper_totem_heal_charges > 0 then trigger_vesper_heal() end
            if conduit.swirling_currents.enabled or talent.swirling_currents.enabled then applyBuff( "swirling_currents" ) end
            if time > 0 and talent.inundate.enabled then gain( 8, "maelstrom" ) end
        end,
    },

    -- A quick surge of healing energy that restores $s1 of a friendly target's health.
    healing_surge = {
        id = 8004,
        cast = function ()
            if buff.natures_swiftness.up then return 0 end
            return 1.5 * haste
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = function () return buff.natures_swiftness.up and 0 or 0.10 end,
        spendType = "mana",

        startsCombat = false,

        handler = function ()
            removeBuff( "focused_insight" )
            if buff.vesper_totem.up and vesper_totem_heal_charges > 0 then trigger_vesper_heal() end
            if buff.swirling_currents.up then removeStack( "swirling_currents" ) end
        end,
    },

    -- Talent: Transforms the enemy into a frog for $d. While hexed, the victim is incapacitated, and cannot attack or cast spells. Damage may cancel the effect. Limit 1. Only works on Humanoids and Beasts.
    hex = {
        id = 51514,
        cast = 1.7,
        cooldown = function () return 30 - 15 * talent.voodoo_mastery.rank end,
        gcd = "spell",
        school = "nature",

        talent = "hex",
        startsCombat = false,

        handler = function ()
            applyDebuff( "target", "hex" )
            if talent.enfeeblement.enabled then applyDebuff( "target", "enfeeblement" ) end
            if time > 0 and talent.inundate.enabled then gain( 8, "maelstrom" ) end
        end,

        copy = { 210873, 211004, 211010, 211015, 269352, 277778, 277784, 309328 }
    },

    -- Talent: Hurls frigid ice at the target, dealing $s1 Frost damage and causing your next $n Frost Shocks to deal $s2% increased damage and generate $343725s7 Maelstrom.    |cFFFFFFFFGenerates $343725s8 Maelstrom.|r
    icefury = {
        id = 210714,
        cast = 2,
        cooldown = 30,
        gcd = "spell",
        school = "frost",

        spend = 0.03,
        spendType = "mana",

        talent = "icefury",
        startsCombat = true,

        handler = function ()
            removeBuff( "master_of_the_elements" )
            applyBuff( "icefury", nil, 4 )
            gain( 25 * ( buff.primal_fracture.up and 1.5 or 1 ), "maelstrom" )

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },


    lava_beam = {
        id = 114074,
        cast = function () return buff.stormkeeper.up and 0 or 1.5 end,
        cooldown = 0,
        gcd = "spell",
        school = "fire",

        startsCombat = true,
        texture = 236216,

        buff = "ascendance",
        bind = "chain_lightning",

        handler = function ()
            gain( ( buff.stormkeeper.up and 4 + ( min( ( buff.surge_of_power.up and 6 or 5 ), active_enemies ) * 3 ) or 4 ) * min( ( buff.surge_of_power.up and 6 or 5 ), active_enemies ), "maelstrom" )

            removeStack( "stormkeeper" )
            removeBuff( "surge_of_power" )

            if talent.flash_of_lightning.enabled then flash_of_lightning() end
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Talent: Hurls molten lava at the target, dealing $285452s1 Fire damage. Lava Burst will always critically strike if the target is affected by Flame Shock.$?a343725[    |cFFFFFFFFGenerates $343725s3 Maelstrom.|r][]
    lava_burst = {
        id = 51505,
        cast = function () return buff.lava_surge.up and 0 or ( 2 * haste ) end,
        charges = function () return talent.echo_of_the_elements.enabled and 2 or nil end,
        cooldown = function () return buff.ascendance.up and 0 or ( 8 * haste ) end,
        recharge = function () return talent.echo_of_the_elements.enabled and ( buff.ascendance.up and 0 or ( 8 * haste ) ) or nil end,
        gcd = "spell",
        school = "fire",

        spend = 0.025,
        spendType = "mana",

        talent = "lava_burst",
        notalent = function()
            if state.spec.enhancement then return "elemental_blast" end
        end,
        startsCombat = true,

        velocity = 30,

        indicator = function()
            return active_enemies > 1 and settings.cycle and dot.flame_shock.down and active_dot.flame_shock > 0 and "cycle" or nil
        end,

        handler = function ()
            removeBuff( "windspeakers_lava_resurgence" )
            removeBuff( "lava_surge" )
            removeBuff( "flux_melting" )
            removeStack( "molten_charge" )

            gain( ( 10 + ( talent.flow_of_power.rank * 2 ) ) * ( buff.primal_fracture.up and 1.5 or 1 ), "maelstrom" )

            if talent.master_of_the_elements.enabled then applyBuff( "master_of_the_elements" ) end

            if talent.rolling_magma.enabled and talent.primordial_wave.enabled then
                reduceCooldown( "primordial_wave", 0.5 )
            end

            if talent.surge_of_power.enabled then
                gainChargeTime( "fire_elemental", 6 )
                removeBuff( "surge_of_power" )
            end

            if buff.primordial_wave.up and state.spec.elemental and talent.splintered_elements.enabled then
                applyBuff( "splintered_elements", nil, active_dot.flame_shock )
            end
            removeBuff( "primordial_wave" )

            if talent.rolling_magma.enabled then
                reduceCooldown( "primordial_wave", 0.2 * talent.rolling_magma.rank )
            end

            if set_bonus.tier29_2pc > 0 then
                addStack( "seismic_accumulation" )
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        impact = function () end,  -- This + velocity makes action.lava_burst.in_flight work in APL logic.
    },

    -- Hurls a bolt of lightning at the target, dealing $s1 Nature damage.$?a343725[    |cFFFFFFFFGenerates $343725s1 Maelstrom.|r][]
    lightning_bolt = {
        id = 188196,
        cast = function ()
            if buff.natures_swiftness.up then return 0 end
            if buff.stormkeeper.up then return 0 end
            return ( talent.unrelenting_calamity.enabled and 1.75 or 2 ) * ( 1 - 0.03 * min( 10, buff.wind_gust.stacks ) ) * ( 1 - 0.2 * min( 5, buff.maelstrom_weapon.stack ) )
        end,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = 0.01,
        spendType = "mana",

        startsCombat = true,

        handler = function ()
            local ms = 8 + ( talent.flow_of_power.rank * 2 )
            local overload = 3 + talent.flow_of_power.rank

            ms = ms + ( buff.stormkeeper.up and overload or 0 ) + ( buff.surge_of_power.up and ( 2 * overload ) or 0 ) + ( buff.power_of_the_maelstrom.up and overload or 0 )
            ms = ms * ( buff.primal_fracture.up and 1.5 or 1 )

            gain( ms, "maelstrom" )

            removeBuff( "natures_swiftness" )
            removeBuff( "master_of_the_elements" )
            removeBuff( "surge_of_power" )
            removeStack( "power_of_the_maelstrom" )

            if buff.stormkeeper.up then
                removeStack( "stormkeeper" )
                if set_bonus.tier30_4pc > 0 then applyBuff( "primal_fracture" ) end
            end

            if pet.storm_elemental.up then
                addStack( "wind_gust" )
            end

            if talent.flash_of_lightning.enabled then flash_of_lightning() end

            if set_bonus.tier29_2pc > 0 then
                addStack( "seismic_accumulation" )
            end

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Talent: Grips the target in lightning, stunning and dealing $305485o1 Nature damage over $305485d while the target is lassoed. Can move while channeling.
    lightning_lasso = {
        id = 305483,
        cast = 5,
        channeled = true,
        cooldown = 45,
        gcd = "spell",
        school = "nature",

        talent = "lightning_lasso",
        startsCombat = true,

        start = function ()
            applyDebuff( "target", "lightning_lasso" )

            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,

        copy = 305485
    },

    -- Surround yourself with a shield of lightning for $d.    Melee attackers have a $h% chance to suffer $192109s1 Nature damage$?a137041[ and have a $s3% chance to generate a stack of Maelstrom Weapon]?a137040[ and have a $s4% chance to generate $s5 Maelstrom][].    $?s383010[The Shaman can have up to two Elemental Shields active on them.][Only one Elemental Shield can be active on the Shaman at a time.]
    lightning_shield = {
        id = 192106,
        cast = 0,
        cooldown = 0,
        gcd = "spell",
        school = "nature",

        spend = 0.015,
        spendType = "mana",

        startsCombat = false,

        readyTime = function () return buff.lightning_shield.remains - 120 end,

        handler = function ()
            applyBuff( "lightning_shield" )
            if not talent.elemental_orbit.enabled then removeBuff( "earth_shield" ) end
        end,
    },

    -- Talent: Summons a totem at the target location that erupts dealing $383061s1 Fire damage and applying Flame Shock to $383061s2 enemies within $383061A1 yards. Continues hurling liquid magma at a random nearby target every $192226t1 sec for $d, dealing ${$192231s1*(1+($137040s3/100))} Fire damage to all enemies within $192223A1 yards.
    liquid_magma_totem = {
        id = 192222,
        cast = 0,
        cooldown = function () return 60 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "fire",

        spend = 0.035,
        spendType = "mana",

        talent = "liquid_magma_totem",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            summonTotem( "liquid_magma_totem" )
            applyDebuff( "target", "flame_shock" )
            active_dot.flame_shock = min( active_enemies, active_dot.flame_shock + 2 )
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    --[[ Passive in 10.0.5 -- Talent: Summons a totem at your feet for $d that restores $381931s1 mana to you and $s1 allies nearest to the totem within $?s382201[${$s2*(1+$382201s3/100)}][$s2] yards when you cast $?!s137041[Lava Burst][]$?s137039[ or Riptide][]$?s137041[Stormstrike][].    Allies can only benefit from one Mana Spring Totem at a time, prioritizing healers.
    mana_spring_totem = {
        id = 381930,
        cast = 0,
        cooldown = function () return 45 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.015,
        spendType = "mana",

        talent = "mana_spring_totem",
        startsCombat = false,

        handler = function ()
            summonTotem( "mana_spring_totem" )
        end,
    }, ]]

    -- Talent: Your next healing or damaging Nature spell is instant cast and costs no mana.
    natures_swiftness = {
        id = 378081,
        cast = 0,
        cooldown = 60,
        gcd = "off",
        school = "nature",

        talent = "natures_swiftness",
        startsCombat = false,

        toggle = "cooldowns",
        nobuff = "natures_swiftness",

        handler = function ()
            applyBuff( "natures_swiftness" )
        end,
    },

    -- Talent: Summons a totem at your feet that removes $383015s1 poison effect from a nearby party or raid member within $383015a yards every $383014t1 sec for $d.
    poison_cleansing_totem = {
        id = 383013,
        cast = 0,
        cooldown = function () return 45 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.025,
        spendType = "mana",

        talent = "poison_cleansing_totem",
        startsCombat = false,

        handler = function ()
            summonTotem( "poison_cleansing_totem" )
        end,
    },

    -- An instant weapon strike that causes $s1 Physical damage.
    primal_strike = {
        id = 73899,
        cast = 0,
        charges = 0,
        cooldown = 12,
        recharge = 12,
        gcd = "spell",
        school = "physical",

        spend = 0.094,
        spendType = "mana",

        notalent = "stormstrike",
        startsCombat = true,

        handler = function ()
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Talent: Blast your target with a Primordial Wave, dealing $375984s1 Shadow damage and apply Flame Shock to them.; Your next $?a137040[Lava Burst]?a137041[Lightning Bolt][Healing Wave] will also hit all targets affected by your $?a137040|a137041[Flame Shock][Riptide] for $?a137039[$s2%]?a137040[$s3%][$s4%] of normal $?a137039[healing][damage].$?s384405[; Primordial Wave generates $s5 stacks of Maelstrom Weapon.][]
    primordial_wave = {
        id = function() return talent.primordial_wave.enabled and 375982 or 326059 end,
        cast = 0,
        cooldown = 45,
        gcd = "spell",
        school = "shadow",

        spend = 0.03,
        spendType = "mana",

        talent = function()
            if covenant.necrolord then return end
            return "primordial_wave"
        end,
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "flame_shock" )
            applyBuff( "primordial_wave" )

            if talent.primordial_surge.enabled then
                applyBuff( "lava_surge" )
                state:QueueAuraEvent( "primordial_surge", TriggerHeatWave, query_time + 3, "AURA_PERIODIC" )
                state:QueueAuraEvent( "primordial_surge", TriggerHeatWave, query_time + 6, "AURA_PERIODIC" )
                state:QueueAuraEvent( "primordial_surge", TriggerHeatWave, query_time + 9, "AURA_PERIODIC" )
                state:QueueAuraEvent( "primordial_surge", TriggerHeatWave, query_time + 12, "AURA_PERIODIC" )
            end

            if set_bonus.tier31_2pc > 0 and state.spec.elemental then
                applyBuff( "elemental_blast_critical_strike", 10 )
                applyBuff( "elemental_blast_haste", 10 )
                applyBuff( "elemental_blast_mastery", 10 )
            end
        end,

        copy = { 326059, 375982 }
    },


    skyfury_totem = {
        id = 204330,
        cast = 0,
        cooldown = function () return 40 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",

        spend = 0.03,
        spendType = "mana",

        pvptalent = "skyfury_totem",
        startsCombat = false,
        texture = 135829,

        handler = function ()
            summonTotem( "skyfury_totem" )
        end,
    },

    -- Talent: Removes all movement impairing effects and increases your movement speed by $58875s1% for $58875d.
    spirit_walk = {
        id = 58875,
        cast = 0,
        cooldown = function() return 60 - 10 * talent.go_with_the_flow.rank end,
        gcd = "off",
        school = "physical",

        talent = "spirit_walk",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "spirit_walk" )
        end,
    },

    -- Talent: Calls upon the guidance of the spirits for $d, permitting movement while casting Shaman spells. Castable while casting.$?a192088[ Increases movement speed by $192088s2%.][]
    spiritwalkers_grace = {
        id = 79206,
        cast = 0,
        cooldown = function () return 120 - 30 * talent.graceful_spirit.rank end,
        gcd = "spell",
        school = "nature",

        spend = 0.141,
        spendType = "mana",

        talent = "spiritwalkers_grace",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            applyBuff( "spiritwalkers_grace" )
        end,
    },

    -- Talent: Summons a totem at your feet for $d that grants $383018s1% physical damage reduction to you and the $s1 allies nearest to the totem within $?s382201[${$s2*(1+$382201s3/100)}][$s2] yards.
    stoneskin_totem = {
        id = 383017,
        cast = 0,
        cooldown = function () return 30 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.015,
        spendType = "mana",

        talent = "stoneskin_totem",
        startsCombat = false,

        handler = function ()
            summonTotem( "stoneskin_totem" )
            applyBuff( "stoneskin" )
        end,
    },

    -- Talent: Calls forth a Greater Storm Elemental to hurl gusts of wind that damage the Shaman's enemies for $157299d.    While the Storm Elemental is active, each time you cast Lightning Bolt or Chain Lightning, the cast time of Lightning Bolt and Chain Lightning is reduced by $263806s1%, stacking up to $263806u times.
    storm_elemental = {
        id = 192249,
        cast = 0,
        charges = 1,
        cooldown = 150,
        recharge = 150,
        gcd = "spell",
        school = "nature",

        talent = "storm_elemental",
        startsCombat = false,

        toggle = "cooldowns",

        timeToReady = function ()
            return max( pet.earth_elemental.remains, pet.primal_earth_elemental.remains, pet.fire_elemental.remains, pet.primal_fire_elemental.remains )
        end,

        handler = function ()
            summonPet( talent.primal_elementalist.enabled and "primal_storm_elemental" or "greater_storm_elemental" )
        end,
    },

    -- Talent: Charge yourself with lightning, causing your next $n Chain Lightnings to deal $s2% more damage and be instant cast.
    stormkeeper = {
        id = 191634,
        cast = 1.5,
        charges = function () return ( talent.stormkeeper.enabled and talent.stormkeeper_2.enabled ) and 2 or nil end,
        cooldown = 60,
        recharge = function()
            if talent.stormkeeper.enabled and talent.stormkeeper_2.enabled then return 60 end
        end,
        gcd = "spell",
        school = "nature",

        talent = function () return talent.stormkeeper.enabled and "stormkeeper" or talent.stormkeeper_2.enabled and "stormkeeper_2" end,
        startsCombat = false,
        texture = 839977,

        toggle = "cooldowns",

        handler = function ()
            applyBuff( "stormkeeper", nil, 2 )
        end,
    },

    -- Talent: Calls down a bolt of lightning, dealing $s1 Nature damage to all enemies within $A1 yards, reducing their movement speed by $s3% for $d, and knocking them $?s378779[upward][away from the Shaman]. Usable while stunned.
    thunderstorm = {
        id = 51490,
        cast = 0,
        cooldown = function () return 30 - 5 * talent.thundershock.rank end,
        gcd = "spell",
        school = "nature",

        talent = "thunderstorm",
        startsCombat = true,

        handler = function ()
            applyDebuff( "target", "thunderstorm" )
            if buff.vesper_totem.up and vesper_totem_dmg_charges > 0 then trigger_vesper_damage() end
        end,
    },

    -- Talent: Relocates your active totems to the specified location.
    totemic_projection = {
        id = 108287,
        cast = 0,
        cooldown = 10,
        gcd = "off",
        school = "nature",

        talent = "totemic_projection",
        startsCombat = false,

        handler = function ()
        end,
    },

    -- Talent: Resets the cooldown of your most recently used totem with a base cooldown shorter than 3 minutes.
    totemic_recall = {
        id = 108285,
        cast = 0,
        cooldown = function() return talent.call_of_the_elements.enabled and 120 or 180 end,
        gcd = "spell",
        school = "nature",

        talent = "totemic_recall",
        startsCombat = false,

        usable = function() return recall_totem_1 ~= nil end,

        handler = function ()
            if recall_totem_1 then setCooldown( recall_totem_1, 0 ) end
            if talent.creation_core.enabled and recall_totem_2 then setCooldown( recall_totem_2, 0 ) end
        end,
    },

    -- Talent: Summons a totem at your feet for $d that prevents cast pushback and reduces the duration of all incoming interrupt effects by $383020s2% for you and the $s1 allies nearest to the totem within $?s382201[${$s2*(1+$382201s3/100)}][$s2] yards.
    tranquil_air_totem = {
        id = 383019,
        cast = 0,
        cooldown = function () return 60 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        spend = 0.015,
        spendType = "mana",

        talent = "tranquil_air_totem",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            summonTotem( "tranquil_air_totem" )
        end,
    },

    -- Talent: Summons a totem at your feet that shakes the ground around it for $d, removing Fear, Charm and Sleep effects from party and raid members within $8146a1 yards.
    tremor_totem = {
        id = 8143,
        cast = 0,
        cooldown = function () return 60 - 3 * talent.totemic_surge.rank + ( conduit.totemic_surge.mod * 0.001 ) end,
        gcd = "totem",
        school = "nature",

        spend = 0.023,
        spendType = "mana",

        talent = "tremor_totem",
        startsCombat = false,

        toggle = "interrupts",

        handler = function ()
            summonTotem( "tremor_totem" )
        end,
    },

    -- Talent: Summons a totem at the target location for $d, continually granting all allies who pass within $192078s1 yards $192082s% increased movement speed for $192082d.
    wind_rush_totem = {
        id = 192077,
        cast = 0,
        cooldown = function () return 120 - 3 * talent.totemic_surge.rank end,
        gcd = "totem",
        school = "nature",

        talent = "wind_rush_totem",
        startsCombat = false,

        toggle = "cooldowns",

        handler = function ()
            summonTotem( "wind_rush_totem" )
        end,
    },

    -- Talent: Disrupts the target's concentration with a burst of wind, interrupting spellcasting and preventing any spell in that school from being cast for $d.
    wind_shear = {
        id = 57994,
        cast = 0,
        cooldown = 12,
        gcd = "off",
        school = "nature",

        talent = "wind_shear",
        startsCombat = false,

        toggle = "interrupts",

        debuff = "casting",
        readyTime = state.timeToInterrupt,

        handler = function ()
            interrupt()
            if time > 0 and talent.inundate.enabled then gain( 8, "maelstrom" ) end
        end,
    },

    -- Pet Abilities
    meteor = {
        id = 117588,
        known = function () return talent.primal_elementalist.enabled and not talent.storm_elemental.enabled and fire_elemental.up end,
        cast = 0,
        cooldown = 60,
        gcd = "off",

        startsCombat = true,
        texture = 1033911,

        talent = "primal_elementalist",

        usable = function () return fire_elemental.up end,
        handler = function () end,
    },

    tempest = {
        id = 157375,
        known = function () return talent.primal_elementalist.enabled and talent.storm_elemental.enabled and storm_elemental.up end,
        cast = 0,
        cooldown = 40,
        gcd = "off",

        startsCombat = true,

        talent = "primal_elementalist",

        usable = function () return storm_elemental.up end,
        handler = function () end,
    },
} )


spec:RegisterStateExpr( "funneling", function ()
    return false
    -- return active_enemies > 1 and settings.cycle and settings.funnel_damage
end )


spec:RegisterSetting( "stack_buffer", 1.1, {
    name = strformat( "%s and %s Padding", Hekili:GetSpellLinkWithTexture( spec.abilities.icefury.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.stormkeeper.id ) ),
    desc = strformat( "The default priority tries to avoid wasting %s and %s stacks with a grace period of 1.1 GCD per stack.\n\n" ..
            "Increasing this number will reduce the likelihood of wasted |W%s|w / |W%s|w stacks due to other procs taking priority, leaving you with more time to react.",
            Hekili:GetSpellLinkWithTexture( spec.abilities.icefury.id ), Hekili:GetSpellLinkWithTexture( spec.abilities.stormkeeper.id ), spec.abilities.icefury.name,
            spec.abilities.stormkeeper.name ),
    type = "range",
    min = 1,
    max = 2,
    step = 0.01,
    width = "full"
} )

spec:RegisterSetting( "hostile_dispel", false, {
    name = strformat( "Use %s or %s", Hekili:GetSpellLinkWithTexture( 370 ), Hekili:GetSpellLinkWithTexture( 378773 ) ),
    desc = strformat( "If checked, %s or %s can be recommended your target has a dispellable magic effect.\n\n"
        .. "These abilities are also on the Interrupts toggle by default.", Hekili:GetSpellLinkWithTexture( 370 ), Hekili:GetSpellLinkWithTexture( 378773 ) ),
    type = "toggle",
    width = "full"
} )

spec:RegisterSetting( "purge_icd", 12, {
    name = strformat( "%s Internal Cooldown", Hekili:GetSpellLinkWithTexture( 370 ) ),
    desc = strformat( "If set above zero, %s cannot be recommended again until time has passed since it was last used, even if there are more "
        .. "dispellable magic effects on your target.\n\nThis feature can prevent you from being encouraged to spam your dispel endlessly against enemies "
        .. "with rapidly stacking magic buffs.", Hekili:GetSpellLinkWithTexture( 370 ) ),
    type = "range",
    min = 0,
    max = 20,
    step = 1,
    width = "full"
} )


spec:RegisterRanges( "lightning_bolt", "flame_shock", "wind_shear", "primal_strike" )

spec:RegisterOptions( {
    enabled = true,

    aoe = 3,
    cycle = false,

    nameplates = false,
    rangeChecker = "lightning_bolt",
    rangeFilter = false,

    canFunnel = true,
    funnel = false,

    damage = true,
    damageDots = true,
    damageExpiration = 8,

    potion = "potion_of_spectral_intellect",

    package = "Elemental",
} )


spec:RegisterPack( "Elemental", 20231107, [[Hekili:T3tAZnUnw(BXvQXTusBzj5JojvBVv6Rz7mDMjvuYoFyR1uusqsCnfPgEyhpJJ(TpV3d8aeeaKuIs2DM8LULjbXX7(ca3m4MF(MrZSJy38xh2F4zdg0)v9gC(zFZ5dVzu0dRz3mAT90BTxa)WZEf8VV3LTI5fz7IV5bxF7zype6hhmfE7YOO1HF7PNUWjAz8KEt9xDAOZQyx7ihFVPb2ZJW)E6P3mAsSJB0h9UzI6HFa0NRztHhFjmtw6mBgJ3ww40BgHT9KbdoP)R(2nJ3m(dXbrlzbBgpOFVHBghVg7XWEB((nFFwlVGA5VqVAZ45(jToVr9V4KH9)20MecTjWF1MXJCw92nJ74VM5HJWBFh8gBVzBg)3D8Mbtr7BzbVaE2NSVZEZ4FIfghSG5nL1Tqppah(3579IOnJN67fgVcMeH(4)ojE(C47VhGyWkX1gF2OL(tVTqh0)YVnF2h5NoEVjoie6Y1bo(boro)tcol8HNFYWHkxtjOK3IOKcTNMPV1piGnf643pDjmw(ZHXCjmWjiFOJaca4h9aIGa)5oUaQ)lGxdlSaOz3ZSx77TzmahwA7bDJdc0wV21Hndgm7P4qh2Bnmg(RMyh9vxD6CCHh57TiMzX)8x6m)QKrXzfmk3XMzvUv9yE2tCzZu3RUolwg554TWkCPdZDg2Ni8UN8l6nZ)EVJ7qVJzdutIp)XhtMhSuAFl)GjorPJDx1dUy)OFGJxFS6r9yZdQ6XCTp(m1VlmYpy1Tm2AGowzdCMYMhh8asnGiZFLnnocgOXS7yWthh5GKMeDa81ideHwVZ2XfNr9OV6JErSGG41rCQMP2HrH5OCyqUhyBGLjSCfF6AKRbbsHSOia6e2BPFyeqxznZbyYCfB7Iagqmhyv93qKK4CBZ4v(b0)EhbmlmJcx7a8o3B7cCYHwlcSNYEj0qOhVAa29zFe0Tr2aR91xk(5tC99bktaWHn(OeSMD4uM3mS1PiShFKWZcViE9Jpo133fX2IppGTY2Xl86l6xyCGzhl4wyA18XrSFM7eWO5CZ7MMmDXxfgfaKTtTDD3VJ1e7fw(ZTIcCMEByvd1rMbpXHmlNi2QqXhccDy(fiyHwSgwFz814I0kJ5wQpVJb0Jbwr(Wxj(Cp7iqEzOv49oZJ8yHfgtjwz4jbXEw8)cgjySrfYxz7ZEziUYJ4uRydUJzbARw5WcVE4XDqEbxRiBGBb4fbjYoE5Z0Rh(4JfBGlWrBnHzV66HDRC0dHUay44FBIGJ)ciIzZ4halcqDDCCiiOiW31fbn5YEGP(vi1OvMiUg)9PI1AHUGlzKOEimQWdj05xqA3Hv54p9d)mAiai7d6tqqM7d8FU2pm0HljSy)tiENPwGS2eEHmABxN)rSZmRv2lwzZjqYOXp)ITzTuUdPEb0tZSNv0adWsje)b)fkjLlW(h9VhwVz2QCpi)o3gLjWcnaHbWV7K(dBuW6cFp2lX2bFZhFHR7MX3st7OL2WtC9x4mDZyWenYSOItyW2fq48mhqsX923XE50hMMrrfYPP5iePgMP5KS4c5)xtZD4XjiqWEduBey3qc1rykI83NqJeHEZGXY9bRaFa5lS0teaECQSrjWw2R)pAy3kCwgqktwY0d7YTIlWFwUfznf6a)0dDxHBr)5jUL8P0ohHcoUZYCoOcpokbpiRLbBTGPGkyraBoa5xIZDDmsMwUPV8(8zvOfP8iiFkL22z(r9eMoPY4EnFc1dnTeewbgUXozWLhxuh2RVyBGSPq1l3dGLogPdYCxi82hMeKayM7a2qBndwqHzqLUnbSCrkur6BE9LgGo2lWUJ4BUh9zJ0sdArIjF4CaO1pqe8kDX7EuNwiWdmL8cOvaOTaB2EhOHlYf2Ri3gq(Z3rYtbonsGAgec962FAy7cy2nz3ThK5N4tT)dMBttJVUVj4ZFWVTvGT)dHJZmS57)LrGBfV7VbM98ZhbM4KejvNE3(WQtMoZJcMkmvcavIN6Gbr80v(tCCzN2VF)t7p4RpDW5V60rlDST(K9By(XZTS((4WiR35B9XilRFa8N8okOFGzpJwZytxA15Vf4SWbFW)JZmMV1KhY)2F6p92Z(tV5sVBVL)dllRFooWJf01Q)jNBfonGX8GfsuV))1lKXd5UxtRT3AJmffczjI)qg(uxBCwTIbwKfXqe)CW5g)7pbXZVhJl2)ig4RtndslluzFHixzXXtfXGg0XXPozb2XaDhxQe1tenqdmwK(snncLRTYM5cUU7V66RUS)jx8LPb87bwAZjFq7fy7D7jdtF9CaYuIqSBUusaV6ZcXwqbkdM1EZybORI1IDpjwm67L414GvoikswTD9zPGPyVag(dCGa)FTx5e9q(Ov6RoAl(SRoRlrN9lHPrOK3jHe1vUuv0DeNzjp0X7ogsj67HKCdq)3DOGvdsGCI(VWyzIDggKZP28o2jK8izc8haL87(XrBgpJbmcWRlr8XYiCfJiv1yNsaKkcGZz6dGZVJGkzTmlA4tCbolnqTRQcQDLEO2ZFAPkzqF6N)zMwl4m7p5pJl2hTZzLT3dPwifwr4ZKW5QKLxfD0tpePI1uDxdzPFfuK6sAvXzaQfXBbQumAPTxrLMz2KEwg8UoZMsmu1Mx9Phw3UuFjjMtJjLvbvE6HggwpnA()XK0ds(XqZ0PiTg5IdT2MhZNeES5orP5A(94kmWb8iBwI9(a534popnLC5ib8VwJXcKwSl8Ox7ebT()gqJzj5(bUpcgOMtYJzE8(kANsUMK0jghAKB5whJ(djhDQQm0lZd1kC1qTjnPKY(yar5Mk)HaFK(iX5jkfRCsB2Q1C3XZPXFlQ3tGrOkQ95yFNtDOc(rpkbgxt45rZyCLwLBdcFk0JPUqTykAv7ZimXBiVvgjKfDDoKWY8PNOup5C90QBNlkrTJdikYZfaIoRV1W1tTqFxd65X(1i4NtV91NDCilYAIVxCi4xllG3SUcUX86D1lMtg0VRMG)kc1Z14LukoaWj2Dgx(xCyHAmrekdg3Lz(KIS7TJJHKfMMgP0G)NsV8dPqWTzClV2iyAkWpd7KX6QiD6OmecH3(tpDGfTtsAk8DPgTCPGgcm5iCLgLdaP88iL3mjMda4zZ4aBEvIXTrsiAeMHPsoKD1L6cuz9GUT2stw0EtwGkWk1DzYjrc8NQnoDH1ZOZTs0319neqMkeRtFOX0vLS6ERFsf6zkATsKx1GVuVK46r5Wb6gMt7tOEj)bQLoiAE)NtcTR992pKKJt9uojH49(LWiDhUo5G4e2IvaEluksIC(g285otDWzKHv8EHU6zGfY6naUAJZuRV9j1QZMBHPrdmvSeRIv1mVOrzPMsjrwzfAo3eMapPDrtl2QcvQ1xXldWTTQPK7lvLGvZRvk5EDBRAQCNgY5LtPtsEJQYBrxePhuvayhOpaSd62D3GSLxOcm1726tsq4v9F8rDzZ6YwgOKlX8hZQeNnJ)723XseIepDzrYeU(wsAewiro8IJz(8qdWUDPCGmxfuA5PmN9rjvOdowmDKD0b8Zi6LNMjn4XhtJmNCdYYn0rAmyTtL(l3rvTqMXGPly85Ee(n9p5Rn6r4Jp2a3h72vG0jjfYHC9rzKhLTFwuzmwjAHj62qnWCR4g5)JOw5P2XHm(Zr)Cw4tKzuIkZm9gDOVGJIO1mkgt4798JsJ3xb)Imr1KtLuI9uoXq7glygo0STnzrmrvLuBMSlVWmaX(yKBOvt5EMlBdM8RMumFMBv0lY4weFrcNYv97MZSOoH(fJ5w5QuyvSBKZAxrRY4HPfjYIsJTl0HmXs5Gx7IsM9vWUTTtsICT7WBzcbsltVuqw1ZDAhnY7ukm7iZKm1JI5F9(3C6O7zK68tjXjYvX5VHYnSdqju)fuUJ3mSeHYKnTKu(X88JXqDVkpIlr(Fl4IWB2m(6e5uJ(lwFI)NF6o())(3uLTzY12EXa6QeSiuCcdgCz5nJurj(gbrzVnbajeUNm731BsJyEN0hQZY0tf6LCKKkCt4VLOtPyiatXn2UO4GhqnckvWmHcmC1gZTTOcDuZ7DywBVq6yMvkNvtdzwgFF5LC(E0ZWswLyNc9sx9R58Lx(sUndICzl)tZ4XeF3inrt2ui6AVzIHGHUJkvukp2ins7U0QomOpnlqEQMcvKQj)O3ZdowI9LIvKBL4W0yGPCwvH5wvuiKzkKRmAGTgYRECivmVnVQFgoHpQ(q6)Lk9CQ9vPTxsLuwLk4wvEC1pzZt8)MXF8djXo2vUHgMFnksOB3C8ha5bru4ovei3TykVZXcTJ(yHMgtHHAY5(vus33o4qwTDRemKe6V8Q(Tax1HhijyE7f9pUgqSVeankfNBgA9uPuDhYb8XhjLO)bwNVEA1wqpAndLEW(1OaB50fG2sJU(UawNHjMvtzeXEIJlvtp0EaGsuc8dSQdWa1WWIqsi4oPA7ePDaGJzDFvqRysg8(Y06QCNQqPHpqiEAV6IJZdcEMo9mCiqJkeqTRV68Vr4BV8mnFl4BtQxSJ(d0BdqV1b9D2LcOaquttqFdpx4Bp7RRc9vX(dvutF((YneXB(uPf2RxVFXZfpgcG)G6bjYGe7d4LUifWcNirz6YfNAZmiTImZNh1564HNbpe1Xuwa0FzntWDHpcqrC9igQn72nSCv6YmNYOqo0PytdtlGg4xIa2Z)j7Pf5x9(Tz)J5RNv11eApAnwTrCy(eEnkGMh(D57jQXDqjMbXEC4B5I6(K04kZD77NpBWMXNV(LWtXk85Ehmyv2U3B)qyxU03SJaR3WEWpronZl0H4SdXYbETlZCEieWk8NzzOCjgQkv5iQsLTdvd3Ydn0C(cbiWX1roKF(eRSLKfFwaZ)xpmrZ1hCWqUZvw9Yma2VvezKuWifGPYzCmVSn6eNWpqpYaY6Rq)YJjNaWG)7G14XCBx3UTkWwvu26uzaZYiStNGw48ZcNE5a)JmzdRCzFkynOiq)3sJAbpl3Cv8V227HOLOumXay0QGLAX4w7OB0qFEkVIfQvYrI23Kg6MulLUp5SGZoRUaYnsVwGNwBPlASYRUOG(mWCLkzCtEVHy7NBcZvdoRFEcCJEI2peJ)UzZCq4lWd8qT3rn()5r9kpuZ4OrkVXIB6guSlh5LMPqdy1gU7UQKRxUENgwU8neYJUY9ku09yHDXBnS8efeYZufTtACbskp6ejml55yCLEpn55)(pJtF00J05FDbdTQzs1FZlvfbVHPFXpaxdDQRzfMzr7Ai(ejXOeDm)9UazUKi5VB96eA8YHKjp)w4NqoGHyScQk5EFfMy7hfX5PU(HjeacPPeeKTJ(OPxcvUaKbdu7avY00AEaFgy7(6b96xJWavbJu1QfEhBUDSBepfTGaqM(GzbUI9pIb0tyQUaUDZuZXQXZeRrzAlZWSCRHBwyPe2CykuX))om6)djMcpzQlZ(oA1vmqafu1fIYfIIYfIcyPzyyMqQWcKzO4YHQQz5gsivncFxSdODDDJGVFWbJykVKO)P3Nu9Z1ZaGMzFunkHzf18BwbnhhAtUowUUM51Omx2FQie7Pt9xT22Je3Gq8DhLo3n(xTwXCJkiRMACHxjDiL98AT0PA6ZAejAnXU)sbD6fyU88dwXn1HZDoxGLg3RSz(YRR0lrdTkjptYQGP058lb6emu(n(UrQkDtfr4RMu9nyplm84OdvydQ29R6yaGC5eutTbC0EAKCiRQnSdU4kDCYCBP8UicLBNut)enpq48l5Nfh4H5sYHXrJYRoTc1NvIe4KPd9J9G43TgQvIgVfaAAYL6obZQmZOcbSsbLqAE6k4LeDQptOIEOmgyXV03d1GzJ(CbcEVZXpom)qj3iRDnLyQs8V4XYT29fIj95CAGpwSe842UGN8qKjVGTXKhEOtmboH3Uj5yTE9Acc9P7EZltYKr6NI2Y8HGrN(jtvL3Uzq8rkIr6r1hyOux6wywTbXQB9k3WuCVHTKj83cbBndx1PDb2Y7z62qY4(aoxjxHgjGpTa3CRQKSJKmguWoYzoZiGsYTvqHaCT9Ic2r(AA2)2u7UklI3onypjucCX7sBPYu)3K061m(K2Ng9doUU0gKgBggxpkHiBeVscYEgHlM4hfHAZr)0RnzObm3USZ(QvN5O52h4lkLaEmCBuuKtAoAMpcDQjHx6iEZO7ybykwYUpwU4Mr3BhGqJWBg9ZiueOV9X6yN8A9f2(SxGNLZuOnWIhJUutSJbaTn5OpGx94M3)jk8idhqxWiEWarV)frveAUxWd2uLTlLKhAFNb)A38bC4HEap)qpGxCWgWnF)hj0pomNZTd0NCpKFpFCZi6x4vceqya)3FLUGHs6MBEd)c8jWzn(z3mQI9fj0jt5nS4Uv9MiG8Sv6xPDUk2XNj1XfAk37SMoAqtbfyo23m6iUAdjx9WH9CndBXDbR0ix3nzR4uOgBIwAxLC(f406IwbmxEOW((snlzPnfemLfLPIKukGOL3eNBgFCk0UubYJVkdxOCxEkTuB0Pp(E9uVhHCV6aa5IQvGdtaKjnwtjT)zo0(RpCq7kQQ7IqBLo1(Sgs(nAGKcg)ygkkAkvfS3MasInOo3Fbu71eNXnJFDwoEfoVNPA4zWL0xw00x6dUyxWtBA37nceZmO)be10PsQ4nJF8XCPkvCYUVzC3TfbDHi(r67PV7YDdpLFsLtazzJH2zGCRj24jgaUFo48jyUSHITfmVTum(0b03(JDFcWQZq5TgW(zKedTFiy4C)sgPVT3LgeywNJbBny(zImJwaeUhLAi73tBb1FYLA0cG9DuUHSBFfgYpRVfmYjtYltxAjRZFT8iuBMysls74ChV5LpFUG0crfV5m(MJ8EQqzHka76RamC)ukTVmB4uEs(qnBOyZuEGWMkNUG4)kJwv9KDHQlOfPXts)ctaQ5fV5qfueNzE)10bWyoa3ycAP5H2E4ODOtUI6KUsmyhORIfISxNJZ5v6P0K7PSUGLCwVreBAXFDsYoHUSCK2ue)PjBhPnPlbs15b9V7aPcTxDX1OeWFv9b8xvnG)QCa)qD(h)ShWxPmoA5PZZujGVz1u1fb)mcsTzNURiiqNohmlb6E2SO3kCgUu15YN5LAn3HfvCNLioP1Y23aPm0csNZvc1b9FqYxMKxN3rfaBpBwWBf(cxM6sqvs5zOAj(KDeqx1LKIQCru2u2CvUAk2KuLRvgxavX8UU(wiejNA4VSo7ErmOohVeQ9bnHkBpDYxxp0Gura1muZriPpxRVY9luUNpsLqoHKwmDgGA(vbhF(mbvRZzJ2Wh7O23ZzfLbqc0q99Vcbw5k5uDpSiGVe8j)17dxYX8A1pD8uH7L4OAL7nhcfRZ5Nmt2L5LB2j3vjRMlxLgNPZnaj3l2)teDgSRdwStxQlLMqAlk9CXxLpIHipzZoMHOvHoBNndopqRfAgQZKxDW5w76DPE3CnMSkMIixocrDMvQpUsNTYMXvTg8Ojx3n7cuHwR6mWDNvMGrzpFW1gJ2AOlK6GkoZCK5B2IBThcCOZqyDmbB1fOtjgtZ6qRpH7El67zitT(JwldhuILA418dTqRJjqfgQd8nZtZaQ7chcbo0zUWZq33u5IQzd9vA4fSQpxBH88CWLNT3XMk9QXemr2yjPjuLsruiWd7wY6fTQbZhpSTKDe8YSNeVWFRvYt2XmmlpyNx7btKOqSpajff2Va387Ps5(jSMQLDQ2wExhlYsy4A8rBEdhKocvN3PbvN3PbKFEKd26m)trTD3qmyjrFTduPuHrDfPzbBHPQN4YdiOfHR6m1SnRU4gv81T0fZeU20z3yrzCMcRphMlxmnDmJcR6ktIJCYZvGMBHK0yCCKrhO6uRG(GdOqlLd8tbHcMs4zXG78n8G7811i4o4eyRJmu3eXaLPbJ0VzekGKltH9z293Kc6uncyuyiYEr4HevtvUmkeP1YxipfETw2bXkSu5fZtHMO8Y5rrb1S9Hk10n3tk2ORmZUUIQJegRZdQABuMosduQK4TZ0bMmrHa0pxjBmik2G01JQh1sDjvu7a1(((cdPq15uR(TN4t9DtLk7ukNYld4oPImCqYUQPgAlRapk0cThFLPtoZMMwSUdQkdrLzyk0JiAw7(XPc88E)6TANXMM5Fp0Gz9rgyRwCDQJ4JIcz0s)kituf4q41MbgQfrl1BDvtHfPyd0ugejLEQSEsQkO1MkLcN3c71uNzGcKMIADYT9ZW4Ht5VbDIgPujiIo3t3Bj88Ze4I5uIOiw7B5D6vDiORNL0vTSe1hwrclImTNgoWCZ1Azzg8qRhTjp55465OMGP0w2eMwzT2Lhw51SsD)PA6uvLruqI1zqK6S5SlxNynpzmvo51UXF1MuMw8UgRDsathtjGrm6BdnwHzxvQeZQe4PDh82mG3E4ckRDGSs(3Cbpgs1gy)LcqudA1QemlBE2tMk5wO4IsfsQ6URqLvDrgQfCdKzpFVo0QIYSATphcxWKys06hVIDA4azwhGz4v80Rz4k2IOsY4wKIjo2VN)nk63lpZq)sUoZlbvTBAyduqpBVX1EErb1mQJZUubwmrU6UqDm8Cf97zFD9OoAShdp)Up3krtur9NLIEQf(U(X7qV4ef4SlBqLyPSdsWVCTXg3RWhFWcPFndHK5nbHwcVNKRlov1tr17P9dnXvDD8QHOizNpLsVWZ47to1Ktt1wGv54nL3Ry1gSL2l5Tv9nhhVhvF7XLAbDx0ppKzZYzU5ktCiHTKDOUOk9NNxfDvHN0hU7o1cHiXCO)6MtOQkm5sc1g1MV3eCvPnSHECvtUb7QcAwtzeh38y3P2)TMbtmV3ruOq4aE53TpHILnue9yqHk)etfRbzFHqyurwefnBeZJjqBgzypW8S8Kf4P62ZRKkLkTeREITuyYwEiSuBmhPXw7(cYmw7aFz790eeNIo41ch1heaxo8m5RSon1SSQevKC4WzOCZfW3fNY0uDBIdWZG7VVA5XVzjSf9mEWa9UCx(gzG)j96lkrTEXD3e3DvAoJmS9MKXTfXzT5v)xjqF92Y06xsKpFfKjPQk)1VLHmqQ(KCLawfTz9OxQc0wn9YHZjFc9y0td1xEG1000k2)unYGY2zph1ExqF1Kyr59LIO1Ks3SG0sT5zY7jDP2PUSg1oDtgYThT5j4BweDg1wGMCl3ZLdlWXFGd7tDDaUUMHix7uLTz8ZYlZrIi4SckHKvMwqr05B3UlFRVa)2HR9WsSCMZxzcbH5ZVXdPsLZ1U52DmupiBnKE7VQeBFanT8VuKQmR6rksnUnNBq757qX6lPxTEnbzDvOkOstG4Krn30X94LkxvqN6z5NMKmCuZHCATTyh8fYGMocHiBS4wBeKACjmexSDh)n7d8EPlTXM4cLrSDN9fsAJMZmP9MK(l0gOxts63hylDCPphXreKR51C2oFfrwfdBljfIwE6IEPz(4919i5bpmLemq2ItjFR3L7wsTCA44sMFvRdNH6UPd1FsqCHCOTkny59sPBAscCDPM5t(cahgz7LknmfbU18URudBN4qtcVO4WDtvNqfFe357bXRJsfzfgjgTeSuwGrGzt76f9B6LqweYee2BjmLCGfjaUaIK8oAnkOIIEZ23hu4YbbJz9LmX6UGhdx7an(EBxQQDwaYkLZvX7PEpL)nRdLX6AxF5sG0TNrjbCs5AgFEMuDnv4jybs26yIRV)mlY89OYN1a72SryuaGel4wCzhvEZUVBJsZxZO)(06gNmYwGFONm4lbxWax6PZrLOY7o1MmJuwbcc4b7fKs7ahqFhow8Tiz6RJdzwWyTkusciFh(L2QvSiMFGCt0ZSttiCXLRNPWKcgW1mEwFguiAh3Xag6G0ZdLId35In0ZokgeEBfEVZ8ipwyP5)fITETp))l2e9K(k0MoS(AthwT2uE1ZeIyLisRu6mni2ZI)Bl8kHLFXWA5ztNMs(MVwum9TfpvIifaG7Yt9xnXwPkGckVI89weZSUNzVgFMKmpWctgUzSXxIjKfajEjXRamV11rAZSKqoNyl3mRYJGOjxvqJLBNq4shM7SEipykMIhz2KK4i82IU0NeDn)GjofQVmf2IW7fZ6OupTeDNwXm64QMq5ZgXVotdNr68cCcf2h0fAw1X3HOASJJwIIcg5Sk2LUrGEBG9C(lV5F)d]] )