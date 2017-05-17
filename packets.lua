local packets = {

  out = { -- outgoing
    PACKET_NPC_INTERACTION = 0x1A,
    PACKET_NPC_CHOICE = 0x5B,
    PACKET_IDX_UPDATE = 0x15,
    PACKET_TRADE_OFFER = 0x34,
    PACKET_TRADE_MENU_ITEM = 0x36,
  },


  inc = { -- incoming
    PACKET_MENU_INFO = 0x5C,
    PACKET_INCOMING_CHAT = 0x17,
    PACKET_PARTY_STATUS_EFFECT = 0x76,
    PACKET_PARTY_INVITE = 0xDC,
    PACKET_FIELD_MANUAL_RESPONSE = 0x82,
    PACKET_NPC_INTERACTION = 0x32,
    PACKET_NPC_INTERACTION_STRING = 0x33,
    PACKET_NPC_INTERACTION_2 = 0x34,
    PACKET_NPC_RELEASE = 0x52,
  },


  INVITE_TYPE_PARTY = 0x0,


  CHAT_TYPE_LINKSHELL2 = 0x1B,

  fov = {
    PAGE_REPEAT          = 0x8000,

    MENU_PAGE_1          = 18,
    MENU_PAGE_2          = 34,
    MENU_PAGE_3          = 50,
    MENU_PAGE_4          = 66,
    MENU_PAGE_5          = 82,
    MENU_VIEW_REGIME     = 1,
    MENU_LEVEL_RANGE     = 6,
    MENU_REGEN           = 53,
    MENU_REFRESH         = 69,
    MENU_PROTECT         = 85,
    MENU_SHELL           = 101,
    MENU_DRIED_MEAT      = 117,
    MENU_SALTED_FISH     = 133,
    MENU_HARD_COOKIE     = 149,
    MENU_INSTANT_NOODLES = 165,
    MENU_RERAISE         = 37,
    MENU_HOME_NATION     = 21,
    MENU_CANCEL_REGIME   = 3
  },

  gov = {
    PAGE_REPEAT          = 0x8000,

    MENU_PAGE_1          = 18,
    MENU_PAGE_2          = 34,
    MENU_PAGE_3          = 50,
    MENU_PAGE_4          = 66,
    MENU_PAGE_5          = 82,
    MENU_PAGE_6          = 98,
    MENU_PAGE_7          = 114,
    MENU_PAGE_8          = 130,
    MENU_PAGE_9          = 146,
    MENU_PAGE_10         = 162,
    MENU_VIEW_REGIME     = 1,
    MENU_LEVEL_RANGE     = 5,
    MENU_REGEN           = 116,
    MENU_REFRESH         = 132,
    MENU_PROTECT         = 148,
    MENU_SHELL           = 164,
    MENU_DRIED_MEAT      = 196,
    MENU_SALTED_FISH     = 212,
    MENU_HARD_COOKIE     = 228,
    MENU_INSTANT_NOODLES = 244,
    MENU_RERAISE         = 68,
    MENU_HOME_NATION     = 20,
    MENU_CANCEL_REGIME   = 3
  },

  --https://github.com/DarkstarProject/darkstar/blob/master/scripts/globals/status.lua#L129
  status = {
    EFFECT_POISON                   = 3,
    EFFECT_PARALYSIS                = 4,
    EFFECT_BLINDNESS                = 5,
    EFFECT_PETRIFICATION            = 7,
    EFFECT_CURSE_I                  = 9,
    EFFECT_CURSE_II                 = 20,
    EFFECT_STONESKIN                = 37,
    EFFECT_PROTECT                  = 40,
    EFFECT_SHELL                    = 41,
    EFFECT_REGEN                    = 42,
    EFFECT_REFRESH                  = 43,
    EFFECT_INVISIBLE                = 69,
    EFFECT_DEODORIZE                = 70,
    EFFECT_SNEAK                    = 71,
    EFFECT_RERAISE                  = 113,
    EFFECT_PAEON                    = 195,
    EFFECT_BALLAD                   = 196,
    EFFECT_MINNE                    = 197,
    EFFECT_MINUET                   = 198,
    EFFECT_MADRIGAL                 = 199,
    EFFECT_CAROL                    = 216,
    EFFECT_MAZURKA                  = 219,
    EFFECT_FOOD                     = 251,
    EFFECT_AUSPICE                  = 275,
    EFFECT_FIGHTERS_ROLL            = 310,
    EFFECT_MONKS_ROLL               = 311,
    EFFECT_HEALERS_ROLL             = 312,
    EFFECT_WIZARDS_ROLL             = 313,
    EFFECT_WARLOCKS_ROLL            = 314,
    EFFECT_ROGUES_ROLL              = 315,
    EFFECT_GALLANTS_ROLL            = 316,
    EFFECT_CHAOS_ROLL               = 317,
    EFFECT_BEAST_ROLL               = 318,
    EFFECT_CHORAL_ROLL              = 319,
    EFFECT_HUNTERS_ROLL             = 320,
    EFFECT_SAMURAI_ROLL             = 321,
    EFFECT_NINJA_ROLL               = 322,
    EFFECT_DRACHEN_ROLL             = 323,
    EFFECT_EVOKERS_ROLL             = 324,
    EFFECT_MAGUSS_ROLL              = 325,
    EFFECT_CORSAIRS_ROLL            = 326,
    EFFECT_PUPPET_ROLL              = 327,
    EFFECT_DANCERS_ROLL             = 328,
    EFFECT_SCHOLARS_ROLL            = 329,
    EFFECT_DRAIN_SAMBA              = 368,
    EFFECT_POISON_II                = 540,
  },

  abilities = {
    PHANTOM_ROLL = 81,
    FIGHTERS_ROLL = 82,
    MONKS_ROLL = 83,
    HEALERS_ROLL = 84,
    WIZARDS_ROLL = 85,
    WARLOCKS_ROLL = 86,
    ROGUES_ROLL = 87,
    GALLANTS_ROLL = 88,
    CHAOS_ROLL = 89,
    BEAST_ROLL = 90,
    CHORAL_ROLL = 91,
    HUNTERS_ROLL = 92,
    SAMURAI_ROLL = 93,
    NINJA_ROLL = 94,
    DRACHEN_ROLL = 95,
    EVOKERS_ROLL = 96,
    MAGUSS_ROLL = 97,
    CORSAIRS_ROLL = 98,
    PUPPET_ROLL = 99,
    DANCERS_ROLL = 100,
    SCHOLARS_ROLL = 101,
    DRAIN_SAMBA = 168,
  },

  spells = {
    POISONA = 14,
    PARALYNA = 15,
    BLINDNA = 16,
    STONA = 18,
    CURSNA = 20,
    DIA = 23,
    DIA_II = 24,
    BANISH = 28,
    BANISH_II = 29,
    BANISH_III = 30,
    PROTECT = 43,
    PROTECT_II = 44,
    SHELL = 48,
    SHELL_II = 49,
    STONESKIN = 54,
    AUSPICE = 96,
    PROTECTRA = 125,
    PROTECTRA_II = 126,
    PROTECTRA_III = 127,
    PROTECTRA_IV = 128,
    SHELLRA = 130,
    SHELLRA_II = 131,
    SHELLRA_III = 132,
    SHELLRA_IV = 133,
    INVISIBLE = 136,
    SNEAK = 137,
    DEODORIZE = 138,
    FIRE = 144,
    FIRE_II = 145,
    FIRE_III = 146,
    FIRE_IV = 147,
    BLIZZARD = 149,
    BLIZZARD_II = 150,
    BLIZZARD_III = 151,
    BLIZZARD_IV = 152,
    AERO = 154,
    AERO_II = 155,
    AERO_III = 156,
    AERO_IV = 157,
    STONE = 159,
    STONE_II = 160,
    STONE_III = 161,
    STONE_IV = 162,
    THUNDER = 164,
    THUNDER_II = 165,
    THUNDER_III = 166,
    THUNDER_IV = 167,
    WATER = 169,
    WATER_II = 170,
    WATER_III = 171,
    WATER_IV = 172,
    FIRAGA = 174,
    FIRAGA_II = 175,
    FIRAGA_III = 176,
    BLIZZAGA = 179,
    BLIZZAGA_II = 180,
    BLIZZAGA_III = 181,
    AEROGA = 184,
    AEROGA_II = 185,
    AEROGA_III = 186,
    STONEGA = 189,
    STONEGA_II = 190,
    STONEGA_III = 191,
    THUNDAGA = 194,
    THUNDAGA_II = 195,
    THUNDAGA_III = 196,
    WATERGA = 199,
    WATERGA_II = 200,
    WATERGA_III = 201,
    FOE_REQUIEM = 368,
    FOE_REQUIEM_II = 369,
    FOE_REQUIEM_III = 370,
    FOE_REQUIEM_IV = 371,
    HORDE_LULLABY = 376,
    ARMYS_PAEON = 378,
    ARMYS_PAEON_II = 379,
    ARMYS_PAEON_III = 380,
    ARMYS_PAEON_IV = 381,
    ARMYS_PAEON_V = 382,
    MAGES_BALLAD = 386,
    MAGES_BALLAD_II = 387,
    KNIGHTS_MINNE = 389,
    KNIGHTS_MINNE_II = 390,
    VALOR_MINUET = 394,
    VALOR_MINUET_II = 395,
    VALOR_MINUET_III = 396,
    SWORD_MADRIGAL = 399,
    HERB_PASTORAL = 406,
    BATTLEFIELD_ELEGY = 421,
    ICE_CAROL = 439,
    FIRE_THRENODY = 454,
    ICE_THRENODY = 455,
    WIND_THRENODY = 456,
    EARTH_THRENODY = 457,
    LIGHTNING_THRENODY = 458,
    WATER_THRENODY = 459,
    LIGHT_THRENODY = 460,
    DARK_THRENODY = 461,
    MAGIC_FINALE = 462,
    FOE_LULLABY = 463,
    CHOCOBO_MAZURKA = 465,
    RAPTOR_MAZURKA = 467,
  },

  weaponskills = {
    COMBO = 1,
    SHOULDER_TACKLE = 2,
    CYCLONE = 20,
  },

  stoe = {},

};

local status = packets.status;
local stoe = packets.stoe;
stoe.MAGES_BALLAD = status.EFFECT_BALLAD;
stoe.MAGES_BALLAD_II = status.EFFECT_BALLAD;
stoe.ARMYS_PAEON = status.EFFECT_PAEON;
stoe.ARMYS_PAEON_II = status.EFFECT_PAEON;
stoe.ARMYS_PAEON_III = status.EFFECT_PAEON;
stoe.ARMYS_PAEON_IV = status.EFFECT_PAEON;
stoe.ARMYS_PAEON_V = status.EFFECT_PAEON;
stoe.RAPTOR_MAZURKA = status.EFFECT_MAZURKA;
stoe.DRAIN_SAMBA = status.EFFECT_DRAIN_SAMBA;
stoe.PHANTOM_ROLL = status.EFFECT_PHANTOM_ROLL;
stoe.FIGHTERS_ROLL = status.EFFECT_FIGHTERS_ROLL;
stoe.MONKS_ROLL = status.EFFECT_MONKS_ROLL;
stoe.HEALERS_ROLL = status.EFFECT_HEALERS_ROLL;
stoe.WIZARDS_ROLL = status.EFFECT_WIZARDS_ROLL;
stoe.WARLOCKS_ROLL = status.EFFECT_WARLOCKS_ROLL;
stoe.ROGUES_ROLL = status.EFFECT_ROGUES_ROLL;
stoe.GALLANTS_ROLL = status.EFFECT_GALLANTS_ROLL;
stoe.CHAOS_ROLL = status.EFFECT_CHAOS_ROLL;
stoe.BEAST_ROLL = status.EFFECT_BEAST_ROLL;
stoe.CHORAL_ROLL = status.EFFECT_CHORAL_ROLL;
stoe.HUNTERS_ROLL = status.EFFECT_HUNTERS_ROLL;
stoe.SAMURAI_ROLL = status.EFFECT_SAMURAI_ROLL;
stoe.NINJA_ROLL = status.EFFECT_NINJA_ROLL;
stoe.DRACHEN_ROLL = status.EFFECT_DRACHEN_ROLL;
stoe.EVOKERS_ROLL = status.EFFECT_EVOKERS_ROLL;
stoe.MAGUSS_ROLL = status.EFFECT_MAGUSS_ROLL;
stoe.CORSAIRS_ROLL = status.EFFECT_CORSAIRS_ROLL;
stoe.PUPPET_ROLL = status.EFFECT_PUPPET_ROLL;
stoe.DANCERS_ROLL = status.EFFECT_DANCERS_ROLL;
stoe.SCHOLARS_ROLL = status.EFFECT_SCHOLARS_ROLL;

return packets;
