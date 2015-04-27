--[[
  Thanks to ThalonMook for the initial translation
  V 1.0.10
]]--
local L = CookeryWizLanguage.language

L[CWL_COOKERYWIZ_TITLE] = "Cookery Wiz"
L[CWL_COOKERYWIZMAILER_TITLE] = "Maile bekannte Rezepte"
L[CWL_COOKERYWIZOPTIONS_TITLE] = "Optionen"

L[CWL_FILTER_ALL] = "Alle"
L[CWL_FILTER_KNOWN] = "Bekannt"
L[CWL_FILTER_UNKNOWN] = "Unbekannt"
L[CWL_FILTER_QUANTITY] = "Anzahl"
L[CWL_FILTER_TEXT_BLANK] = "Filter Text..."

-- Mailer entries
L[CWL_LABEL_MAILER_DESCRIPTION_TEXT] = "Dieser Befehl sendet alle bekannten Rezepte zum Empfänger. Dieser muss den CookeryWiz installiert haben um es zu nutzen."
L[CWL_LABEL_MAILER_ADDRESS_TEXT] = "Zu Empfänger"
L[CWL_LABEL_MAILER_CHARACTER_TEXT] = "Von Charakter"
L[CWL_LABEL_MAILER_SENT_SUCCESS] = "Mail Senden"
L[CWL_LABEL_MAILER_SENT_FAILED] = "Fehlgeschlagen"

L[CWL_EDIT_MAILER_ADDRESS_BLANK_TEXT] = "Adresse eingeben..."

L[CWL_BUTTON_MAILER_TOOLTIP_SENDMAIL] = "Sende bekannte Rezepte zum Empfänger"
L[CWL_BUTTON_MAILER_SENDMAIL] = "Sende"

-- Options
L[CWL_LABEL_OPTIONS_GENERAL_OPTIONS_TEXT] = "Allgemeine Optionen"
L[CWL_LABEL_OPTIONS_ACCOUNT_OPTIONSL_TEXT] = "Charakter Optionen"
L[CWL_LABEL_OPTIONS_IMPORTED_OPTIONS_TEXT] = "Importierter Charakter Optionen"

L[CWL_LABEL_OPTIONS_ACCOUNT_CHARACTER_TEXT] = "Charakter"
L[CWL_LABEL_OPTIONS_IMPORTED_CHARACTER_TEXT] = "Charakter"
L[CWL_LABEL_OPTIONS_DISABLE_SHRINK_TEXT] = "Deaktiviere Verkleinern"

L[CWL_BUTTON_OPTIONS_DISABLE] = "Deaktiviere"
L[CWL_BUTTON_OPTIONS_ENABLE] = "Aktivieren"
L[CWL_BUTTON_OPTIONS_DELETE] = "Löschen"

L[CWL_BUTTON_OPTIONS_DISABLE_TOOLTIP] = "Deaktiviere %s für diesen Charakter."
L[CWL_BUTTON_OPTIONS_ENABLE_TOOLTIP] = "Aktiviere %s für diesen Charakter."
L[CWL_BUTTON_OPTIONS_DELETE_TOOLTIP] = "Lösche diesen importierten Charakter."
L[CWL_BUTTON_OPTIONS_DISABLE_SHRINK_TOOLTIP] = "Deaktiviere verkleinern Funktion."

-- Main dialog
L[CWL_EDIT_TOOLTIP_SEARCH] = "Zum Rezepte filtern Text eingeben"
L[CWL_EDIT_TOOLTIP_COPY_LINK] = "Copy the selected link using your keyboard controls"

L[CWL_MENU_ITEM_COPY_LINK] = "Copy Link - %s"

L[CWL_NOTIFY_WRIT_ADDED] = "Füge Essensliste hinzu"
L[CWL_NOTIFY_NOT_SCANNING] = "%s Mailbox nicht scannen: [%u] Gegenstände"
L[CWL_NOTIFY_SCANNING] = "%s Scanne Mailbox: [%u] Gegenstände"
L[CWL_NOTIFY_IMPORTING_CHARACTER] = "%s Importiere Charakter %s"
L[CWL_NOTIFY_CRAFTING] = "Handwerk %s [%u]"
L[CWL_NOTIFY_NO_ITEMS_LEFT] = "Nichts mehr zum Kochen übrig"
L[CWL_NOTIFY_MAIL_MISSING_BODY] = "Problem: Mail hat keinen Inhalt"
L[CWL_NOTIFY_BLANK_ADDRESS] = "Du musst eine Adresse eingeben"
L[CWL_NOTIFY_COOKING_CANCELLED] = "Kochen abgebrochen"

L[CWL_CHAT_OPTION_TOGGLE] = "umschalten"
L[CWL_CHAT_OPTION_SHOW] = "zeige"
L[CWL_CHAT_OPTION_HIDE] = "verstecke"

L[CWL_COMBO_TOOLTIP_CHARACTER] = "Zeige Rezepte für Charakter"
L[CWL_COMBO_TOOLTIP_RECIPE_CATEGORY] = "Filter Rezepte nach Kategorie"

L[CWL_COMBO_TOOLTIP_RECIPE_CATEGORY] = "Filter recipes by category"
L[CWL_COMBO_TOOLTIP_FILTER_LEVEL] = "Filter recipes by food level"

L[CWL_BUTTON_TOOLTIP_CLEAR_SEARCH] = "Lösche Suchtext"
L[CWL_BUTTON_TOOLTIP_OPTIONS] = "Optionen"
L[CWL_BUTTON_TOOLTIP_CLEAR_ORDERS] = "Lösche Anzahl für jedes Rezept"
L[CWL_BUTTON_TOOLTIP_COOK] = "Koche alle Aufträge wenn Feuerstelle benutzt wird"
L[CWL_BUTTON_TOOLTIP_COOK_CANCEL] = "Breche den Kochprozess ab"
L[CWL_BUTTON_TOOLTIP_MAILER] = "Mail"
L[CWL_BUTTON_TOOLTIP_RELOAD] = "Erneuere Rezepte und Zutaten"
L[CWL_BUTTON_TOOLTIP_CLOSE] = "Schließen"
L[CWL_BUTTON_TOOLTIP_EXPAND] = "Erweitern"
L[CWL_BUTTON_TOOLTIP_SHRINK] = "Verkleinern"
L[CWL_BUTTON_TOOLTIP_COLLAPSE] = "Einklappen"

L[CWL_BUTTON_TOOLTIP_QUALITY_FILTER] = "Klicke um Rezepte nach Qualität zu filtern"

L[CWL_BUTTON_COOK] = "Koche"
L[CWL_BUTTON_COOK_CANCEL] = "Abbrechen"

L[CWL_BUTTON_CLEAR_ORDERS] = "Lösche Aufträge"

L[CWL_QUALITY_FINE] = "Fein"
L[CWL_QUALITY_SUPERIOR] = "Überlegen"
L[CWL_QUALITY_EPIC] = "Episch"
L[CWL_QUALITY_LEGENDARY] = "Legendär"


L[CWL_QUEST_PROVISIONER_WRIT_TITLE] = "Versorger Schreiben"

L[CWL_OR_FUNCTION] = function(item1, item2)
    return item1.." oder "..item2
  end