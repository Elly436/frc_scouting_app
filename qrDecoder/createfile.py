from openpyxl import Workbook
import spreadsheetCom

workbook = Workbook()
for category in spreadsheetCom.rankingCategories:
    workbook.create_sheet(category + " ranking")
    workbook[category + " ranking"].append(["team", "average", "last 5 matches average"])
    workbook["personal score ranking"].freeze_panes = "A2"
workbook.remove(workbook["Sheet"])



workbook.save(filename= spreadsheetCom.file_name + ".xlsx")