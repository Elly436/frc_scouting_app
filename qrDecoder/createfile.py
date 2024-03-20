from openpyxl import Workbook

workbook = Workbook()
workbook.create_sheet("6364")
workbook.create_sheet("personal score ranking")
workbook.create_sheet("amp ranking")
workbook.create_sheet("speaker ranking")
workbook.remove(workbook["Sheet"])

workbook.save(filename="idahotest2.xlsx")