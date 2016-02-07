local packets = {

  out = { -- outgoing
    PACKET_NPC_INTERACTION = 0x1A,
    PACKET_NPC_CHOICE = 0x5B,
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
  }

};
return packets;
