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
    PACKET_NPC_INTERACTION_2 = 0x34,
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
    EFFECT_RERAISE                  = 113,
    EFFECT_PAEON                    = 195,
    EFFECT_BALLAD                   = 196,
    EFFECT_MINUET                   = 198,
    EFFECT_FOOD                     = 251,
    EFFECT_POISON_II                = 540,
  },

  spells = {
    POISONA = 14,
    PARALYNA = 15,
    BLINDNA = 16,
    PROTECT = 43,
    SHELL = 48,
    STONESKIN = 54,
    PROTECTRA = 125,
    SHELLRA = 130,
  }

};
return packets;
