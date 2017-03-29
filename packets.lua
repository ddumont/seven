local packets = {

  out = { -- outgoing
    PACKET_NPC_INTERACTION = 0x1A,
    PACKET_NPC_CHOICE = 0x5B,
    PACKET_IDX_UPDATE = 0x15
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

  status = {
    EFFECT_POISON                   = 3,
    EFFECT_PARALYSIS                = 4,
    EFFECT_BLINDNESS                = 5,
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
    EFFECT_MAZURKA                  = 219,
    EFFECT_FOOD                     = 251,
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
    DIA = 23,
    PROTECT = 43,
    PROTECT_II = 44,
    SHELL = 48,
    SHELL_II = 49,
    STONESKIN = 54,
    PROTECTRA = 125,
    SHELLRA = 130,
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
    ARMYS_PAEON = 378,
    ARMYS_PAEON_II = 379,
    ARMYS_PAEON_III = 380,
    ARMYS_PAEON_IV = 381,
    MAGES_BALLAD = 386,
    MAGES_BALLAD_II = 387,
    KNIGHTS_MINNE = 389,
    KNIGHTS_MINNE_II = 390,
    VALOR_MINUET = 394,
    VALOR_MINUET_II = 395,
    VALOR_MINUET_III = 396,
    HERB_PASTORAL = 406,
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

  stoe = {}
};

packets.stoe.MAGES_BALLAD = packets.status.EFFECT_BALLAD;
packets.stoe.MAGES_BALLAD_II = packets.status.EFFECT_BALLAD;
packets.stoe.ARMYS_PAEON = packets.status.EFFECT_PAEON;
packets.stoe.ARMYS_PAEON_II = packets.status.EFFECT_PAEON;
packets.stoe.ARMYS_PAEON_III = packets.status.EFFECT_PAEON;
packets.stoe.ARMYS_PAEON_IV = packets.status.EFFECT_PAEON;
packets.stoe.RAPTOR_MAZURKA = packets.status.EFFECT_MAZURKA;
packets.stoe.DRAIN_SAMBA = packets.status.EFFECT_DRAIN_SAMBA;
packets.stoe.PHANTOM_ROLL = packets.status.EFFECT_PHANTOM_ROLL;
packets.stoe.FIGHTERS_ROLL = packets.status.EFFECT_FIGHTERS_ROLL;
packets.stoe.MONKS_ROLL = packets.status.EFFECT_MONKS_ROLL;
packets.stoe.HEALERS_ROLL = packets.status.EFFECT_HEALERS_ROLL;
packets.stoe.WIZARDS_ROLL = packets.status.EFFECT_WIZARDS_ROLL;
packets.stoe.WARLOCKS_ROLL = packets.status.EFFECT_WARLOCKS_ROLL;
packets.stoe.ROGUES_ROLL = packets.status.EFFECT_ROGUES_ROLL;
packets.stoe.GALLANTS_ROLL = packets.status.EFFECT_GALLANTS_ROLL;
packets.stoe.CHAOS_ROLL = packets.status.EFFECT_CHAOS_ROLL;
packets.stoe.BEAST_ROLL = packets.status.EFFECT_BEAST_ROLL;
packets.stoe.CHORAL_ROLL = packets.status.EFFECT_CHORAL_ROLL;
packets.stoe.HUNTERS_ROLL = packets.status.EFFECT_HUNTERS_ROLL;
packets.stoe.SAMURAI_ROLL = packets.status.EFFECT_SAMURAI_ROLL;
packets.stoe.NINJA_ROLL = packets.status.EFFECT_NINJA_ROLL;
packets.stoe.DRACHEN_ROLL = packets.status.EFFECT_DRACHEN_ROLL;
packets.stoe.EVOKERS_ROLL = packets.status.EFFECT_EVOKERS_ROLL;
packets.stoe.MAGUSS_ROLL = packets.status.EFFECT_MAGUSS_ROLL;
packets.stoe.CORSAIRS_ROLL = packets.status.EFFECT_CORSAIRS_ROLL;
packets.stoe.PUPPET_ROLL = packets.status.EFFECT_PUPPET_ROLL;
packets.stoe.DANCERS_ROLL = packets.status.EFFECT_DANCERS_ROLL;
packets.stoe.SCHOLARS_ROLL = packets.status.EFFECT_SCHOLARS_ROLL;

return packets;
