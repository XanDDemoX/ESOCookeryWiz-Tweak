

CookeryWizLanguage = {}

local function cwl(obj)
  CookeryWizLanguage.language[#CookeryWizLanguage.language + 1] = obj
  return #CookeryWizLanguage.language
end


CookeryWizLanguage.language = {
  
}

CWL_COOKERYWIZ_TITLE = cwl("Cookery Wiz")
CWL_COOKERYWIZMAILER_TITLE = cwl("Mail Known Recipes")
CWL_COOKERYWIZOPTIONS_TITLE = cwl("Options")

CWL_FILTER_ALL = cwl("All")
CWL_FILTER_KNOWN = cwl("Known")
CWL_FILTER_UNKNOWN = cwl("Unknown")
CWL_FILTER_QUANTITY = cwl("Quantity")
CWL_FILTER_TEXT_BLANK = cwl("Filter Text...")

-- Mailer entries
CWL_LABEL_MAILER_DESCRIPTION_TEXT = cwl("This will send a list of your known recipes to the receiver. They must have CookeryWiz installed to use it")
CWL_LABEL_MAILER_ADDRESS_TEXT = cwl("To Recipient")
CWL_LABEL_MAILER_CHARACTER_TEXT = cwl("From Character")
CWL_LABEL_MAILER_SENT_SUCCESS = cwl("Mail Sent")
CWL_LABEL_MAILER_SENT_FAILED = cwl("Failed")

CWL_EDIT_MAILER_ADDRESS_BLANK_TEXT = cwl("Enter address ...")

CWL_BUTTON_MAILER_TOOLTIP_SENDMAIL = cwl("Send known recipes to recipient")
CWL_BUTTON_MAILER_SENDMAIL = cwl("Send")

-- Options
CWL_LABEL_OPTIONS_GENERAL_OPTIONS_TEXT = cwl("General Options")
CWL_LABEL_OPTIONS_ACCOUNT_OPTIONSL_TEXT = cwl("Character Options")
CWL_LABEL_OPTIONS_IMPORTED_OPTIONS_TEXT = cwl("Imported Character Options")

CWL_LABEL_OPTIONS_ACCOUNT_CHARACTER_TEXT = cwl("Character")
CWL_LABEL_OPTIONS_IMPORTED_CHARACTER_TEXT = cwl("Character")
CWL_LABEL_OPTIONS_DISABLE_SHRINK_TEXT = cwl("Disable Shrink")

CWL_BUTTON_OPTIONS_DISABLE = cwl("Disable")
CWL_BUTTON_OPTIONS_ENABLE = cwl("Enable")
CWL_BUTTON_OPTIONS_DELETE = cwl("Delete")

CWL_BUTTON_OPTIONS_DISABLE_TOOLTIP = cwl("Stop %s from using this character.")
CWL_BUTTON_OPTIONS_ENABLE_TOOLTIP = cwl("Allow %s to use this character.")
CWL_BUTTON_OPTIONS_DELETE_TOOLTIP = cwl("Delete this imported character.")
CWL_BUTTON_OPTIONS_DISABLE_SHRINK_TOOLTIP = cwl("Disable shrink functionality.")

-- Main dialog
CWL_EDIT_TOOLTIP_SEARCH = cwl("Enter text to filter recipes")
CWL_EDIT_TOOLTIP_COPY_LINK = cwl("Copy the selected link using your keyboard controls")

CWL_MENU_ITEM_COPY_LINK = cwl("Copy Link - %s")

CWL_NOTIFY_WRIT_ADDED = cwl("Adding Writ Food")
CWL_NOTIFY_NOT_SCANNING = cwl("%s Not Scanning Mailbox: [%u] items")
CWL_NOTIFY_SCANNING = cwl("%s Scanning Mailbox: [%u] items")
CWL_NOTIFY_IMPORTING_CHARACTER = cwl("%s Importing character %s")
CWL_NOTIFY_CRAFTING = cwl("Crafting %s [%u]")
CWL_NOTIFY_NO_ITEMS_LEFT = cwl("No items left we can cook")
CWL_NOTIFY_MAIL_MISSING_BODY = cwl("Problem: Mail has no body")
CWL_NOTIFY_BLANK_ADDRESS = cwl("You must enter an address")
CWL_NOTIFY_COOKING_CANCELLED = cwl("Cooking Cancelled")

CWL_CHAT_OPTION_TOGGLE = cwl("toggle")
CWL_CHAT_OPTION_SHOW = cwl("show")
CWL_CHAT_OPTION_HIDE = cwl("hide")

CWL_COMBO_TOOLTIP_CHARACTER = cwl("View recipes for character")
CWL_COMBO_TOOLTIP_RECIPE_CATEGORY = cwl("Filter recipes by category")
CWL_COMBO_TOOLTIP_FILTER_LEVEL = cwl("Filter recipes by food level")

CWL_BUTTON_TOOLTIP_CLEAR_SEARCH = cwl("Clear search text")
CWL_BUTTON_TOOLTIP_OPTIONS = cwl("Options")
CWL_BUTTON_TOOLTIP_CLEAR_ORDERS = cwl("Clear quantity for every recipe")
CWL_BUTTON_TOOLTIP_COOK = cwl("Cook all orders when using a Cooking Fire")
CWL_BUTTON_TOOLTIP_COOK_CANCEL = cwl("Cancel the cooking process")
CWL_BUTTON_TOOLTIP_MAILER = cwl("Mail")
CWL_BUTTON_TOOLTIP_RELOAD = cwl("Refresh recipes and ingredients")
CWL_BUTTON_TOOLTIP_CLOSE = cwl("Close")
CWL_BUTTON_TOOLTIP_EXPAND = cwl("Expand")
CWL_BUTTON_TOOLTIP_SHRINK = cwl("Shrink")
CWL_BUTTON_TOOLTIP_COLLAPSE = cwl("Collapse")

CWL_BUTTON_TOOLTIP_QUALITY_FILTER = cwl("Click to filter recipes on quality")

CWL_BUTTON_COOK = cwl("Cook")
CWL_BUTTON_COOK_CANCEL = cwl("Cancel")

CWL_BUTTON_CLEAR_ORDERS = cwl("Clear Orders")

CWL_QUALITY_FINE = cwl("Fine")
CWL_QUALITY_SUPERIOR = cwl("Superior")
CWL_QUALITY_EPIC = cwl("Epic")
CWL_QUALITY_LEGENDARY = cwl("Legendary")


CWL_QUEST_PROVISIONER_WRIT_TITLE = cwl("Provisioner Writ")

CWL_OR_FUNCTION = cwl(function(item1, item2)
    return item1.." or "..item2
  end)